extends Control


@onready var play_button = $Buttons/Play
@onready var exit_button = $Buttons/Exit
@onready var rotate_camera = $Settings/RotateCamera/CheckBox
@onready var sound = $Settings/Sound/HSlider

func _ready() -> void:
	sound.value = GameState.settings["sound"]
	rotate_camera.button_pressed = GameState.settings["rotate_camera"]

func _on_play_pressed() -> void:
	GameState.paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false


func _on_exit_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file("res://UI/title.tscn")
	GameState.paused = false


func _on_sound_drag_ended(value_changed: bool) -> void:
	GameState.settings["sound"] = value_changed

func _on_rotate_camera_toggled(toggled_on: bool) -> void:
	GameState.settings["rotate_camera"] = toggled_on
