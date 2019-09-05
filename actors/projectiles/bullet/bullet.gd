extends Area2D

onready var horizontalTexture = load("res://assets/sprites/projectiles/bullet/bulletHoriz.png")
onready var sprite = $Sprite
onready var timmy = get_parent().get_node("timmy")

var bulletChange
var direction
var fearFloat

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

const SPEED = 400

func _ready():
	randomize()
	fearFloat = float(timmy.fear * 0.01)
	bulletChange = rand_range(-fearFloat, fearFloat)

	sprite.set_texture(horizontalTexture)

	if self.direction == RIGHT || self.direction == UP:
		sprite.flip_h = true

	if self.direction == LEFT || self.direction == DOWN:
		sprite.flip_v = true

	set_physics_process(true)

func _physics_process(delta):
	if self.direction == Vector2(0, 0):
		self.direction = Vector2(-1, 0) # Unfortunately, required override for bullet spawn if player doesn't move

	# Lastly, update bullet direction with fear
	# TODO: Update based on fear

	var motion = (self.direction.normalized() * SPEED * delta)
	self.global_position += util.cartesian_to_isometric(motion)

	if self.global_position.x < 0 || self.global_position.x > OS.get_screen_size().x || self.global_position.y < 0 || self.global_position.y > OS.get_screen_size().y:
		self.queue_free()

func _on_bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage()
		self.queue_free()
