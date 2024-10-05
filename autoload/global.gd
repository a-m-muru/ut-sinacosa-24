extends Node

const STARS_PER_LEVEL := 1000

var remaining_stars := {}
var star_noise := FastNoiseLite.new()
var stars_vacuumed := 0
var ui_layer: CanvasLayer = null


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if ui_layer != null:
			ui_layer.call_panel(false)
