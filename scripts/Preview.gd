extends Node2D

const GameResource = preload("res://scenes/Resource.tscn")
const outline = preload("res://resources/textures/outline.png")

@onready var terrain: Terrain = $"../Terrain"
@onready var objects: TileMap = $"../Objects"

@export var player_range = 150

func _ready():
	$Icon.scale = terrain.scale
	Global.select.connect(func (data):
		$Icon.texture = data.icon if data and not data is ToolData else outline
	)

func _tilemap_mouse_pos() -> Vector2i:
	return terrain.local_to_map(get_global_mouse_position() / terrain.scale)

func _snap_mouse_pos() -> Vector2:
	return terrain.map_to_local(_tilemap_mouse_pos()) * terrain.scale

var in_range = false
var pointed_object = null
var pointed_terrain = null

func _can_place() -> bool:
	var current = Global.current
	if in_range and (current == null or (
		pointed_terrain != Terrains.water.id
		and not (current is CropObjectData and pointed_terrain != Terrains.tilled_dirt.id)
	)):
		if current != null and "resources" in current and current.resources != null:
			for id in current.resources:
				if Resources.collected[id] < current.resources[id]:
					return false
		return true
	return false

var action_pos := {}

func _timed_action(
	id: StringName,
	pos: Vector2i,
	delta: float,
	get_duration: Callable,
	doing: Callable,
	done: Callable
):
	if in_range and doing.call():
		if id in action_pos and pos == action_pos[id]:
			if $Progress.value >= $Progress.max_value:
				$Progress.value = 0
				done.call()
			else:
				$Progress.value += delta
		else:
			action_pos[id] = pos
			$Progress.visible = true
			$Progress.value = 0
			$Progress.max_value = get_duration.call()
	elif id in action_pos:
		action_pos.erase(id)
		$Progress.value = 0
		$Progress.visible = false

func _process(delta):
	position = _snap_mouse_pos()
	
	var mouse = _tilemap_mouse_pos()
	in_range = position.distance_to($"../Character".position) < player_range
	pointed_object = Objects.with_id(objects.get_cell_source_id(0, mouse))
	pointed_terrain = terrain.get_type(mouse)
	
	# Preview visuals
	$Icon.modulate = Color(1, 1, 1, 0.5) if _can_place() else Color(1, 0.5, 0.5, 0.5)
	$Icon.visible = pointed_object == null
	
	_timed_action("Break objects", mouse, delta,
		func (): return pointed_object.break_time,
		func (): return Input.is_action_pressed("right_click") and pointed_object != null,
		func (): _break_object(mouse)
	)
	
	if pointed_object != null and "use_time" in pointed_object:
		_update_use_object(mouse, delta)
	
	if Global.current is ToolData:
		_update_tool_action(mouse, delta)

func _drop_resource(pos: Vector2, data: ResourceData):
	var res: Node2D = GameResource.instantiate()
	res.init(data)
	res.position = pos
	res.character = $"../Character"
	$"../Resources".add_child(res)

func _break_object(pos: Vector2i):
	# Get related node
	var node = null
	if "scene" in pointed_object:
		node = objects.get_node(TileNode.gen_name(pos))
	
	# Delete actual tile
	objects.erase_cell(0, pos)
	objects.set_cells_terrain_connect(0, [pos], 0, -1)
	
	# Do not yield from non mature crops
	if "crop" in pointed_object:
		if not node.mature:
			return
	
	# Drop resources
	if "drops" in pointed_object or "resources" in pointed_object:
		var drops = pointed_object.drops if "drops" in pointed_object else pointed_object.resources
		for id in drops:
			var count = drops[id] if drops[id] is int else drops[id][randi() % drops[id].size()]
			for i in range(count):
				_drop_resource(_snap_mouse_pos(), Resources.with_id(id))

func _update_use_object(pos: Vector2i, delta: float):
	match pointed_object:
		Objects.mill:
			_timed_action("Mill wheat", pos, delta,
				func (): return Objects.mill.use_time,
				func (): return Input.is_action_pressed("left_click") and Resources.collected[Resources.wheat.id] > 0,
				func ():
					for i in range(2):
						_drop_resource(_snap_mouse_pos() + Vector2(0, 16), Resources.flour)
					Resources.collected[Resources.wheat.id] -= 1
			)

func _update_tool_action(pos: Vector2i, delta: float):
	match Global.current:
		Tools.hoe:
			_timed_action("Till ground", pos, delta,
				func (): return 1,
				func (): return Input.is_action_pressed("left_click")\
					and pointed_terrain in [Terrains.dirt.id, Terrains.grass.id]\
					and pointed_object == null,
				func (): terrain.set_type(pos, Terrains.tilled_dirt.id)
			)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.current = null
	
	var mouse = _tilemap_mouse_pos()
	var current = Global.current
	
	# Placing
	if (current is BuildObjectData or (current is TerrainData and pointed_terrain != current.id))\
		and _can_place() and pointed_object == null  and (
			"place_multiple" in current and Input.is_action_pressed("left_click")
			or event.is_action_pressed("left_click")
		):
		if current is BuildObjectData:
			if current.terrain >= 0:
				objects.set_cells_terrain_connect(0, [mouse], 0, current.terrain, false)
			else:
				objects.set_cell(0, mouse, current.id, Vector2i.ZERO)
		else:
			terrain.set_type(mouse, current.id)
		
		if current is SceneObjectData:
			var scene: TileNode = current.scene.instantiate()
			scene.position = objects.map_to_local(mouse)
			objects.add_child(scene)
		
		for id in current.resources:
			Resources.collected[id] -= current.resources[id]
