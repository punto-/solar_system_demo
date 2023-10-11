extends Node


const Settings = preload("res://settings.gd")
const game_scene: PackedScene = preload("res://demo_game.tscn")

@onready var _main_menu = $MainMenu
@onready var _settings_ui = $SettingsUI

var _settings = Settings.new()
var _game
var _username := ""


func _ready():
	_settings_ui.set_settings(_settings)
	Server.login_requested.connect(_on_login_requested)


func _on_login_requested(_p_data: Dictionary) -> void:
	assert(_game == null)
	_main_menu.hide()
	_game = game_scene.instantiate()
	_game._username = _username
	add_child(_game)
	_game.get_solar_system().set_settings(_settings)
	_game.set_settings_ui(_settings_ui)
	_game.get_solar_system().exit_to_menu_requested.connect(_on_game_exit_to_menu_requested)



func _on_MainMenu_start_requested(p_username):
	_username = p_username
	MultiplayerServer.setup_server()
	Server.join(p_username)



func _on_main_menu_start_client(p_username, server_ip: String = "127.0.0.1") -> void:
	_username = p_username
	MultiplayerServer.setup_client("ws://" + server_ip + ":8080")
	await multiplayer.connected_to_server
	Server.join(p_username)



func _on_MainMenu_settings_requested():
	_settings_ui.show()


func _on_MainMenu_exit_requested():
	get_tree().quit()


func _on_game_exit_to_menu_requested():
	_game.queue_free()
	_game = null
	_main_menu.show()


func _process(_delta):
	AudioServer.set_bus_volume_db(0, linear_to_db(_settings.main_volume_linear))
	DDD.visible = _settings.debug_text
	var viewport: Viewport = get_viewport()
	if _settings.wireframe != (viewport.debug_draw == Viewport.DEBUG_DRAW_WIREFRAME):
		if _settings.wireframe:
			viewport.debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
		else:
			viewport.debug_draw = Viewport.DEBUG_DRAW_DISABLED
		print("Setting viewport draw mode to ", viewport.debug_draw)


func _unhandled_input(event):
	if _game != null:
		# Let the game handle it
		return
	if event is InputEventKey:
		if event.pressed and not event.is_echo():
			if event.keycode == KEY_ESCAPE:
				_settings_ui.hide()



