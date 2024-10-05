extends Control
@onready var credits: Panel = $Credits
@onready var background: TextureRect = $Background


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	credits.visible = false
	if (GLOBAL.played_once):
		if (randf_range(1,5) > 3):
			background.texture = load("res://scenes/gui/menu_background_alt.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
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


func _on_texture_button_pressed() -> void:
	credits.visible = false
