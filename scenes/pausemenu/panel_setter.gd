class_name UI extends CanvasLayer

@onready var pause_panel: Panel = $"Pause panel"
@onready var game_over_panel: Panel = $"Game Over panel"
@onready var current_score_label: Label = $"Pause panel/Current Score Label"
@onready var final_score_label: Label = $"Game Over panel/Final Score Label"


func _ready() -> void:
	GLOBAL.ui_layer = self
	game_over_panel.visible = false
	pause_panel.visible = false


func _exit_tree() -> void:
	GLOBAL.ui_layer = null


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and pause_panel.visible:
		call_panel.call_deferred()


func call_panel(gameover = false) -> void:
	if (!game_over_panel.visible):
		if (gameover): #If the game ends
			game_over_panel.visible = true
			final_score_label.text = "Stars collected: " + str(GLOBAL.stars_vacuumed) + "/" + str(GLOBAL.stars_per_level)
			# add to the score display when we're finishing a challenge mode game
			if GLOBAL.challenger:
				final_score_label.add_theme_font_size_override("font_size", 72)
				final_score_label.text += "\nConsumption score: %02.1f" % (GLOBAL.challenger.score * 10)
				final_score_label.text += "\nFinal Time: " + Challenger.get_time_text(GLOBAL.challenger.time)
				GLOBAL.challenger.hide()
		else: #If the player presses the escape key.
			if (pause_panel.visible):
				pause_panel.visible = false
				get_tree().paused = false
			else:
				current_score_label.text = "Stars collected: " + str(GLOBAL.stars_vacuumed)
				if GLOBAL.challenger:
					current_score_label.text += "/" + str(GLOBAL.stars_per_level)
				get_tree().paused = true
				pause_panel.visible = true


func _on_quit_button_p_pressed() -> void:
	if (pause_panel.visible):
		get_tree().change_scene_to_packed(load("res://scenes/gui/main_menu.tscn"))


func _on_resume_button_pressed() -> void:
	if (pause_panel.visible):
		call_panel()


func _on_quit_button_g_pressed() -> void:
	if (game_over_panel.visible):
		get_tree().change_scene_to_packed(load("res://scenes/gui/main_menu.tscn"))


func _on_retry_button_pressed() -> void:
	if (game_over_panel.visible):
		get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))
