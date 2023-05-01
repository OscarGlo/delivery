extends Button

const ResourceDisplay = preload("res://scenes/gui/ResourceDisplay.tscn")

var data = null

func init(d):
	data = d
	$VBox/Icon.texture = d.icon
	$VBox/Label.text = d.name
	
	$Tooltip.size.x = 0
	
	if "resources" in d:
		for id in d.resources:
			var node = ResourceDisplay.instantiate()
			node.count = d.resources[id]
			node.init(Resources.with_id(id))
			$Tooltip/HBox.add_child(node)
		
		$Tooltip.size.x += 40 * len(d.resources) + 10

func _ready():
	pressed.connect(func (): Global.current = data)

func _process(_delta):
	$Tooltip.visible = is_hovered()
	if is_hovered():
		$Tooltip.position = get_local_mouse_position()
		$Tooltip.position.y -= $Tooltip.size.y + 10
