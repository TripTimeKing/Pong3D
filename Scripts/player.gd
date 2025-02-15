extends Area3D

@export var speed = 0.1 # How fast the player moves
@export var _boxSize : int = 5 # Size of the box the game is played in
var size = Vector3(_boxSize, _boxSize, _boxSize)

# CAMERA STUFF
@export var rotation_speed: float = 0.2 # How fast the camera rotates
@export var vertical_speed : float = 0.2 # How fast the camera rotates on the Y axis
@export var distance_from_target: float = 3.0 # How far away from the center of the player the camera is
var current_angle: float = PI/2
var current_pitch : float = 0 

func InpDown(Inp_Name) -> bool:
	return Input.is_action_pressed(Inp_Name)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var new_x = position.x + cos(current_angle) * distance_from_target
	var new_z = position.z + sin(current_angle) * distance_from_target
	var new_y = position.y + sin(current_pitch) * distance_from_target

	$Camera3D.look_at_from_position(Vector3(new_x, new_y, new_z), position)
	

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		current_angle = clamp(current_angle - -event.relative.x * rotation_speed/100, 0, PI)
		current_pitch = clamp(current_pitch - -event.relative.y * vertical_speed/100, -PI/2, PI/2)
		
		#print(rad_to_deg(current_angle), ": ANGLE")
		#print (rad_to_deg(current_pitch), ": PITCH")
		
		var new_x = position.x + cos(current_angle) * distance_from_target
		var new_z = position.z + sin(current_angle) * distance_from_target
		var new_y = position.y + sin(current_pitch) * distance_from_target

		$Camera3D.look_at_from_position(Vector3(new_x, new_y, new_z), position)

func _physics_process(_delta: float) -> void:
	var x = (-1 if InpDown("move_left") else (1 if (InpDown("move_right")) else 0))
	var y = (-1 if InpDown("move_down") else (1 if (InpDown("move_up")) else 0))
	var direction = Vector3(x, y, 0).normalized()
	var finalPos = (direction * speed + position).clamp(-size + scale/2, size - scale/2)
	
	position = Vector3(finalPos.x, finalPos.y, size.z)


func _on_accelerate_player() -> void:
	speed += 0.5
