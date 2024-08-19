extends Node

signal score_updated
signal player_died

var score: = 0
var deaths: = 0 

func reset() -> void:
	score = 0
	deaths = 0


func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")
	
func set_deaths(value: int) -> void:
	score = value
	emit_signal("player_died")

func _ready() -> void:
	set_score(score)
	set_deaths(deaths)
