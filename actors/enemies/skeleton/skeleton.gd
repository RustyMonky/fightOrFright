extends KinematicBody2D

var direction = Vector2(1, 0)

const SPEED = 32

func _ready():
	print("added at " + String(self.position))
	set_physics_process(true)

func _physics_process(delta):
	self.global_position += self.direction.normalized() * SPEED * delta
