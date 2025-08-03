extends Area3D

signal gained_point
signal game_over
signal accelerate_player

@export var playerSize : Vector3 = Vector3(1,1,1) # The size of the player palette
@export var speed = 1 # How fast the ball moves
var direction = Vector3(0, 0, 1) # The direction the ball is moving in
var currentSpeed = speed
var isMoving = false
var localScore = 0

func reset_game():
	direction = Vector3(randf_range(-1,1),randf_range(-1,1),1).normalized()
	position = Vector3(0,0,0)
	$Arrow.visible = true
	$Arrow.look_at(global_transform.origin + direction, Vector3.UP, false)
	$Arrow.translate_object_local(Vector3(0,0,-0.5))
	await get_tree().create_timer(3.0).timeout
	isMoving = true
	$Arrow.visible = false

func end_game():
	game_over.emit()
	GameState.score = localScore
	localScore = 0
	isMoving = false
	speed = 1
	$Lose.play()
	await $Lose.finished
	get_tree().change_scene_to_file("res://UI/title.tscn")


func _ready() -> void:
	print(GameState.settings["sound"])
	$Bonk.volume_linear = GameState.settings["sound"] / 10
	$Lose.volume_linear = GameState.settings["sound"] / 10
	reset_game()


func _physics_process(delta: float) -> void:
	if not isMoving or GameState.paused: return
	position = position + direction * delta * speed

func _on_area_entered(hitArea: Area3D) -> void:
	var playerNode : Area3D = get_node("../Player")
	var area = hitArea.get_child(0)
	var newDir = direction.bounce(-hitArea.get_child(0).global_basis.z)
	direction = newDir
	if area.name == "EnemyGoal":
		$Bonk.play()
		gained_point.emit()
		speed += 0.1
		localScore += 1
		if localScore % 15 == 0:
			accelerate_player.emit()
	elif area.name == "Goal":
		call_deferred("end_game")
	elif area.get_parent() == playerNode:
		$Bonk.play()


func _on_player_return_to_menu() -> void:
	end_game()
