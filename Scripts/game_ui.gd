extends Control
var score : int = 0

func _on_gained_point():
	print("gained point")
	score += 1
	$Score.text = "SCORE:" + " " + str(score)

func _ready() -> void:	
	for i in range(2,-1, -1):
		await get_tree().create_timer(1.0).timeout
		$Countdown.text = str(i)
	$Countdown.visible = false


func _on_game_over() -> void:
	score = 0
	$Score.text = "SCORE:" + " 0"
