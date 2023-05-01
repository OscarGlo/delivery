extends Control

var load_frames = -1

func _ready():
	$Button.pressed.connect(func ():
		$Loading.visible = true
		load_frames = 1
	)

func _process(_delta):
	if load_frames == 0:
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
	elif load_frames > 0:
		load_frames -= 1
