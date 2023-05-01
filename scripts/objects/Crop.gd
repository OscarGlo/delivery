class_name Crop extends TileNode

@export var grow_time := 120
@export var stages := 4

var mature := false

func _ready():
	super()
	Global.tick.connect(func ():
		if randf() < float(stages) / grow_time and $Sprite.frame < stages - 1:
			$Sprite.frame += 1
			
			if $Sprite.frame == stages - 1:
				mature = true
	)
