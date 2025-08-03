extends Control
var loadedHS : int = 0
@onready var grid1 = $grid1
@export var gridEndPos = Vector2(-199,659)
@export var gridStartPos = Vector2(-199,-1112)

func save():
	var save_dict = {"score" : loadedHS, "settings" : GameState.settings}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)

func exit():
	save()
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	print(json_string)
	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		loadedHS = 0
	
	var data = json.data
	if typeof(data) == TYPE_DICTIONARY:
		loadedHS = data["score"]
		GameState.settings = data["settings"]
	
	if GameState.score > loadedHS:
		$Main/Main/Score/Highscore.text = "Highscore: " + str(GameState.score)
		loadedHS = GameState.score
	else:
		$Main/Main/Score/Highscore.text = "Highscore: " + str(loadedHS)
		
	if GameState.score != 0:
		$Main/Main/Score/LastScore.text = "Last score: " + str(GameState.score)
		
	$Settings/HBoxContainer/Settings/Sound/HSlider.value = GameState.settings["sound"]
	$Settings/HBoxContainer/Settings/RotateCamera/CheckBox.button_pressed = GameState.settings["rotate_camera"]
		

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		exit()

func _on_exit_pressed() -> void:
	exit()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		exit()

func _on_play_pressed() -> void:
	await save()
	$Click.play()
	get_tree().change_scene_to_file("res://test.tscn")


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameState.settings["sound"] = $Settings/HBoxContainer/Settings/Sound/HSlider.value


func _on_check_box_toggled(toggled_on: bool) -> void:
	GameState.settings["rotate_camera"] = toggled_on
