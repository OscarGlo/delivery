extends Node

const TEX_PATH := "res://resources/textures/resources/"

var wood := ResourceData.new(0, preload(TEX_PATH + "wood.png"))
var stone := ResourceData.new(1, preload(TEX_PATH + "stone.png"))
var wheat_seed := ResourceData.new(2, preload(TEX_PATH + "wheat_seed.png"))
var wheat := ResourceData.new(3, preload(TEX_PATH + "wheat.png"))
var flour := ResourceData.new(4, preload(TEX_PATH + "flour.png"))

var all := [wood, stone, wheat_seed, wheat, flour]
var collected := [0, 0, 5, 0, 0]

func with_id(id: int):
	for res in all:
		if res.id == id:
			return res
	return null
