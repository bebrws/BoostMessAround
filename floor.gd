extends Node3D


var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.get_node("P")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_anim = player.get_node("AnimationPlayer")
	player_anim.play("Walk2")
	pass
