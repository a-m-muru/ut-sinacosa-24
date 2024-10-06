class_name Trash extends SpaceFloater

# trash that floats around in space giving negative points

const TEXTURES := [
	preload("res://scenes/world/trash/trash_0001_helmet.png"),
	preload("res://scenes/world/trash/trash_0003_chunk-of-trash.png"),
	preload("res://scenes/world/trash/trash_0005_satellite.png"),
	preload("res://scenes/world/trash/trash_0007_some-trash.png"),
	preload("res://scenes/world/trash/trash_0009_panel__.png")
]

@onready var image: Sprite2D = $Image
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var noise: AudioStreamPlayer2D = $TrashNoise


func _ready() -> void:
	super()
	var texture: Texture = TEXTURES.pick_random()
	image.texture = texture
	image.get_children().map(func(a: Sprite2D) -> void: a.texture = texture)
	particles.amount_ratio = 0.01
