extends Area3D

@export var speed = 0.1
@export var _boxSize : int = 5
var size = Vector3(_boxSize, _boxSize, _boxSize)

# CAMERA STUFF
@export var rotation_speed: float = 0.2 
@export var distance_from_target: float = 3.0
var current_angle: float = PI/2
var current_pitch : float = 0 

var pause_menu = preload("res://UI/pauseMenu.tscn")

func InpDown(Inp_Name) -> bool:
	return Input.is_action_pressed(Inp_Name)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var new_x = position.x + cos(current_angle) * distance_from_target
	var new_y = position.y + sin(current_pitch) * distance_from_target
	var new_z = position.z + sin(current_angle) * distance_from_target

	$Camera3D.look_at_from_position(Vector3(new_x, new_y, new_z), position)
	
var debounce : SceneTreeTimer
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		if GameState.paused and ((debounce and debounce.time_left == 0) or not debounce):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			GameState.paused = false
			$/root/Test/UI/PauseMenu.visible = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$/root/Test/UI/PauseMenu.visible = true
			GameState.paused = true
			debounce = get_tree().create_timer(1)
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and GameState.settings["rotate_camera"]:
		current_angle = clamp(current_angle - -event.relative.x * rotation_speed/100, 0, PI)
		current_pitch = clamp(current_pitch - -event.relative.y * rotation_speed/100, -PI/2, PI/2)
		
		var new_x = position.x + cos(current_angle) * distance_from_target
		var new_z = position.z + sin(current_angle) * distance_from_target
		var new_y = position.y + sin(current_pitch) * distance_from_target

		$Camera3D.look_at_from_position(Vector3(new_x, new_y, new_z), position)
		
func _physics_process(_delta: float) -> void:
	if GameState.paused: return
	var x = (-1 if InpDown("move_left") else (1 if (InpDown("move_right")) else 0))
	var y = (-1 if InpDown("move_down") else (1 if (InpDown("move_up")) else 0))
	var direction = Vector3(x, y, 0).normalized()
	var finalPos = (direction * speed + position).clamp(-size + scale/2, size - scale/2)
	
	position = Vector3(finalPos.x, finalPos.y, size.z)


func _on_accelerate_player() -> void:
	speed += 0.02
