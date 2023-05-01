class_name Character extends CharacterBody2D

@onready var sprite = $Sprite

@export var move_speed := 170
@export var friction: = 20

var next_idle = false

func _ready():
	sprite.connect("frame_changed", func():
		if next_idle:
			sprite.play("idle")
			next_idle = false
	)

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	velocity = lerp(direction * move_speed, velocity, 1 / (1 + friction * delta))
	move_and_slide()



func _process(_delta):
	sprite.flip_h = velocity.x < 0
	var speed = velocity.abs().length()
	
	if speed > 10:
		if sprite.animation == "idle":
			sprite.play("walk")
	elif sprite.animation == "walk":
		next_idle = true
	
	$Particles.emitting = speed > 50
	$Particles.initial_velocity_max = speed / 2
	$Particles.direction = -velocity
