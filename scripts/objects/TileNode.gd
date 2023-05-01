class_name TileNode extends Node2D

@onready var tilemap: TileMap = get_parent()

var pos: Vector2i

static func gen_name(_pos: Vector2i):
	return "TileNode_" + str(_pos.x) + "_" + str(_pos.y)

func _ready():
	pos = tilemap.local_to_map(position)
	name = TileNode.gen_name(pos)

func _process(_delta):
	var alt = tilemap.get_cell_alternative_tile(0, pos)
	if alt < 0:
		queue_free()
