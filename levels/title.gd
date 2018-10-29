extends Control

enum OPTIONS {PLAY, HELP}

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
			fader.fadeToScene("res://levels/main.tscn")
		elif currentOption == OPTIONS.HELP:
			help.show()

	elif event.is_action_pressed("ui_down"):
		currentOption = OPTIONS.HELP
		updateHoveredOption()
	elif event.is_action_pressed("ui_up"):
		currentOption = OPTIONS.PLAY
		updateHoveredOption()

func updateHoveredOption():
	for label in optionLabels:
		if currentOption == optionLabels.find(label):
			label.set("custom_colors/font_color", Color("#c93038"))
		else:
			label.set("custom_colors/font_color", Color("#ffffff"))