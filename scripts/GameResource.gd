extends Area2D

const pickup_speed = 10
const spawn_accel = 8

var character: Character
var pickup = false
var data

var spawn_angle: Vector2
var spawn_speed: float

func init(res):
	data = res
	$Sprite.texture = res.icon

func _ready():
	body_entered.connect(func (_b): pickup = true)
	body_exited.connect(func (_b): pickup = false)
	
	spawn_angle = Vector2.from_angle(randf() * 2 * PI)
	spawn_speed = randf_range(30, 70)

func _process(delta):
	position += spawn_angle * spawn_speed * delta
	spawn_speed *= 1 / (1 + spawn_accel * delta)
	
	if pickup:
		if position.distance_to(character.position) < 10:
			Resources.collected[data.id] += 1
			queue_free()
		else:
			position = lerp(character.position, position, 1 / (1 + delta * pickup_speed))
