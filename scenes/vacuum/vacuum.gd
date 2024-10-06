class_name Vacuum extends CharacterBody2D

# the vacuum sucks up stars and is what the player controls

enum States {
	FROZEN = 0b001, # cannot move
	MOVABLE = 0b010, # move
	SPRINTING = 0b110, # move faster
}

const ACCEL := 2400
const DECEL := 1600

const MOVE_SPEED := 500
const SPRINT_SPEED := 720

const DISTANCE_STAR_CURVE := preload("res://scenes/vacuum/distance_star_curve.tres")

@onready var collection_area: Area2D = $"CollectionArea"
@onready var vacuum_suck_shape: CircleShape2D = $CollectionArea/CollisionShape2D.shape
@onready var sprite: Sprite2D = $Sprite
@onready var particles: GPUParticles2D = $Sprite/Particles
@onready var vacuum_noise: AudioStreamPlayer2D = $VacuumNoise
@onready var star_collect_sound: AudioStreamPlayer2D = $StarCollectSound
@onready var star_explode_sound: AudioStreamPlayer2D = $StarExplodeSound
@onready var tutorial: Sprite2D = $Sprite/Tutorial

var move_speed := MOVE_SPEED
var _affected_stars: Array[SpaceFloater] = []
var state := States.MOVABLE


func _ready() -> void:
	collection_area.area_entered.connect(_star_entered)
	var t := create_tween()
	t.tween_interval(2.0)
	t.tween_property(tutorial, "modulate:a", 0.0, 2.0)
	t.tween_callback(tutorial.queue_free)


func _physics_process(delta: float) -> void:
	match state:
		States.FROZEN:
			pass
		States.MOVABLE, States.SPRINTING:
			var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			if Input.is_action_pressed("mouse_press"):
				input = (get_global_mouse_position() - global_position).limit_length(1.0)
			
			if Input.is_action_pressed("sprint"):
				move_speed = SPRINT_SPEED
				state = States.SPRINTING
			else:
				move_speed = MOVE_SPEED
				state = States.MOVABLE
	
			if input:
				velocity = velocity.move_toward(input * move_speed, delta * ACCEL)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, delta * DECEL)
				
			process_particles()
			vacuum_noise.pitch_scale = maxf(0.1, velocity.length_squared()) / MOVE_SPEED**2
	
			move_and_slide()
	
	_affect_stars(delta)


# triggered when a star comes close to the sucking area
func _star_entered(star: Area2D) -> void:
	if not star is SpaceFloater:
		return
	# stars are frequently deleted
	if star.is_queued_for_deletion():
		return
	_affected_stars.append(star)


func _star_exited(floater: SpaceFloater) -> void:
	if floater in _affected_stars:
		_affected_stars.erase(floater)
	if floater is Star:
		# bigger stars explode into smaller ones
		if floater.scale.x > 1:
			star_explode_sound.play()
			Region.stellar_explosion(floater, roundi(floater.scale.x / 0.22), 70, 7)
		return


func _free_star(star: SpaceFloater) -> void:
	# do not free planets
	if star is Trash:
		star.apply_impulse(Vector2.from_angle(randf() * TAU) * 840)
		star.noise.play()
		var tw := star.create_tween()
		tw.tween_property(star.particles, "amount_ratio", 0.0, 2.0).from(1.0)
		add_score(-10)
		var t := create_tween().set_trans(Tween.TRANS_BOUNCE)
		t.tween_property(vacuum_noise, "pitch_scale", randf() + 0.8, randf())
		t.tween_property(vacuum_noise, "pitch_scale", randf() + 0.8, randf())
		t.tween_property(vacuum_noise, "pitch_scale", randf() + 0.8, randf())
		t.tween_property(vacuum_noise, "pitch_scale", randf() + 0.8, randf())
		return
	if not star is Star:
		return
	if not star in _affected_stars:
		var tw := create_tween()
		star_collect_sound.play()
		GLOBAL.stars_vacuumed += 1
		add_score(star.scale.x)
		tw.tween_property(star, "scale", Vector2.ZERO, 0.1)
		tw.tween_callback(star.queue_free)


func _affect_stars(delta: float) -> void:
	# don't suck while frozen
	if (state & States.FROZEN) != 0:
		return
	for star in _affected_stars:
		# deleted stars must be removed from the list
		if not is_instance_valid(star):
			_clean_affected()
			return
		var star_distance := star.global_position.distance_to(global_position)
		star_distance /= vacuum_suck_shape.radius
		
		# vacuum shouldn't effect things far away
		if star_distance > 2:
			_star_exited(star)
		
		if star is Planet:
			star.vacuum_collision_response(self)
			continue
		
		#draw.connect(func():
			#draw_circle(Vector2.ZERO, 1, Color.AQUA)
			#draw_rect(Rect2(to_local(star.global_position), Vector2(4, -star_distance * 12)), Color.WHITE)
			#draw_rect(Rect2(to_local(star.global_position) + Vector2(4, 0), Vector2(4, -star.global_position.distance_to(global_position))), Color.WHITE)
		#, CONNECT_ONE_SHOT)
		var star_speed := DISTANCE_STAR_CURVE.sample_baked(star_distance)
		star.global_position = (star.global_position.move_toward(global_position,
				delta * star_speed * 2))
	
	# gobble up close enough stars
	for star in _affected_stars:
		var star_distance := star.global_position.distance_squared_to(global_position)
		if star_distance < 20:
			_star_exited(star)
			_free_star(star)
			break
	#queue_redraw()


# remove invalid stars from the list
func _clean_affected() -> void:
	var narr: Array[SpaceFloater]
	narr.assign(_affected_stars.filter(func(a) -> bool: return is_instance_valid(a) and a is SpaceFloater))
	_affected_stars = narr


func add_score(amount: float) -> void:
	GLOBAL.check_star_completion()
	if not GLOBAL.challenger:
		return
	GLOBAL.challenger.add_score(amount)


func process_particles(ifreal := true) -> void:
	if not ifreal:
		particles.amount_ratio = 0
		return
	particles.amount_ratio = velocity.length_squared() / (SPRINT_SPEED**2)
