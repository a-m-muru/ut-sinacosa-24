extends Node

const VACUUM := preload("res://scenes/vacuum/vacuum.tscn")

@export var current_vacuum: Vacuum
@export var camera: Camera2D


func play() -> void:
	var tw := create_tween()
	current_vacuum.state = Vacuum.States.FROZEN
	tw.tween_interval(1.0)
	
