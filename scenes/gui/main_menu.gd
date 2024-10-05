extends Control
@onready var credits_button: TextureButton = $"Credits Button"
@onready var play_challenge_button: TextureButton = $"HBoxContainer/VBoxContainer/Play_Challenge Button"
@onready var play_relax_button: TextureButton = $"HBoxContainer/VBoxContainer/Play_Relax Button"
@onready var quit_button: TextureButton = $"HBoxContainer/VBoxContainer/Quit Button"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_challenge_button_pressed() -> void:
	GLOBAL.zen_mode = false
	get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))


func _on_play_relax_button_pressed() -> void:
	GLOBAL.zen_mode = true
	get_tree().change_scene_to_packed(load("res://scenes/world/space/space.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.
