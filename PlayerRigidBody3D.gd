extends RigidBody3D

@onready var _model = $PlayerNode

## How fast the player moves on the ground.
@export var move_speed := 80.0
## Strength of the impulse applied upwards for the player's jump.
@export var jump_initial_impulse := 20.0
## How fast the player can turn around to match a new direction.
@export var rotation_speed := 2.0

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var local_gravity := Vector3.DOWN
var _should_reset := false


#@onready var _camera_controller = get_node(camera_path)
@onready var _start_position := global_transform.origin

var facing = TAU / 2

func _ready() -> void:
	#_model.max_ground_speed = 4.0
	pass

func get_global_position2() -> Vector3:
	return self.global_position
	
func _process(delta: float) -> void:
	#var planet_nodes = get_tree().get_nodes_in_group("planet")
	#var p = planet_nodes[0]
	#var ppaxis: Vector3 = (p.global_transform.origin - self.global_transform.origin).normalized()
	#DebugDraw3D.draw_line(p.global_transform.origin, ppaxis, Color(0, 0, 1))
#
	##print(p)
	#DebugDraw3D.draw_line(p.global_transform.origin, self.global_transform.origin, Color(1, 1, 0))
	#
	#var c = p.global_transform.origin.cross(self.global_transform.origin)
	#DebugDraw3D.draw_line(p.global_transform.origin, c, Color(1, 0, 0))
	
	DebugDraw3D.draw_line(self.global_transform.origin, (self.global_transform.origin + local_gravity*10.0), Color(1, 1, 0))
	
	
	#var input_left_right := (
		#Input.get_action_strength("ui_left")
		#- Input.get_action_strength("ui_right")
	#)
	#print(input_left_right)
	#facing = (TAU / 2 * input_left_right)
	#print(facing)
	
		
	#if is_on_floor(state):
		#print("on floor")
			#
	#if Input.is_action_pressed("ui_down"):
		#self.apply_central_force(self.transform.basis * Vector3(-10.0, 0.0, 0.0))
		##
	#if Input.is_action_pressed("ui_up"):
		#self.apply_central_force(self.transform.basis * Vector3(10.0, 0.0, 0.0))
##
	#if Input.is_action_pressed("ui_left"):
		#facing = TAU / 8
		##self.apply_central_force(self.basis * Vector3(0.0, 0.0, 10.0))
				##
	#if Input.is_action_pressed("ui_right"):
		#facing = -TAU / 8
		#self.apply_central_force(self.basis * Vector3(0.0, 0.0, -10.0))
		#
	#if Input.is_action_pressed("ui_accept"):
		#self.apply_central_force(self.basis * Vector3(0.0, 50.0, 10.0))	
	
	
func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := -local_gravity.cross(direction)
	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	self.transform.basis = Basis(self.transform.basis.get_rotation_quaternion().slerp(
		rotation_basis, delta * rotation_speed
	))
	
func _get_model_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("ui_left")
		- Input.get_action_strength("ui_right")
	)
	var input_forward := Input.get_action_strength("ui_up")

	var raw_input = Vector2(input_left_right, input_forward)

	var input := Vector3.ZERO
	# This ensures correct analogue input strength in any direction with a joypad stick
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = self.transform.basis * input
	return input	
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	local_gravity = state.total_gravity.normalized()
	print("local_gravity", local_gravity)
	
	_move_direction = _get_model_oriented_input()
	
	if Input.is_action_just_pressed("ui_accept"):
		self.apply_central_impulse(-local_gravity * 40.0)
	
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
		_orient_character_to_direction(_last_strong_direction, state.step)
	
	#if _move_direction.length() > 0:
		##print("_move_direction:", _move_direction)
		##self.apply_central_force(_move_direction * move_speed)
		##self.add_constant_central_force(_move_direction * move_speed)
		#if is_on_floor(state):
			##print("moving", _move_direction)
			##self.add_constant_force(_move_direction)
			#self.apply_central_force(_move_direction * -50.0)
	
	if is_on_floor(state):
		self.apply_central_force(_move_direction * -50.0)
	#if Input.is_action_pressed("ui_up"):
		#self.apply_central_force(self.transform.basis * Vector3(0.0, 0.0, -1 * polarz * 10.0))
		##
	#if Input.is_action_pressed("ui_down"):
		#self.apply_central_force(self.transform.basis * Vector3(0.0, 0.0, polarz * 10.0))
##
	#if Input.is_action_pressed("ui_left"):
		#facing = polarx * TAU / 32
		##self.apply_central_force(self.basis * Vector3(0.0, 0.0, 10.0))
				##
	#if Input.is_action_pressed("ui_right"):
		#facing = -1 * polarx * TAU / 32	
	#

	#if Input.is_action_pressed("ui_down"):
		#facing = facing + (Vector3.LEFT * 0.1)
	#if Input.is_action_pressed("ui_up"):
		#facing = facing + (Vector3.DOWN * 0.1)
	
	#var left_axis := -local_gravity.cross(direction)
	#var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	#self.transform.basis = Basis(_model.transform.basis.get_rotation_quaternion().slerp(
		#rotation_basis, state.step * rotation_speed
	#))
	
	var mspeed = 5.0
	var oi = self._get_model_oriented_input()
	#print(oi * mspeed)
	#self.apply_central_force(oi * mspeed)
	
	# orient to direction
	#var left_axis := -ppaxis.cross(_last_strong_direction)
	#var rotation_basis := Basis(left_axis, -ppaxis, _last_strong_direction).orthonormalized()
	#self.basis = Basis(self.basis.get_rotation_quaternion().slerp(
		#rotation_basis, state.step * rotation_speed
	#))
	
	#self.transform.rotated(Vector3(10.0,10.0,1.0), TAU/2)
	if facing != 0:
		#print("facing: ", facing)
		self.basis = self.basis.rotated(Vector3(1.0,0.0,0.0).normalized(), facing)
		facing = 0
	
	#var norm = (p.global_transform.origin - self.global_transform.origin).normalized()
	#### CHECKOUT: https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/
	self.basis.y = -local_gravity
	#self.basis.x = -self.basis.z.cross(norm) #.rotated(Vector3(10.0,1.0,1.0), TAU/2)
	
	#self.basis.y.rotated(oi, TAU / 2)
	#self.basis = self.basis.orthonormalized()
	
	#print(_model.transform)
	
	#self.basis.z = facing.cross(-norm)
	
	#if Input.is_action_pressed("ui_down"):
		#var rotation_amount = 0.1
		#transform.basis = Basis(norm, rotation_amount) * transform.basis
		
	#xform.basis.y = new_y
	#xform.basis.x = -xform.basis.z.cross(new_y)
	#xform.basis = xform.basis.orthonormalized()
	

func is_on_floor(state: PhysicsDirectBodyState3D) -> bool:
	# Contacts_reported needs to be high enough to count all surfaces on body
	for contact in state.get_contact_count():
		var contact_normal = state.get_contact_local_normal(contact)
		# If the contact is below us we are on the floor
		print("contact_normal", contact_normal.dot(-local_gravity))
		if contact_normal.dot(-local_gravity) > 0.5:
			return true
	return false
