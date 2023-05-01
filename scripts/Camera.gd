extends Camera2D

func _unhandled_input(event):
	if event.is_action_pressed("scroll_up"):
		zoom += Vector2.ONE * 0.1
	elif event.is_action_pressed("scroll_down"):
		zoom -= Vector2.ONE * 0.1
	zoom = zoom.clamp(Vector2.ONE, Vector2.ONE * 2)
