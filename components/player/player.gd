extends CharacterBody3D

@export_group("Move Controls")
@export var move_enabled : bool = true

@export_group("Movement Variables")
@export var gravity : float = 30
@export var accel : float = 250
@export var max_vel : float = 10
@export var jump_force : float = 1
@export var friction : float = 6
@export var bhop_frames : int = 2

@export_group("Camera")
@export var sensitivity : float = 0.4
@export var camera_move_enabled : bool = true

@onready var camera : Camera3D = $Camera3D


func _ready() -> void:
	debug.log("Player is loaded")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	handle_movement(delta)


func handle_movement(delta):
	velocity = get_next_velocity(velocity, delta)
	move_and_slide()


func accelerate(accelDir, prevVelocity, acceleration, _max_vel, delta):
	var projectedVel = prevVelocity.dot(accelDir)
	var accelVel = clamp(_max_vel - projectedVel, 0, acceleration * delta)
	return prevVelocity + accelDir * accelVel


func _unhandled_input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_look(event)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_mouse_mode()


func _toggle_mouse_mode() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


var frame_timer = bhop_frames
func update_frame_timer():
	if is_on_floor():
		frame_timer += 1
	else:
		frame_timer = 0


func mouse_look(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func get_wishdir():
	if not move_enabled:
		return Vector3.ZERO
	return Vector3.ZERO + \
			(transform.basis.z * Input.get_axis("up", "down")) +\
			(transform.basis.x * Input.get_axis("left", "right"))


func get_jump():
	return sqrt(4 * jump_force * gravity)


func get_gravity(delta):
	return gravity * delta


func get_next_velocity(previousVelocity, delta):
	if is_on_floor() and (frame_timer >= bhop_frames):
		var speed = previousVelocity.length()
		if speed != 0:
			var drop = speed * friction * delta
			previousVelocity *= max(speed - drop, 0) / speed
	velocity = accelerate(get_wishdir(), previousVelocity, accel, max_vel, delta)
	velocity += Vector3.DOWN * get_gravity(delta)
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = get_jump()
	return velocity
