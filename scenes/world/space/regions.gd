class_name Regions extends Node2D

# this manages multiple regions that split the world's stars into a grid

const NEIGHBOUR_REGS := [Vector2.LEFT, Vector2.RIGHT,
	Vector2.UP, Vector2.DOWN,
	Vector2(1, 1), Vector2(-1, 1),
	Vector2(1, -1), Vector2(-1, -1)]

# for code completion
const CutsceneType := preload("res://scenes/world/space/smaller_cutscene.gd")

# spawn regions around this node
@export var follow: Node2D
@export var cutscene: CutsceneType
var _follow_reg_pos: Vector2

# child regions can be accessed by their grid position
# grid pos -> child reference
var by_position := {}


func _ready() -> void:
	GLOBAL.regions = self
	create_region_neighbours(Vector2(0, 0))


func create_region_neighbours(center_region_pos: Vector2) -> void:
	for n in NEIGHBOUR_REGS:
		create_region(center_region_pos + n)
	create_region(center_region_pos)


@warning_ignore("narrowing_conversion")
func create_region(region_pos: Vector2) -> void:
	if not region_pos in by_position:
		var new_region := Region.new()
		by_position[region_pos] = new_region
		new_region.name = str(region_pos)
		new_region.reg_position = region_pos
		new_region.global_position = Region.SIZE * region_pos
		new_region.desired_stars = clampf((GLOBAL.STARS_PER_LEVEL - GLOBAL.stars_vacuumed), 0, 99)
		add_child(new_region)
		var tw := create_tween()
		tw.tween_property(new_region, "modulate:a", 1.0, 1.0).from(0.0)


func _process(delta: float) -> void:
	var reg_pos := Region.region_position(follow.global_position)
	if reg_pos != _follow_reg_pos:
		create_region_neighbours(reg_pos)
		_follow_reg_pos = reg_pos
		_process_faraway_regions()


# erase regions that are far away
func _process_faraway_regions() -> void:
	var keys_to_erase := []
	for region_pos: Vector2 in by_position.keys():
		var region: Region = by_position[region_pos]
		if region_pos.distance_squared_to(_follow_reg_pos) > 4:
			region.save_removed_stars()
			region.queue_free()
			keys_to_erase.append(region_pos)
	for region_pos in keys_to_erase:
		by_position.erase(region_pos)


# fade out all regions
func destroy_children() -> void:
	var keys_to_erase := []
	for region_pos: Vector2 in by_position.keys():
		var region: Region = by_position[region_pos]
		var tw := create_tween()
		tw.tween_property(region, "modulate:a", 0.0, 1.0)
		tw.tween_callback(region.queue_free)
	for region_pos: Vector2 in by_position.keys():
		by_position.erase(region_pos)
