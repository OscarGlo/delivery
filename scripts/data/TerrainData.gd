class_name TerrainData extends Object

var id: int
var name: String
var icon: Texture2D
var resources: Dictionary
var place_multiple: bool

func _init(
	_id: int, _name: String = "", _icon: Texture2D = null, _resources: Dictionary = {},
	_place_multiple: bool = false
):
	id = _id
	name = _name
	icon = _icon
	resources = _resources
	place_multiple = _place_multiple
