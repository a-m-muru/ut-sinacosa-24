extends Panel

@onready var volume_slider: HSlider = $"Volume Slider"
@onready var texture_rect: TextureRect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	if (AudioServer.get_bus_volume_db(0) > 0):
		texture_rect.texture = load("res://scenes/gui/volume.png")
	else:
		texture_rect.texture = load("res://scenes/gui/volume_null.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_slider_value_changed(value: float) -> void:
	GLOBAL.set_audio_volume(value)
	if (value > 0):
		texture_rect.texture = load("res://scenes/gui/volume.png")
	else:
		texture_rect.texture = load("res://scenes/gui/volume_null.png")


func _on_mute_button_pressed() -> void:
	if (AudioServer.get_bus_volume_db(0) > 0):
		GLOBAL.prev_volume = AudioServer.get_bus_volume_db(0)
		GLOBAL.set_audio_volume(0)
		volume_slider.value = 0
		texture_rect.texture = load("res://scenes/gui/volume_null.png")
	else:
		GLOBAL.set_audio_volume(GLOBAL.prev_volume)
		volume_slider.value = GLOBAL.prev_volume
		texture_rect.texture = load("res://scenes/gui/volume.png")
