extends Control
var loadedHS = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print(ProjectSettings.globalize_path("user://savegame.save"))
	
	if not FileAccess.file_exists("user://savegame.save"):
		print("not found save file!")
		return
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		loadedHS = 0
	
	var score_data = json.data
	if typeof(score_data) == TYPE_DICTIONARY:
		loadedHS = score_data["score"]
	
	if GameState.score > loadedHS:
		$Main/Highscore.text = "Highscore: " + str(GameState.score)
		loadedHS = GameState.score
	else:
		$Main/Highscore.text = "Highscore: " + str(loadedHS)
		
	if GameState.score != 0:
		$Main/LastScore.text = "Last score: " + str(GameState.score)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		save_high_score()
		get_tree().quit()
		
func save_high_score():
	var save_dict = {"score" : loadedHS}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	print("saved highscore!")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://test.tscn")
