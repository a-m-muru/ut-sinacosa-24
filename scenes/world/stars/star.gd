class_name Star extends SpaceFloater

# small tiny creatures that can be vacuumed up for points

const EYE_TEXTURES := [
	preload("res://scenes/world/stars/1.png"),
	preload("res://scenes/world/stars/1.small.png"),
	preload("res://scenes/world/stars/2 (1).png"),
	preload("res://scenes/world/stars/2.small.png"),
	preload("res://scenes/world/stars/3.e.png"),
	preload("res://scenes/world/stars/small.3.e.png"),
	preload("res://scenes/world/stars/small.4.e.png"),
	preload("res://scenes/world/stars/more_faces/0007_Layer-28.png"),
	preload("res://scenes/world/stars/more_faces/0009_Layer-25.png"),
	preload("res://scenes/world/stars/more_faces/0011_Layer-23.png"),
	preload("res://scenes/world/stars/more_faces/0013_Layer-21.png"),
	preload("res://scenes/world/stars/more_faces/0014_Layer-20.png"),
 	preload("res://scenes/world/stars/more_faces/0016_Layer-17.png"),
	preload("res://scenes/world/stars/more_faces/0020_Layer-13.png"),
	preload("res://scenes/world/stars/more_faces/0021_Layer-12.png"),
	preload("res://scenes/world/stars/more_faces/0022_Layer-11.png"),
	preload("res://scenes/world/stars/more_faces/0023_Layer-10.png"),
]
const MOUTH_TEXTURES := [
	preload("res://scenes/world/stars/1..png"),
	preload("res://scenes/world/stars/1.small.m.png"),
	preload("res://scenes/world/stars/2 (2).png"),
	preload("res://scenes/world/stars/3.m.png"),
	preload("res://scenes/world/stars/small.3.m.png"),
	preload("res://scenes/world/stars/more_faces/0005_Layer-30.png"),
	preload("res://scenes/world/stars/more_faces/0006_Layer-29.png"),
	preload("res://scenes/world/stars/more_faces/0010_Layer-24.png"),
	preload("res://scenes/world/stars/more_faces/0012_Layer-22.png"),
	preload("res://scenes/world/stars/more_faces/0017_Layer-16.png"),
	preload("res://scenes/world/stars/more_faces/0018_Layer-15.png"),
	preload("res://scenes/world/stars/more_faces/0025_Layer-8.png"),
	preload("res://scenes/world/stars/more_faces/0026_Layer-7.png"),
	preload("res://scenes/world/stars/more_faces/0027_Layer-6.png"),
	preload("res://scenes/world/stars/more_faces/0028_Layer-5.png"),
	preload("res://scenes/world/stars/more_faces/0029_Layer-4.png"),
	preload("res://scenes/world/stars/more_faces/0030_Layer-3.png"),
	preload("res://scenes/world/stars/more_faces/0031_Layer-2.png"),
	preload("res://scenes/world/stars/more_faces/0032_Layer-1.png"),
]
const BACKGROUND_TEXTURES := [
	preload("res://scenes/world/stars/background.small.png"),
	preload("res://scenes/world/stars/background.circle.png"),
]
const HAIR_TEXTURES := [
	preload("res://scenes/world/stars/more_faces/Untitled-1-Recovered.psd_0000_martin.png"),
	preload("res://scenes/world/stars/more_faces/Untitled-1-Recovered.psd_0001_raili.png"),
	preload("res://scenes/world/stars/more_faces/Untitled-1-Recovered.psd_0002_gaabu.png"),
	preload("res://scenes/world/stars/more_faces/Untitled-1-Recovered.psd_0003_helen.png"),
	preload("res://scenes/world/stars/more_faces/Untitled-1-Recovered.psd_0004_egon.png"),
]
const COLORS := [
	Color(0.85, 0.883, 0.913),
	Color(0.85, 0.883, 0.913),
	Color(0.918, 0.859, 0.897),
	Color(0.854, 0.532, 0.535),
	Color(0.893, 0.855, 0.699),
]

@onready var background: Sprite2D = $Background
@onready var mouth: Sprite2D = $Face/Mouth
@onready var hair: Sprite2D = $Hair
@onready var eyes: Sprite2D = $Face/Eyes
@onready var blink_timer: Timer = $BlinkTimer
@onready var glow := $Glow
@onready var glow_front := $Glow2
@onready var face: Node2D = $Face
@onready var visibility_notif: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	super()
	visibility_notif.screen_entered.connect(set_physics_process.bind(true))
	visibility_notif.screen_exited.connect(set_physics_process.bind(false))
	blink_timer.timeout.connect(_blink_timer_timeout)
	mouth.texture = MOUTH_TEXTURES.pick_random()
	eyes.texture = EYE_TEXTURES.pick_random()
	# chonky star
	if randf() < 0.1:
		background.texture = BACKGROUND_TEXTURES[1]
	else:
		if randf() < 0.01:
			hair.texture = HAIR_TEXTURES.pick_random()
		
	if randf() < 0.02:
		scale *= randfn(2, 1)
	
	var color: Color = COLORS.pick_random()
	# some stars don't have predetermined colours for more interesting variety
	if randf() < 0.05:
		color = Color(randf(), randf(), randf())
	
	glow.modulate = color
	glow_front.modulate = color


func _blink_timer_timeout() -> void:
	blink_timer.wait_time = 16 * randf()
	# blink (scale the eyes)
	var tw := create_tween()
	tw.tween_property(eyes, "scale:y", 0.0, 0.01)
	tw.tween_interval(0.3)
	tw.tween_property(eyes, "scale:y", 1.0, 0.01)
	
	if randf() < 0.5:
		tw.tween_property(face, "position", Vector2(randf(), randf()) * randf_range(-1, 1) * 18, 0.3)
