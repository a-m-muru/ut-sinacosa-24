extends Control
@onready var credits: TextureRect = $Credits


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	credits.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		credits.visible = false


func _on_play_challenge_button_pressed() -> void:
	GLOBAL.zen_mode = false
	get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))


func _on_play_relax_button_pressed() -> void:
	GLOBAL.zen_mode = true
	get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	credits.visible = true
