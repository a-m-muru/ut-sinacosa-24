class_name Region extends Node2D

# a region houses a square full of stars to break up the world into smaller pieces

const STAR := preload("res://scenes/world/stars/star.tscn")
const PLANET := preload("res://scenes/world/planets/planet.tscn")
const TRASH := preload("res://scenes/world/trash/trash.tscn")
const SIZE := Vector2(1920, 1920)

var desired_stars := 100
var reg_position := Vector2()

# visualise region size and position
#func _draw() -> void:
	#draw_rect(Rect2(-SIZE/2, SIZE), Color(Color.PURPLE, 0.3))
	#draw_rect(Rect2(-SIZE/2, SIZE), Color(Color.PURPLE), false)


@warning_ignore("integer_division", "narrowing_conversion")
func _ready() -> void:
	modulate.a = 0
	# spawn less stars if some have been collected here
	if reg_position in GLOBAL.remaining_stars:
		desired_stars = GLOBAL.remaining_stars[reg_position]
	for i in desired_stars:
		var s := create_star()
		add_child(s)
		# random position in the bounds of the region
		s.position += (Vector2(randf_range(-SIZE.x/2, SIZE.x/2), randf_range(-SIZE.y/2, SIZE.y/2)))
	if reg_position != Vector2.ZERO:
		for j in 5:
			var trash := create_trash()
			add_child(trash)
			trash.position += (Vector2(randf_range(-SIZE.x/2, SIZE.x/2), randf_range(-SIZE.y/2, SIZE.y/2)))
	# spawn planets in the centers of some regions
	if (hash(reg_position) + GLOBAL.run_random) % 10 < 6 and reg_position != Vector2.ZERO:
		var planet := create_planet()
		add_child(planet)


func save_removed_stars() -> void:
	GLOBAL.remaining_stars[reg_position] = get_child_count()


# turn a global position into a region grid position
static func region_position(gpos: Vector2) -> Vector2:
	return ((gpos + SIZE/2) / SIZE).floor()


static func create_star() -> Star:
	var star := STAR.instantiate()
	star.direction = Vector2(randf(), randf()) * randf_range(-1, 1) * 15
	return star


static func create_planet() -> Planet:
	var planet := PLANET.instantiate()
	return planet


static func create_trash() -> Trash:
	var trash := TRASH.instantiate()
	trash.direction = Vector2(randf(), randf()) * randf_range(-1, 1) * 32
	return trash


static func stellar_explosion(
		source: SpaceFloater,
		amount: int,
		start_distance: float,
		impulse_mult: float,
		impulse_rand := Vector2.ZERO
) -> void:
	for i in amount:
		var s := Region.create_star()
		source.add_sibling(s)
		# spawned away from the epicentre to avoid getting instantly vacuumed
		s.position = source.position + Vector2.from_angle(randf() * TAU) * start_distance
		s.apply_impulse((s.position - source.position) * (impulse_mult + randf_range(impulse_rand.x, impulse_rand.y)))
		s.scale *= 0.5
		s.modulate = Color(randf(), randf(), randf()).lightened(0.5)
