extends Control
# https://www.youtube.com/playlist?list=PLQsiR7DILTczMLsN8qmMym7pYfJXynzK0

var following = false
var dragging_start_position = Vector2()

func _on_cbar_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_local_mouse_position()

func _process(_delta):
	# to make the window shake
	# OS.window_position += Vector2(10, 10)
	# OS.window_position += Vector2(-10, 10)
	# OS.window_position += Vector2(10, -10)
	# OS.window_position += Vector2(-10, -10)
	if following:
		OS.set_window_position(OS.window_position + get_global_mouse_position() - dragging_start_position)

func _on_exit_pressed():
	get_tree().quit()
	# OS.window_minimized = true
