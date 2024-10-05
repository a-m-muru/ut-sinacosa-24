class_name Planet extends SpaceFloater

const EYE_TEXTURES := [
	preload("res://scenes/world/planets/big.1.5.e.png"),
	preload("res://scenes/world/planets/big.1.e.png"),
	preload("res://scenes/world/planets/big.2.5.e.png"),
	preload("res://scenes/world/planets/big.2.e.png"),
	preload("res://scenes/world/planets/big.3.f.png"),
]

const BODY_TEXTURES := [
	preload("res://scenes/world/planets/big.1.5.f.png"),
	preload("res://scenes/world/planets/big.1.f.png"),
	preload("res://scenes/world/planets/big.2.5.f.png"),
	preload("res://scenes/world/planets/big.2.f.png"),
	preload("res://scenes/world/planets/big.3.e.png"),
]

@onready var body: Sprite2D = $Body
@onready var eyes: Sprite2D = $Eyes
@onready var blink_timer: Timer = $BlinkTimer


func _ready() -> void:
	super()
	blink_timer.timeout.connect(_blink_timer_timeout)
	var idx := randi() % EYE_TEXTURES.size()
	body.texture = BODY_TEXTURES[idx]
	eyes.texture = EYE_TEXTURES[idx]


func vacuum_collision_response(vacuum: Vacuum) -> void:
	var away_direction := (global_position - vacuum.global_position).normalized()
	apply_impulse(away_direction * 170.0)
	rotation_direction *= 2.0
	if absf(rotation_direction) >= 30:
		Region.stellar_explosion(self, 60, 30, 16, Vector2(-6, 6))
		queue_free()


func _blink_timer_timeout() -> void:
	blink_timer.wait_time = 16 * randf()
	var tw := create_tween()
	tw.tween_property(eyes, "scale:y", 0.0, 0.2)
	tw.tween_interval(0.8)
	tw.tween_property(eyes, "scale:y", 1.0, 0.2)
