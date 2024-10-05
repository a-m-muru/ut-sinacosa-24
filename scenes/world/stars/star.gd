class_name Star extends Area2D

const EYE_TEXTURES := [
	preload("res://scenes/world/stars/1.png"),
	preload("res://scenes/world/stars/1.small.png"),
	preload("res://scenes/world/stars/2 (1).png"),
	preload("res://scenes/world/stars/2.small.png"),
	preload("res://scenes/world/stars/3.e.png"),
	preload("res://scenes/world/stars/small.3.e.png"),
	preload("res://scenes/world/stars/small.4.e.png"),
]
const MOUTH_TEXTURES := [
	preload("res://scenes/world/stars/1..png"),
	preload("res://scenes/world/stars/1.small.m.png"),
	preload("res://scenes/world/stars/2 (2).png"),
	preload("res://scenes/world/stars/3.m.png"),
	preload("res://scenes/world/stars/small.3.m.png"),
]

const DECEL := 400

@onready var mouth: Sprite2D = $Face/Mouth
@onready var eyes: Sprite2D = $Face/Eyes
@onready var blink_timer: Timer = $BlinkTimer


var _velocity: Vector2
var direction: Vector2
var rotation_direction: float


func _ready() -> void:
	blink_timer.timeout.connect(_blink_timer_timeout)
	mouth.texture = MOUTH_TEXTURES.pick_random()
	eyes.texture = EYE_TEXTURES.pick_random()
	var scle := randf_range(0.4, 1.1)
	scale = Vector2(scle, scle)
	rotation = randf() * TAU
	rotation_direction = randf_range(-1, 1)


func _physics_process(delta: float) -> void:
	_velocity = _velocity.move_toward(Vector2.ZERO, DECEL * delta)
	
	global_position += _velocity * delta
	global_position += direction * delta
	
	rotation += rotation_direction * delta


func set_velocity(velo: Vector2) -> void:
	_velocity = velo


func apply_impulse(impulse: Vector2) -> void:
	_velocity += impulse


func _blink_timer_timeout() -> void:
	blink_timer.wait_time = 16 * randf()
	eyes.hide()
	create_tween().tween_interval(0.3).finished.connect(eyes.show)
