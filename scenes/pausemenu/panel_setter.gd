class_name UI extends CanvasLayer

@onready var pause_panel: Panel = $"Pause panel"
@onready var game_over_panel: Panel = $"Game Over panel"



func _ready() -> void:
	GLOBAL.ui_layer = self
	game_over_panel.visible = false
	pause_panel.visible = false


func _exit_tree() -> void:
	GLOBAL.ui_layer = null


func call_panel(gameover = false) -> void:
	if (!game_over_panel.visible):
		if (gameover): #If the game ends
			game_over_panel.visible = true
		else: #If the player presses the escape key.
			if (pause_panel.visible):
				pause_panel.visible = false
			else:
				pause_panel.visible = true


func _on_quit_button_p_pressed() -> void:
	if (pause_panel.visible):
		get_tree().change_scene_to_packed(load("res://scenes/gui/main_menu.tscn"))


func _on_resume_button_pressed() -> void:
	if (pause_panel.visible):
		pause_panel.visible = false


func _on_quit_button_g_pressed() -> void:
	if (game_over_panel.visible):
		get_tree().change_scene_to_packed(load("res://scenes/gui/main_menu.tscn"))


func _on_retry_button_pressed() -> void:
	if (game_over_panel.visible):
		get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))
