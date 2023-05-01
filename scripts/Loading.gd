extends ColorRect

const Game = preload("res://scenes/Game.tscn")

var game
var loading = false

func _ready():
	game = Game.instantiate()
	get_tree().root.add_child.call_deferred(game)
