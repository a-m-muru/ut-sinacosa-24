class_name Challenger extends Control

# this class is responsible for managing and displaying the challenge gamemode

@onready var timer_label: Label = %TimerLabel
@onready var timer: Timer = %Timer
@onready var score_label: Label = %ScoreLabel
@onready var star_collection_progress: ProgressBar = %StarCollectionProgress

# hacky reference to regions used by GLOBAL
@export var regions: Regions

var score := 0.0
var time := 0


func _ready() -> void:
	if GLOBAL.zen_mode:
		GLOBAL.challenger = null
		queue_free()
		return
	GLOBAL.challenger = self
	timer.timeout.connect(func() -> void: time += 1; display())
	display()


func add_score(amount: float) -> void:
	score += amount
	score = maxf(score, 0)
	display()
	
	# pulse the score text to draw attention to it
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(score_label, "pivot_offset", score_label.size / 2, 0)
	tw.tween_property(score_label, "scale", Vector2.ONE * 1.1, 0.1)
	if amount < 0:
		# negative score makes the text pulse red
		tw.parallel().tween_property(score_label, "modulate", Color.PALE_VIOLET_RED, 0.1)
	tw.tween_property(score_label, "scale", Vector2.ONE, 0.1)
	tw.parallel().tween_property(score_label, "modulate", Color.WHITE, 0.1)


func display() -> void:
	timer_label.text = get_time_text(time)
	
	score_label.text = "%010.1f" % (score * 10)
	
	star_collection_progress.value = float(GLOBAL.stars_vacuumed) / GLOBAL.stars_per_level


# format: "hh:mm:ss"
@warning_ignore("integer_division")
static func get_time_text(t: int) -> String:
	var text := ""
	var hours := t / 3600
	var minutes := (t / 60) - hours * 60
	var seconds := t - minutes * 60
	var format := [minutes, seconds]
	text = "%02d:%02d"
	if hours > 0:
		text += ":%02d"
		format.push_front(hours)
	text = text % format
	return text


func end_challenge() -> void:
	timer.stop()
	timer_label.modulate = Color.KHAKI
	
	# make the timer label flash yellow
	var t := create_tween().set_loops(-1)
	t.tween_callback(timer_label.set_modulate.bind(Color.KHAKI))
	t.tween_interval(0.77)
	t.tween_callback(timer_label.set_modulate.bind(Color.GOLD))
	t.tween_interval(0.77)
