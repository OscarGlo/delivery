class_name SceneObjectData extends BuildObjectData

var scene: PackedScene

func _init(
	_id: int, _break_time: float, _name: String, _icon: Texture2D, _resources: Dictionary,
	_scene: PackedScene, _use_time: float = -1, _drops: Dictionary = _resources,
	_place_multiple: bool = false
):
	super(_id, _break_time, _name, _icon, _resources, _use_time, _drops, -1, _place_multiple)
	drops = _drops
	scene = _scene
