extends Area2D

const SPEED := 720
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var stars := []


func _ready() -> void:
	area_entered.connect(_star_entered)
	area_exited.connect(_star_exited)


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	global_position += input * delta * SPEED
	
	for star: Area2D in stars:
		var distance := global_position.distance_squared_to(star.global_position)
		var inverse: float = collision_shape_2d.shape.radius**2 * 2 - distance
		star.global_position = star.global_position.move_toward(global_position, delta * inverse * 0.01)
		if star.global_position.distance_squared_to(global_position) < 10:
			_star_exited(star)
			star.queue_free()


func _star_entered(star_area: Area2D) -> void:
	stars.append(star_area)


func _star_exited(star_area: Area2D) -> void:
	if star_area in stars:
		stars.erase(star_area)
