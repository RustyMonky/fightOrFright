extends Navigation2D

onready var timmy = $timmy

var timmyLocal = Vector2()
var skeletons

func _ready():
	set_process(true)

func _process(delta):
	timmyLocal = to_local(timmy.global_position)

	for child in self.get_children():
		if !child.is_in_group("enemies"):
			continue

		var localPosition = to_local(child.global_position)
		var path = self.get_simple_path(localPosition, timmyLocal)
		print("path", path)
