extends Node3D
var mesh = preload("res://Art/cube_filled.obj")
var material = preload("res://Art/white_filled.tres")
@export var size : Vector2 = Vector2(100,100)
var debounce = false
var current_amp = 1

func create_pillar(pos : Vector3) -> MeshInstance3D:
	var pillar = MeshInstance3D.new()
	$Pillars.add_child(pillar)
	pillar.mesh = mesh
	pillar.material_override = material
	pillar.position = pos
	return pillar
	
func get_height(x : int, y : int) -> float:
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	var sHeight = remap(noise.get_noise_2d(x, y), -1, 1, 0, 5)
	return sHeight
	
func _ready() -> void:
	for x in range(size.x):
		for y in range(size.y):
			var noise = FastNoiseLite.new()
			noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
			var height = get_height(x, y)
			var pillar = create_pillar(Vector3(x - size.x/2, height, y))
			pillar.scale = Vector3(0.5, height, 0.5)
			
func _process(delta: float) -> void:
	if debounce: return
	get_tree().create_tween()
