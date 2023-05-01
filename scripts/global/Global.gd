extends Node

signal select(data)
signal tick

var toolbar := [
	Tools.hoe,
	Objects.wheat,
	Terrains.tile,
	Objects.mill,
]

var current = null :
	set(c):
		current = c
		select.emit(c)
		
		if c is ToolData:
			Input.set_custom_mouse_cursor(c.icon, Input.CURSOR_ARROW, c.hotspot)
		else:
			Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
			# Fix invisible cursor
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.timeout.connect(func ():
		tick.emit()
	)
	add_child(timer)
	timer.start(1)
