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


func _ready() -> void:
	super()
	var idx := randi() % EYE_TEXTURES.size()
	body.texture = BODY_TEXTURES[idx]
	eyes.texture = EYE_TEXTURES[idx]


func vacuum_collision_response(vacuum: Vacuum) -> void:
	apply_impulse((global_position - vacuum.global_position).limit_length(4.0))
