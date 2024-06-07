extends RigidBody3D

@onready var _model = $Node


## How fast the player moves on the ground.
@export var move_speed := 80.0
## Strength of the impulse applied upwards for the player's jump.
@export var jump_initial_impulse := 20.0


var _last_strong_direction := Vector3.FORWARD
var rotation_speed = 10.0
var _move_direction := Vector3.ZERO
var local_gravity := Vector3.DOWN
var _should_reset := false

var rb

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rb = get_tree().current_scene.get_node("RigidBody3D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(basis.z * delta * 1000.0)
		 
	if Input.is_action_pressed("ui_left"):
		apply_torque(Vector3(100.0 * delta, 0.0, 0.0))
		
	if Input.is_action_pressed("ui_right"):
		apply_torque(Vector3(-100.0 * delta, 0.0,0.0))



func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	local_gravity = state.total_gravity.normalized()
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
	_move_direction = _get_model_oriented_input()
	
	_orient_character_to_direction(_last_strong_direction, state.step)
	
	#if is_jumping(state):
		#_model.jump()
		#apply_central_impulse(-local_gravity * jump_initial_impulse)
	#if is_on_floor(state) and not _model.is_falling():
		#add_constant_central_force(_move_direction * move_speed)
	#self.linear_velocity = state.linear_velocity
	
		
func _get_model_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_left")
		- Input.get_action_strength("move_right")
	)
	var input_forward := Input.get_action_strength("move_up")

	var raw_input = Vector2(input_left_right, input_forward)

	var input := Vector3.ZERO
	# This ensures correct analogue input strength in any direction with a joypad stick
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = self.transform.basis * input
	return input
	
func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis = -local_gravity.cross(direction)
	var rotation_basis = Basis(left_axis, -local_gravity, direction).orthonormalized()
	self.transform.basis.get_rotation_quaternion().slerp(rotation_basis.get_rotation_quaternion(), delta * rotation_speed)

func is_on_floor(state: PhysicsDirectBodyState3D) -> bool:
	for contact in state.get_contact_count():
		var contact_normal = state.get_contact_local_normal(contact)
		if contact_normal.dot(-local_gravity) > 0.5:
			return true
	return false



func is_jumping(state: PhysicsDirectBodyState3D) -> bool:
	return Input.is_action_just_pressed("ui_accept") and is_on_floor(state)


func reset_position() -> void:
	_should_reset = true
