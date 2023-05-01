extends Node

var dirt := TerrainData.new(0)
var grass := TerrainData.new(1)
var sand := TerrainData.new(2)
var water := TerrainData.new(3)
var tilled_dirt := TerrainData.new(4)
var tile := TerrainData.new(5, "Tile", preload("res://resources/textures/terrain/tile.png"), {
	Resources.stone.id: 1
}, true)
