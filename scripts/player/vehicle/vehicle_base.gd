extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 270

var cam_speed = float()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta * 3)
	engine_force = Input.get_axis("move_backward", "move_forward") * ENGINE_POWER
