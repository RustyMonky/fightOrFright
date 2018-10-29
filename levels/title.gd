extends Control

enum OPTIONS {PLAY, HELP, CREDITS}

onready var bgAudio = $backgroundMusic
onready var credits = $credits
onready var effectAudio = $effectAudio
onready var help = $help
onready var optionLabels = $optionsVBox.get_children()
onready var spawner = $spawner

var currentOption

func _ready():
	currentOption = OPTIONS.PLAY
	updateHoveredOption()

	set_process_input(true)

func _input(event):
	if help.is_visible():
		return

	if event.is_action_pressed("ui_accept"):
		if currentOption == OPTIONS.PLAY:
			bgAudio.stop()
			effectAudio.play()
			fader.fadeToScene("res://levels/main.tscn")
		elif currentOption == OPTIONS.HELP:
			help.show()
		elif currentOption == OPTIONS.CREDITS:
			credits.show()

	elif event.is_action_pressed("ui_down"):
		if currentOption == OPTIONS.PLAY:
			currentOption = OPTIONS.HELP
		else:
			currentOption = OPTIONS.CREDITS
		updateHoveredOption()
	elif event.is_action_pressed("ui_up"):
		if currentOption == OPTIONS.HELP:
			currentOption = OPTIONS.PLAY
		else:
			currentOption = OPTIONS.HELP
		updateHoveredOption()

func updateHoveredOption():
	for label in optionLabels:
		if currentOption == optionLabels.find(label):
			label.set("custom_colors/font_color", Color("#c93038"))
		else:
			label.set("custom_colors/font_color", Color("#ffffff"))