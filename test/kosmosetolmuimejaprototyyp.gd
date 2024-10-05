extends Node2D

const TAHT := preload("res://scenes/world/stars/star.tscn")
const IMEJA := preload("res://test/tolmuimeja.tscn")

@onready var star_parent: Node2D = $StarParent
@onready var camera: Camera2D = $Vacuum/Camera2D

@onready var tolmuimeja: CharacterBody2D = $Vacuum

var window_size := Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
var timer_tw: Tween


func _ready() -> void:
	for i in 5000:
		var taht := TAHT.instantiate()
		taht.global_position = Vector2(randf_range(-window_size.x, window_size.x), randf_range(-window_size.y, window_size.y)) * 5
		star_parent.add_child(taht)
	_start_timer()


func _timer() -> void:
	var stars := star_parent.get_child_count()
	if stars < 10:
		timer_tw.kill()
		var new_ti := IMEJA.instantiate()
		new_ti.scale = Vector2(8, 8)
		add_child(new_ti)
		new_ti.position.x -= window_size.x
		var tw := create_tween()
		tw.tween_property(camera, "zoom", Vector2.ONE * 0.125, 2.0)
		tw.tween_callback(func():
			camera.zoom = Vector2.ONE
			new_ti.scale = Vector2.ONE
			tolmuimeja.remove_child(camera)
			tolmuimeja.queue_free()
			tolmuimeja = new_ti
			tolmuimeja.add_child(camera)
			camera.position = Vector2.ZERO
		)


func _start_timer() -> void:
	timer_tw = create_tween().set_loops(-1)
	timer_tw.tween_interval(1)
	timer_tw.tween_callback(_timer)
