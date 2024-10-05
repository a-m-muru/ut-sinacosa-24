extends CharacterBody2D

enum States {FROZEN, MOVABLE, SPRINTING}

const ACCEL := 2400
const DECEL := 1600

const MOVE_SPEED := 500
const SPRINT_SPEED := 720

const DISTANCE_STAR_CURVE := preload("res://scenes/vacuum/distance_star_curve.tres")

@onready var collection_area: Area2D = $"CollectionArea"
@onready var vacuum_suck_shape: CircleShape2D = $CollectionArea/CollisionShape2D.shape

var move_speed := MOVE_SPEED
var _affected_stars: Array[Star] = []
var state := States.MOVABLE


func _ready() -> void:
	collection_area.area_entered.connect(_star_entered)


func _physics_process(delta: float) -> void:
	match state:
		States.FROZEN:
			pass
		States.MOVABLE, States.SPRINTING:
			var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
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
	if star.is_queued_for_deletion():
		return
	_affected_stars.append(star)


func _star_exited(star: Area2D) -> void:
	if star in _affected_stars:
		_affected_stars.erase(star)


func _free_star(star: Star) -> void:
	if not star in _affected_stars:
		star.queue_free()
		GLOBAL.stars_vacuumed += 1
		print(GLOBAL.stars_vacuumed)


func _affect_stars(delta: float) -> void:
	for star in _affected_stars:
		var star_distance := star.global_position.distance_to(global_position)
		star_distance /= vacuum_suck_shape.radius
		#draw.connect(func():
			#draw_circle(Vector2.ZERO, 1, Color.AQUA)
			#draw_rect(Rect2(to_local(star.global_position), Vector2(4, -star_distance * 12)), Color.WHITE)
			#draw_rect(Rect2(to_local(star.global_position) + Vector2(4, 0), Vector2(4, -star.global_position.distance_to(global_position))), Color.WHITE)
		#, CONNECT_ONE_SHOT)
		var star_speed := DISTANCE_STAR_CURVE.sample_baked(star_distance)
		star.global_position = (star.global_position.move_toward(global_position,
				delta * star_speed * 2))
		if star_distance > 2:
			_star_exited(star)
	for star in _affected_stars:
		var star_distance := star.global_position.distance_squared_to(global_position)
		if star_distance < 20:
			_star_exited(star)
			_free_star(star)
			break
	#queue_redraw()
