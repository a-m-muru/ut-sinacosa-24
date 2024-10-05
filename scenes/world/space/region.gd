class_name Region extends Node2D

const STAR := preload("res://scenes/world/stars/star.tscn")
const SIZE := Vector2(1920, 1920)

var desired_stars := 300
var reg_position := Vector2()


#func _draw() -> void:
	#draw_rect(Rect2(-SIZE/2, SIZE), Color(Color.PURPLE, 0.3))
	#draw_rect(Rect2(-SIZE/2, SIZE), Color(Color.PURPLE), false)


func _ready() -> void:
	if reg_position in GLOBAL.remaining_stars:
		desired_stars = GLOBAL.remaining_stars[reg_position]
	for i in desired_stars:
		var star := STAR.instantiate()
		star.position = Vector2(randf_range(-SIZE.x/2, SIZE.x/2), randf_range(-SIZE.y/2, SIZE.y/2))
		var nsample := GLOBAL.star_noise.get_noise_2dv(star.global_position)
		star.direction = Vector2(randfn(0, 1), randfn(0, 1)) * 10 * nsample
		star.global_position += Vector2(nsample, nsample) * 50
		add_child(star)


func save_removed_stars() -> void:
	GLOBAL.remaining_stars[reg_position] = get_child_count()


static func region_position(gpos: Vector2) -> Vector2:
	return ((gpos + SIZE/2) / SIZE).floor()
