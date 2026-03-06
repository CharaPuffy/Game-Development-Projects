extends CharacterBody3D

@export var walk_speed: float        = 16.0
@export var jump_power: float        = 50.0
@export var gravity: float           = 196.2
@export var acceleration: float      = 700.0
@export var deceleration: float      = 700.0
@export var turn_smoothing: float    = 18.0
@export var mouse_sensitivity: float = 0.005


@onready var camera_pivot: Node3D = get_parent().get_node("CameraPivot")
@onready var camera_3d: Camera3D  = camera_pivot.get_node("SpringArm3D/Camera3D")

var _is_dragging: bool = false


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_is_dragging = event.pressed

	if event is InputEventMouseMotion and _is_dragging:
		camera_pivot.rotation.y -= event.relative.x * mouse_sensitivity
		camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x,
			deg_to_rad(-75),
			deg_to_rad(75)
		)


func _physics_process(delta: float) -> void:

	camera_pivot.global_position = global_position + Vector3(0.0, 0.7, 0.0)

	# ── Gravity ───────────────────────────────────────────────
	if not is_on_floor():
		velocity.y -= gravity * delta

	# ── Jump ──────────────────────────────────────────────────
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	var cam_basis: Basis    = camera_3d.global_transform.basis
	var cam_forward: Vector3 = -cam_basis.z  # direction camera looks into scene
	var cam_right: Vector3   =  cam_basis.x  # direction to camera's right

	# Flatten onto horizontal plane — no vertical movement from WASD
	cam_forward.y = 0.0
	cam_right.y   = 0.0
	if cam_forward.length() > 0.001:
		cam_forward = cam_forward.normalized()
	if cam_right.length() > 0.001:
		cam_right = cam_right.normalized()


	var forward_amount: float = Input.get_axis("move_forward", "move_back")
	var strafe_amount:  float = Input.get_axis("move_left",    "move_right")

	var move_dir: Vector3 = Vector3.ZERO
	move_dir += cam_forward * -forward_amount  # W(-1)*-1=+1 → forward ✓
	move_dir += cam_right   *  strafe_amount   # A(-1)*right = left ✓

	if move_dir.length() > 0.01:
		move_dir = move_dir.normalized()

	# ── Acceleration / deceleration ───────────────────────────
	var h_vel: Vector3  = Vector3(velocity.x, 0.0, velocity.z)
	var accel_t: float  = clamp(acceleration * delta / walk_speed, 0.0, 1.0)
	var decel_t: float  = clamp(deceleration * delta / walk_speed, 0.0, 1.0)

	if move_dir.length() > 0.01:
		h_vel = h_vel.lerp(move_dir * walk_speed, accel_t)
	else:
		h_vel = h_vel.lerp(Vector3.ZERO, decel_t)

	velocity.x = h_vel.x
	velocity.z = h_vel.z

	move_and_slide()

	
	if move_dir.length() > 0.01:
		var target_angle: float = atan2(move_dir.x, move_dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, turn_smoothing * delta)
