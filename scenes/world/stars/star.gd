class_name Star extends Area2D

const DECEL := 400

var _velocity: Vector2
var direction: Vector2


func _physics_process(delta: float) -> void:
	_velocity = _velocity.move_toward(Vector2.ZERO, DECEL * delta)
	
	global_position += _velocity * delta
	global_position += direction * delta


func set_velocity(velo: Vector2) -> void:
	_velocity = velo


func apply_impulse(impulse: Vector2) -> void:
	_velocity += impulse
