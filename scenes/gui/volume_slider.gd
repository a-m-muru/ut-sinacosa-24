extends Panel

@onready var volume_slider: HSlider = $"Volume Slider"
@onready var texture_rect: TextureRect = $TextureRect
@onready var volume_sound: AudioStreamPlayer = $"Volume Slider/VolumeSound"


func _ready() -> void:
	load_audio_volume()
	volume_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(0)))
	if (AudioServer.get_bus_volume_db(0) >= 0):
		texture_rect.texture = load("res://scenes/gui/volume.png")
	else:
		texture_rect.texture = load("res://scenes/gui/volume_null.png")


func _on_volume_slider_value_changed(value: float) -> void:
	GLOBAL.set_audio_volume(value)
	volume_sound.play()
	if (value > 0):
		texture_rect.texture = load("res://scenes/gui/volume.png")
	else:
		texture_rect.texture = load("res://scenes/gui/volume_null.png")


func _on_mute_button_pressed() -> void:
	if (AudioServer.get_bus_volume_db(0) >= 0):
		GLOBAL.set_audio_volume(0)
		volume_slider.value = 0
		texture_rect.texture = load("res://scenes/gui/volume_null.png")
	else:
		GLOBAL.set_audio_volume(1.0)
		volume_slider.value = 1.0
		texture_rect.texture = load("res://scenes/gui/volume.png")


func save_audio_volume() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("volume", "main", AudioServer.get_bus_volume_db(0))
	cfg.save("user://volume.cfg")


func load_audio_volume() -> void:
	var cfg := ConfigFile.new()
	cfg.load("user://volume.cfg")
	AudioServer.set_bus_volume_db(0, cfg.get_value("volume", "main", 0.75))


func _exit_tree() -> void:
	save_audio_volume()
