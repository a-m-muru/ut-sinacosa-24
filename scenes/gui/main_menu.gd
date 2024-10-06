extends Control
@onready var credits: Panel = $Credits
@onready var background: TextureRect = $Background


func _ready() -> void:
	GLOBAL.reset_counters()
	credits.visible = false
	if (GLOBAL.played_once):
		# fancy different menu art
		if (randf_range(1,5) > 3):
			background.texture = load("res://scenes/gui/menu_background_alt.png")
	if not GLOBAL.song_player.get_parent():
		GLOBAL.add_child(GLOBAL.song_player)
		GLOBAL.song_player.stream = preload("res://scenes/world/space/background.ogg")
		GLOBAL.song_player.play()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		credits.visible = false


func _on_play_challenge_button_pressed() -> void:
	GLOBAL.zen_mode = false
	get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))
	GLOBAL.played_once = true


func _on_play_relax_button_pressed() -> void:
	GLOBAL.zen_mode = true
	get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))
	GLOBAL.played_once = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	credits.visible = true


func _on_back_button_pressed() -> void:
	credits.visible = false
