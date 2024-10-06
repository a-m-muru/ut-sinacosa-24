extends Node

# end or level change cutscene

const VACUUM := preload("res://scenes/vacuum/vacuum.tscn")
const NEW_SCALE := 6.0

@export var current_vacuum: Vacuum
@export var camera: Camera2D
@export var regions: Regions
@export var para_layers: Array[Parallax2D]


# DEBUG, testing, remove from release
func _input(event: InputEvent) -> void:
	if not OS.has_feature("editor"):
		return
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_END:
			play()


func play() -> void:
	# hide all stars
	regions.destroy_children()
	var tw := create_tween()
	current_vacuum.state = Vacuum.States.FROZEN
	# spawn a huge vacuum to the side
	var new_vacuum := VACUUM.instantiate()
	current_vacuum.add_sibling(new_vacuum)
	new_vacuum.state = Vacuum.States.FROZEN
	new_vacuum.scale = Vector2.ONE * NEW_SCALE
	new_vacuum.global_position = current_vacuum.global_position
	new_vacuum.position.x -= get_window().size.x
	# increase parallax repeats to make sure no edges are visible
	for layer in para_layers:
		layer.repeat_times *= NEW_SCALE
	# zoom out
	tw.tween_interval(2.0)
	tw.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(camera, "zoom", Vector2(1.0 / NEW_SCALE, 1.0 / NEW_SCALE) * 2, 4.0)
	tw.tween_interval(1.0)
	# huge vacuum vacuums up small vacuum
	tw.tween_property(new_vacuum, "global_position", current_vacuum.global_position, 1.0)
	
	if GLOBAL.zen_mode:
		tw.tween_callback(func():
			# swoitch vacuums
			current_vacuum.remove_child(camera)
			current_vacuum.queue_free()
			current_vacuum = new_vacuum
			regions.follow = current_vacuum
			current_vacuum.add_child(camera)
			# zoom in
			tw = create_tween()
			tw.parallel().tween_property(camera, "zoom", Vector2.ONE, 2.0)
			tw.parallel().tween_property(current_vacuum, "scale", Vector2.ONE, 2.0)
			# reset parallax
			for layer in para_layers:
				layer.repeat_times /= NEW_SCALE
			tw.tween_callback(func():
				current_vacuum.state = Vacuum.States.MOVABLE
				GLOBAL.total_stars_vacuumed += GLOBAL.stars_vacuumed
				GLOBAL.stars_vacuumed = 0
				regions.process_regions()
			)
		)
	else:
		# gameover
		tw.tween_callback(func():
			GLOBAL.ui_layer.call_panel(true)
		)
