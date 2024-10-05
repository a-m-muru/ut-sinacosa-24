class_name SpaceFloater extends Area2D

# parent class for things that float aimlessly in space

const DECEL := 400

@export var scale_range := Vector2(1, 1)
@export var rotation_range := Vector2(0, 0)

var _velocity: Vector2
var direction: Vector2
var rotation_direction: float


func _ready() -> void:
	var scle := randf_range(scale_range.x, scale_range.y)
	scale = Vector2(scle, scle)
	rotation = randf_range(rotation_range.x, rotation_range.y)
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
