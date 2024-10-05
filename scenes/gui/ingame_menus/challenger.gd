class_name Challenger extends Control

@onready var timer_label: Label = %TimerLabel
@onready var timer: Timer = %Timer
@onready var score_label: Label = %ScoreLabel
@onready var star_collection_progress: ProgressBar = %StarCollectionProgress

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
	display() 


@warning_ignore("integer_division")
func display() -> void:
	var hours := time / 3600
	var minutes := (time / 60) - hours * 60
	var seconds := time - minutes * 60
	var format := [minutes, seconds]
	timer_label.text = "%02d:%02d"
	if hours > 0:
		timer_label.text += ":%02d"
		format.push_front(hours)
	timer_label.text = timer_label.text % format
	
	score_label.text = "%010.1f" % (score * 10)
	
	star_collection_progress.value = float(GLOBAL.stars_vacuumed) / GLOBAL.STARS_PER_LEVEL
