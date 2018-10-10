extends Node2D

onready var timmy = $timmy

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_triggerZone_body_entered(body):
	if body.is_in_group("enemies"):
		body.move_to_timmy()
