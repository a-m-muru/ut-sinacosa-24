extends TextureButton

const SCORE_DISPLAY := preload("res://scenes/gui/score_display.tscn")

@onready var panel: Panel = $Panel
@onready var container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer


func _on_toggled(toggled_on: bool) -> void:
	panel.visible = toggled_on
	container.get_children().map(func(a: Node) -> void: a.queue_free())
	if toggled_on:
		var scores := Challenger.get_scores()
		Challenger.sort_scores_by_points(scores)
		for score in scores:
			var display := SCORE_DISPLAY.instantiate()
			display.get_child(0).text = "Time: " + str(score.time) + " sec"
			display.get_child(1).text = "Score: %02.1f" % (score.points * 10) + " cons. pts"
			container.add_child(display)
