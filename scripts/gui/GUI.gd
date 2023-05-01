extends CanvasLayer

@export var terrain: TileMap

const ToolbarButton := preload("res://scenes/gui/ToolbarButton.tscn")
const ResourceDisplay := preload("res://scenes/gui/ResourceDisplay.tscn")

func _ready():
	for data in Global.toolbar:
		var button = ToolbarButton.instantiate()
		button.init(data)
		$Screen/Toolbar/Buttons.add_child(button)
	
	for res in Resources.all:
		var display = ResourceDisplay.instantiate()
		display.init(res)
		$Screen/ResourceInventory/Displays.add_child(display)
