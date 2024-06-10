extends Camera3D

@onready var player = get_parent()
var offset : Vector3

func _init():
	self.top_level = true

func _ready():
	offset = get_global_transform().origin

func _physics_process(delta):
	var target = player.get_global_transform().origin
	var base = get_global_transform().basis
	set_global_transform(Transform3D(base, target + offset))
