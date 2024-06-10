extends Camera3D

@export var target: Node3D
@export var lerp_speed: float


var offset: Vector3
var rot: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#target = get_parent_node_3d()
	offset = position
	rot = rotation
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	var players = get_tree().get_nodes_in_group("player")
	##print(players[0].position)
	#self.global_position = self.global_position.lerp(target.global_position + offset, lerp_speed)
	#self.global_rotation = self.global_rotation.lerp(target.global_rotation + rot, lerp_speed)
	#self.global_basis = self.global_basis.slerp(target.global_basis, lerp_speed)
	var planet_nodes = get_tree().get_nodes_in_group("planet")
	var p = planet_nodes[0]
	var ppaxis: Vector3 = (p.global_transform.origin - self.global_transform.origin).normalized()
	#
	#var norm = (p.global_transform.origin - self.global_transform.origin).normalized()
	##### CHECKOUT: https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/
	#self.basis.y = -norm
	#self.basis.x = -self.basis.z.cross(norm) #.rotated(Vector3(10.0,1.0,1.0), TAU/2)
	#
	#self.translate(ppaxis * 10.0)
	self.look_at(players[0].position, ppaxis)
	
