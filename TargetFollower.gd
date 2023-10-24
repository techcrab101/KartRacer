extends Node3D


@export var target :Node3D
@export var rotation_speed := 10.0
@export var position_speed := 10.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = self.global_position.slerp(target.global_position, position_speed * delta)

	self.global_rotation.x = lerp_angle(self.global_rotation.x, target.global_rotation.x, rotation_speed * delta)
	self.global_rotation.y = lerp_angle(self.global_rotation.y, target.global_rotation.y, rotation_speed * delta)
	self.global_rotation.z = lerp_angle(self.global_rotation.z, target.global_rotation.z, rotation_speed * delta)
	pass
