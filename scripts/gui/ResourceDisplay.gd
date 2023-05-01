extends HBoxContainer

var id = -1
var count = null

func init(res):
	id = res.id
	$Texture.texture = res.icon
	
	if count != null:
		$Label.text = str(count)

func _process(_delta):
	if count == null:
		$Label.text = str(Resources.collected[id])
