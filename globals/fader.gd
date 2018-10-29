extends CanvasLayer

onready var anim = $anim
onready var color = $color

var scenePath

func _ready():
	pass

func fadeToScene(destination):
	scenePath = destination
	anim.play("fade")

func switchScene():
	sceneManager.goto_scene(scenePath)
