extends Node

const TEX_PATH := "res://resources/textures/objects/"

var tree := ObjectData.new(0, 2, {
	Resources.wood.id: [1, 2]
})

var rock := ObjectData.new(2, 5, {
	Resources.stone.id: [2, 3, 4],
})

var mill := BuildObjectData.new(1, 0.2, "Hand mill", preload(TEX_PATH + "mill.png"), {
	Resources.wood.id: 3,
	Resources.stone.id: 2,
}, 3)

# Crops
var wheat := CropObjectData.new(3, 0.2, "Plant wheat", preload("res://resources/textures/resources/wheat.png"), {
	Resources.wheat_seed.id: 1,
}, preload("res://scenes/objects/Wheat.tscn"), -1, {
	Resources.wheat_seed.id: [1, 2],
	Resources.wheat.id: [2, 3],
}, true)

var all := [tree, rock, mill, wheat]

func with_id(id: int):
	for obj in all:
		if obj.id == id:
			return obj
	return null
