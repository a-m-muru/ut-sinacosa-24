class_name Region extends Node2D

const STAR := preload("res://scenes/world/stars/star.tscn")
const SIZE := Vector2(1920, 1920)

var desired_stars := 100
var reg_position := Vector2()

#
#func _draw() -> void:
	#draw_rect(Rect2(-SIZE/2, SIZE), Color(Color.PURPLE, 0.3))
	#draw_rect(Rect2(-SIZE/2, SIZE), Color(Color.PURPLE), false)


@warning_ignore("integer_division", "narrowing_conversion")
func _ready() -> void:
	if reg_position in GLOBAL.remaining_stars:
		desired_stars = GLOBAL.remaining_stars[reg_position]
	for i in desired_stars:
		var s := create_star()
		add_child(s)
		s.position += (Vector2(randf_range(-SIZE.x/2, SIZE.x/2), randf_range(-SIZE.y/2, SIZE.y/2)))


func save_removed_stars() -> void:
	GLOBAL.remaining_stars[reg_position] = get_child_count()


static func region_position(gpos: Vector2) -> Vector2:
	return ((gpos + SIZE/2) / SIZE).floor()


static func create_star() -> Star:
	var star := STAR.instantiate()
	return star


static func stellar_explosion(source: SpaceFloater, amount: int, start_distance: float, impulse_mult: float) -> void:
	for i in amount:
		var s := Region.create_star()
		source.add_sibling(s)
		s.position = source.position + Vector2.from_angle(randf() * TAU) * start_distance
		s.apply_impulse((s.position - source.position) * impulse_mult)
		s.scale *= 0.5
