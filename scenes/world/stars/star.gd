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
]
const MOUTH_TEXTURES := [
	preload("res://scenes/world/stars/1..png"),
	preload("res://scenes/world/stars/1.small.m.png"),
	preload("res://scenes/world/stars/2 (2).png"),
	preload("res://scenes/world/stars/3.m.png"),
	preload("res://scenes/world/stars/small.3.m.png"),
]
const BACKGROUND_TEXTURES := [
	preload("res://scenes/world/stars/background.small.png"),
	preload("res://scenes/world/stars/background.circle.png"),
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
@onready var eyes: Sprite2D = $Face/Eyes
@onready var blink_timer: Timer = $BlinkTimer
@onready var glow := $Glow
@onready var glow_front := $Glow2
@onready var face: Node2D = $Face


func _ready() -> void:
	super()
	blink_timer.timeout.connect(_blink_timer_timeout)
	mouth.texture = MOUTH_TEXTURES.pick_random()
	eyes.texture = EYE_TEXTURES.pick_random()
	# chonky star
	if randf() < 0.1:
		background.texture = BACKGROUND_TEXTURES[1]
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
