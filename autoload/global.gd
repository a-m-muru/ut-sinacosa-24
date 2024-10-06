extends Node

# holds miscellaneous globally accessible things

# this is used to save how many stars should still be in a region.
# regions load their desired star generation counts from here.
var remaining_stars := {}

var stars_per_level := 400
var total_stars_vacuumed := 0 # updated in zen mode only
var stars_vacuumed := 0

var ui_layer: UI
var challenger: Challenger
var regions: Regions

# there is no challenger instance
var zen_mode := true

var played_once := false


func reset_counters() -> void:
	remaining_stars = {}
	stars_vacuumed = 0


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if ui_layer != null:
			ui_layer.call_panel(false)


func check_star_completion() -> void:
	if stars_vacuumed >= stars_per_level:
		regions.cutscene.play()
		if challenger:
			challenger.end_challenge()
