extends Node

const TEX_PATH := "res://resources/textures/tools/"

var hoe := ToolData.new("Hoe", preload(TEX_PATH + "hoe.png"), Vector2i(2, 3))

var all := [hoe]
