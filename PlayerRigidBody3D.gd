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
	DebugDraw3D.draw_line(self.global_transform.origin, (self.global_transform.origin + local_gravity*10.0), Color(1, 1, 0))
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print(event.relative.y)
		$PlayerNode/CameraPivot.rotation.x -= event.relative.y / 500.0
	
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
	
	#var planet_coll_shs = get_tree().get_nodes_in_group("PlanetCollisionShape")
	#print(planet_coll_shs)
	#for col_sh in planet_coll_shs:
		#var sh = col_sh.get_shape()
		#print(sh.radius)
		
	#var inside_planets_coll = false
	#var planets = get_tree().get_nodes_in_group("Planet")
	#for planet in planets:
		##print("planet", planet.scale)
		#var col = planet.get_node("CollisionShape3D")
		##print("radius", col.get_shape().radius)
		##print("col", col.scale)
		#var total_scale = planet.scale * col.scale * 1.5 # * col.get_shape().radius
		#var planet_pos = planet.position
		#
		#if self.position.distance_to(planet.position) < total_scale.x:
			#inside_planets_coll = true
	#print("inside_planets_coll", inside_planets_coll)
	#if not inside_planets_coll:
		#var closest = planets[0]
		#for planet in planets:
			#if self.position.distance_to(planet.position) < self.position.distance_to(closest.position):
				#closest = planet
		#var col = closest.get_node("CollisionShape3D")
		##print(col.get_shape().radius)
		##print("col", col.scale)
		#var total_scale = closest.scale * col.scale
		#var planet_pos = closest.position				
		#self.position = closest.position
		
		
	_move_direction = _get_model_oriented_input()
	
	if Input.is_action_just_pressed("ui_accept"):
		#if is_on_floor(state):
		self.apply_central_impulse(-local_gravity * 40.0)
	
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
		_orient_character_to_direction(_last_strong_direction, state.step)
	
	if is_on_floor(state):
		self.apply_central_force(_move_direction * -100.0)

	if facing != 0:
		#print("facing: ", facing)
		self.basis = self.basis.rotated(Vector3(1.0,0.0,0.0).normalized(), facing)
		facing = 0
	
	#var norm = (p.global_transform.origin - self.global_transform.origin).normalized()
	#### CHECKOUT: https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/
	self.basis.y = -local_gravity
	#self.basis.x = -self.basis.z.cross(norm) #.rotated(Vector3(10.0,1.0,1.0), TAU/2)
	
	

func is_on_floor(state: PhysicsDirectBodyState3D) -> bool:
	# Contacts_reported needs to be high enough to count all surfaces on body
	for contact in state.get_contact_count():
		var contact_normal = state.get_contact_local_normal(contact)
		# If the contact is below us we are on the floor
		#print("contact_normal", contact_normal.dot(-local_gravity))
		if contact_normal.dot(-local_gravity) > 0.5:
			return true
	return false
