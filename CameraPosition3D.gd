extends Node3D

var target: Node3D
var offset: Vector3
var rot: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#target = get_parent_node_3d()
	offset = position
	rot = rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position = self.global_position + offset
	self.global_rotation = self.global_rotation + rot
