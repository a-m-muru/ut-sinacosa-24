extends CanvasLayer
@onready var pause_panel: Panel = $"Pause panel"
@onready var game_over_panel: Panel = $"Game Over panel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GLOBAL.ui_layer = self
	game_over_panel.visible = false
	pause_panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _exit_tree() -> void:
	GLOBAL.ui_layer = null


func call_panel(gameover := false) -> void:
	if (gameover): #If the game ends
		game_over_panel.visible = true
	else: #If the player presses the escape key.
		if (pause_panel.visible):
			pause_panel.visible = false
		else:
			pause_panel.visible = true
