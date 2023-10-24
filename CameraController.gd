extends Camera3D

@export var rotation_speed := 10.0
@export var player: CharacterBody3D
@export var raycast: RayCast3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raycast.is_colliding():
		self.global_position = self.global_position.slerp(raycast.get_collision_point(), 10 * delta)
	else:
		self.position = self.position.slerp(raycast.target_position, 10 * delta)
	var velocity = player.velocity.project(player.forward_vec).length()
	
	if velocity > 10:
		raycast.target_position.z = lerpf(raycast.target_position.z, remap(velocity, 0, 25, 4, 2), 10 *delta)
		self.fov = lerpf(self.fov, remap(velocity, 0, 25, 70, 120), 10 * delta)
	else:
		# TODO velocity is never negative, if it was negative I could just clamp it to zero
			
		raycast.target_position.z = lerpf(raycast.target_position.z, remap(velocity, 0, 25, 4, 2), 10 * delta)
		self.fov = lerpf(self.fov, remap(velocity, 0, 25, 70, 120), 30 * delta)
	# print(fov)
	# self.global_rotation.x = lerp_angle(self.global_rotation.x, camera_target.global_rotation.x, rotation_speed * delta)
	# self.global_rotation.y = lerp_angle(self.global_rotation.y, camera_target.global_rotation.y, rotation_speed * delta)
	# self.global_rotation.z = lerp_angle(self.global_rotation.z, camera_target.global_rotation.z, rotation_speed * delta)
	# if Input.is_action_pressed("drift"):
	# 	self.global_position = self.global_position.slerp(position_target.global_position, position_speed / 1.2 * delta)
	# else:
	# 	self.global_position = self.global_position.slerp(position_target.global_position, position_speed * delta)
	pass
