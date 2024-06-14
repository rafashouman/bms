extends Marker3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_transform.origin = $"../h/v/SpringArm/Fake_Target".global_transform.origin
	print('Fake_Target', $"../h/v/SpringArm/Fake_Target".global_transform.origin)
	print('Target', global_transform.origin)
