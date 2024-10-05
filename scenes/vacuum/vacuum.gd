class_name Vacuum extends CharacterBody2D

enum States {FROZEN, MOVABLE, SPRINTING}

const ACCEL := 2400
const DECEL := 1600

const MOVE_SPEED := 500
const SPRINT_SPEED := 720

const DISTANCE_STAR_CURVE := preload("res://scenes/vacuum/distance_star_curve.tres")

@onready var collection_area: Area2D = $"CollectionArea"
@onready var vacuum_suck_shape: CircleShape2D = $CollectionArea/CollisionShape2D.shape
@onready var sprite: Sprite2D = $Sprite

var move_speed := MOVE_SPEED
var _affected_stars: Array[SpaceFloater] = []
var state := States.MOVABLE


func _ready() -> void:
	collection_area.area_entered.connect(_star_entered)


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
	
			move_and_slide()
	
	_affect_stars(delta)


func _star_entered(star: Area2D) -> void:
	if not star is SpaceFloater:
		return
	if star.is_queued_for_deletion():
		return
	_affected_stars.append(star)


func _star_exited(floater: SpaceFloater) -> void:
	if floater is Star:
		if floater.scale.x > 1:
			Region.stellar_explosion(floater, roundi(floater.scale.x / 0.22), 70, 7)
	if floater in _affected_stars:
		_affected_stars.erase(floater)


func _free_star(star: SpaceFloater) -> void:
	if not star is Star:
		return
	if not star in _affected_stars:
		var tw := create_tween()
		tw.tween_property(star, "scale", Vector2.ZERO, 0.1)
		tw.tween_callback(star.queue_free)
		GLOBAL.stars_vacuumed += 1


func _affect_stars(delta: float) -> void:
	for star in _affected_stars:
		if not is_instance_valid(star):
			_clean_affected()
			return
		var star_distance := star.global_position.distance_to(global_position)
		star_distance /= vacuum_suck_shape.radius
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
	for star in _affected_stars:
		var star_distance := star.global_position.distance_squared_to(global_position)
		if star_distance < 20:
			add_score(star.scale.x)
			_star_exited(star)
			_free_star(star)
			break
	#queue_redraw()


func _clean_affected() -> void:
	var narr: Array[SpaceFloater]
	narr.assign(_affected_stars.filter(func(a) -> bool: return is_instance_valid(a) and a is SpaceFloater))
	_affected_stars = narr


func add_score(amount: float) -> void:
	if not GLOBAL.challenger:
		return
	GLOBAL.challenger.add_score(amount)
