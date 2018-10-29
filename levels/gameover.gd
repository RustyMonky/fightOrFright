extends Control

onready var mobsLabel = $canvas/centerBox/mobsLabel
onready var timesLabel = $canvas/centerBox/timeLabel

var canTransition = false

func _ready():
	mobsLabel.text = String(gameData.mobsKilled) + ' mobs slain'
	timesLabel.text = formattedTime() + ' spent alive'

	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_select")) && canTransition:
		fader.fadeToScene("res://levels/title.tscn")

func formattedTime():
	if int(gameData.secondsAlive) < 10:
		gameData.secondsAlive = '0' + String(gameData.secondsAlive)
	return String(gameData.minutesAlive) + ':' + String(gameData.secondsAlive)

func _on_delayTimer_timeout():
	canTransition = true
