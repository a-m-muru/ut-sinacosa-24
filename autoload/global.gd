extends Node

var remaining_stars := {}
var star_noise := FastNoiseLite.new()
var stars_vacuumed = 0
var ui_layer = null
var esc_pressed = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		if ui_layer != null:
			ui_layer.call_panel(false)
		
