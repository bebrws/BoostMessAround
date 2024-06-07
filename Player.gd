extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(basis.y * delta * 1000.0)
		 
	if Input.is_action_pressed("ui_left"):
		apply_torque(Vector3(100.0 * delta, 0.0, 0.0))
		
	if Input.is_action_pressed("ui_right"):
		apply_torque(Vector3(-100.0 * delta, 0.0,0.0))
