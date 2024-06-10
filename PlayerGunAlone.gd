extends Node3D


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_anim = get_node("AnimationPlayer")
	player_anim.play("Walk2")
	pass
