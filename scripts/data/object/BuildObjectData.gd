class_name BuildObjectData extends ObjectData

var name: String
var icon: Texture2D
var resources: Dictionary
var use_time: float
var terrain: int
var place_multiple: bool

func _init(
	_id: int, _break_time: float, _name: String, _icon: Texture2D, _resources: Dictionary,
	_use_time: float = -1, _drops: Dictionary = _resources, _terrain: int = -1,
	_place_multiple: bool = false
):
	super(_id, _break_time, _resources)
	name = _name
	icon = _icon
	resources = _resources
	use_time = _use_time
	terrain = _terrain
	place_multiple = _place_multiple
