extends KinematicBody2D

var direction = Vector2(1, 0)
var hp = 2

const SPEED = 32

func _ready():
	print("added at " + String(self.position))
	set_physics_process(true)

func _physics_process(delta):
	self.global_position += self.direction.normalized() * SPEED * delta

func take_damage():
	hp -= 1
	if hp == 0:
		self.queue_free()
