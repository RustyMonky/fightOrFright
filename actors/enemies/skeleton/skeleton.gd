extends KinematicBody2D

enum STATE {ALIVE, DEAD}

onready var animations = $animations
onready var collider = $collider
onready var fadeTimer = $fadeTimer
onready var fadeTween = $fadeTween

var current_state = STATE.ALIVE
var direction
var hp = 2

const SPEED = 32

func _ready():
	animations.playing = true
	set_physics_process(true)

func _physics_process(delta):
	if current_state == STATE.ALIVE:
		self.global_position += self.direction.normalized() * SPEED * delta

func take_damage():
	hp -= 1
	if hp == 0:
		current_state = STATE.DEAD
		collider.disabled = true
		self.z_index = -1

		var deathAnimation = load("res://assets/spriteFrames/enemies/skeleton/skeletonDeath.tres")
		animations.set_sprite_frames(deathAnimation)
		animations.set_animation("skeletonDeath")

func _on_animations_animation_finished():
	if current_state == STATE.DEAD:
		fadeTimer.start()

func _on_fadeTimer_timeout():
	fadeTween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fadeTween.start()

func _on_fadeTween_tween_completed(object, key):

	self.queue_free()
