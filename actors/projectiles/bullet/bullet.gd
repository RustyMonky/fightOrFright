extends KinematicBody2D

onready var horizontalTexture = load("res://assets/sprites/projectiles/bullet/bulletHoriz.png")
onready var sprite = $Sprite
onready var verticalTexture = load("res://assets/sprites/projectiles/bullet/bulletVert.png")

var direction

const SPEED = 400

func _ready():
	if self.direction.y == 0: # Horizontal
		sprite.set_texture(horizontalTexture)
		if self.direction.x == 1:
			sprite.flip_h = true
	elif self.direction.x == 0:
		sprite.set_texture(verticalTexture)
		if self.direction.y == 1:
			sprite.flip_v = true
	set_physics_process(true)

func _physics_process(delta):
	if self.direction == Vector2(0, 0):
		self.direction = Vector2(-1, 0) # Unfortunately, required override for bullet spawn if player doesn't move
	self.global_position += self.direction.normalized() * SPEED * delta

	if self.global_position.x < 0 || self.global_position.x > OS.get_screen_size().x || self.global_position.y < 0 || self.global_position.y > OS.get_screen_size().y:
		self.queue_free()
	