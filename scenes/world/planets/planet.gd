class_name Planet extends SpaceFloater

# big floating objects that burst into small stars

const EYE_TEXTURES := [
	preload("res://scenes/world/planets/big.1.5.e.png"),
	preload("res://scenes/world/planets/big.1.e.png"),
	preload("res://scenes/world/planets/big.2.5.e.png"),
	preload("res://scenes/world/planets/big.2.e.png"),
	preload("res://scenes/world/planets/big.3.f.png"),
	preload("res://scenes/world/planets/big..4.e.png"),
	preload("res://scenes/world/planets/big.5.f.png")
]

const BODY_TEXTURES := [
	preload("res://scenes/world/planets/big.1.5.f.png"),
	preload("res://scenes/world/planets/big.1.f.png"),
	preload("res://scenes/world/planets/big.2.5.f.png"),
	preload("res://scenes/world/planets/big.2.f.png"),
	preload("res://scenes/world/planets/big.3.e.png"),
	preload("res://scenes/world/planets/big.4.f.png"),
	preload("res://scenes/world/planets/big.5.e.png"),
]

@onready var body: Sprite2D = $Body
@onready var eyes: Sprite2D = $Eyes
@onready var blink_timer: Timer = $BlinkTimer
@onready var bump_sound: AudioStreamPlayer2D = $BumpSound
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound


func _ready() -> void:
	super()
	blink_timer.timeout.connect(_blink_timer_timeout)
	var idx := randi() % EYE_TEXTURES.size()
	body.texture = BODY_TEXTURES[idx]
	eyes.texture = EYE_TEXTURES[idx]


func vacuum_collision_response(vacuum: Vacuum) -> void:
	# knocked away from the vacuum
	# this method is kind of broken and sometimes called way too many times
	var away_direction := (global_position - vacuum.global_position).normalized()
	apply_impulse(away_direction * 170.0)
	rotation_direction *= 2.0
	bump_sound.play()
	# planets spinning too fast break apart
	if absf(rotation_direction) >= 30:
		remove_child(explode_sound)
		add_sibling(explode_sound)
		explode_sound.play()
		Region.stellar_explosion(self, 60, 30, 16, Vector2(-6, 6))
		queue_free()


func _blink_timer_timeout() -> void:
	blink_timer.wait_time = 16 * randf()
	# blink
	var tw := create_tween()
	tw.tween_property(eyes, "scale:y", 0.0, 0.2)
	tw.tween_interval(0.8)
	tw.tween_property(eyes, "scale:y", 1.0, 0.2)
