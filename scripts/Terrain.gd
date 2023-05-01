class_name Terrain extends TileMap

const SIZE = 128
const SCALE = 1.5
const TERRAINS = [-1, 0, 1, 2]

# 0 Dirt
# 1 Grass
# 2 Sand
# 3 Water

@onready var objects = $"../Objects"

func _ready():
	generate()

func generate():
	var terrain = FastNoiseLite.new()
	terrain.fractal_octaves = 3
	terrain.seed = randi()
	
	var terrain_tiles = { 1: [], 2: [], 3: [] }
	
	for y in range(SIZE):
		for x in range(SIZE):
			var pos = Vector2i(x, y)
			var bias = 0.5 - 2 * Vector2(pos).distance_to(Vector2.ONE * SIZE / 2) / SIZE
			var n = terrain.get_noise_2dv(pos * SCALE) / 3 + 2 * bias / 3
			
			# Terrain gen
			var t = Terrains.water.id if n < -0.1 \
				else Terrains.sand.id if n < 0 \
				else Terrains.dirt.id if n < 0.1 \
				else Terrains.grass.id
			
			if TERRAINS[t] >= 0:
				terrain_tiles[t].append(pos)
			else:
				set_cell(0, pos, t, Vector2i.ZERO)
			
			# Trees
			if n > 0.15 and randf() < n / 3:
				objects.set_cell(0, pos, Objects.tree.id, Vector2i.ZERO)
			
			# Rocks
			if n > -0.05 and n < 0.05 and randf() < 0.05 + n:
				objects.set_cell(0, pos, Objects.rock.id, Vector2i.ZERO)
	
	for t in terrain_tiles:
		set_cells_terrain_connect(t, terrain_tiles[t], 0, TERRAINS[t], false)
	
	force_update()

func get_type(pos: Vector2i) -> int:
	for l in range(3, -1, -1):
		var id = get_cell_source_id(l, pos)
		var data = get_cell_tile_data(l, pos)
		if id >= 0 and data and data.terrain >= 0:
			return id
	return get_cell_source_id(0, pos)

func set_type(pos: Vector2i, type: int):
	for l in range(3, -1, -1):
		set_cells_terrain_connect(l, [pos], 0, -1, false)
	set_cell(0, pos, type, Vector2.ZERO)
