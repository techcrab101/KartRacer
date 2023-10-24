extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var max_speed = 25.0
var max_rev_speed = 5.0

var speed_input := 0.0
var brake_input := 0.0

var steering_input := 0.0
var steering := 0.0

var forward_vec = Vector3.ZERO
var right_vec = Vector3.ZERO
var velocity_norm = Vector3.ZERO
var velocity_mag := 0.0;
var is_drifting := false

const DRAG = 2.0;
const GROUND_ACC = 5.0;
const AIR_ACC = 1.0;
var acc = 0;

var drift_timer := 10.0
var gravity_vec := Vector3.DOWN
var grounded = false

func _ready():
	gravity_vec = Vector3.DOWN
	up_direction = -gravity_vec

func _physics_process(delta):
	speed_input = Input.get_action_strength("accelerate")
	brake_input = Input.get_action_strength("brake")
	steering_input = 0
	steering_input += Input.get_action_strength("steer_left")
	steering_input -= Input.get_action_strength("steer_right")
	if Input.is_action_pressed("drift") and velocity_mag > (max_speed / 3):
		is_drifting = true
	else:
		is_drifting = false
	
	forward_vec = -self.global_transform.basis.z
	right_vec = self.global_transform.basis.x
	
	print(velocity_mag)
	print(velocity.length())
	
	if is_on_wall():
		velocity_mag = velocity.length()
	if !is_on_floor():
		velocity += gravity_vec * gravity * delta
		grounded = false
	else:
		gravity_vec = -get_floor_normal()
		up_direction = -gravity_vec
		var new_basis = self.global_transform.basis.rotated(right_vec, -forward_vec.dot(up_direction))
		self.global_transform.basis = new_basis.rotated(forward_vec, right_vec.dot(up_direction))
		grounded = true
		
	if steering_input and abs(velocity_mag) > 0:
		steering = steering_input * deg_to_rad(45) * sign(velocity_mag)
		if is_drifting:
			steering *= 2
		if !grounded:
			steering /= 2
		self.rotate_object_local(Vector3.UP, steering * delta)
	else:
		steering = move_toward(steering, 0, delta)
	
	if is_drifting:
		velocity_norm = velocity_norm.move_toward(forward_vec, delta)
	else:
		velocity_norm = velocity_norm.move_toward(forward_vec, 10 * delta)

	if (grounded):
		acc = GROUND_ACC
	else:
		acc = AIR_ACC
		
	if brake_input:
		velocity_mag = -brake_input * max_rev_speed
	elif speed_input:
		velocity_mag = speed_input * max_speed
	else:
		velocity_mag = move_toward(velocity_mag, 0, acc * delta)
	
	velocity = velocity.lerp(forward_vec * velocity_mag, acc * delta)

	move_and_slide()
