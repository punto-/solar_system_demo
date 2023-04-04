extends Node


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("toggle_mouse_captured"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("toggle_fullscreen"):
		var mode := DisplayServer.window_get_mode(0)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if mode == DisplayServer.WINDOW_MODE_WINDOWED else mode)
		get_viewport().set_input_as_handled()
