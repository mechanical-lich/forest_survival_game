extends Node3D
class_name Buildable

@onready var SafeBox:CSGBox3D = $SafeBox
var validLocation: bool = true
var beingPlaced: bool = false
@onready var collision_shape_3d:CollisionShape3D = $Mesh/StaticBody3D/CollisionShape3D

func _physics_process(delta):			
	if beingPlaced:
		if collision_shape_3d != null:
			collision_shape_3d.disabled = true
		if !SafeBox.visible:
			SafeBox.show()
		if validLocation:
			SafeBox.material.albedo_color = Color(0,1,0)
		else:
			SafeBox.material.albedo_color = Color(1,0,0)
	else:
		if collision_shape_3d != null:
			collision_shape_3d.disabled = false	


func _on_area_3d_body_entered(body):
	if body.name != "Floor" and body != $Mesh/StaticBody3D:
		validLocation = false


func _on_area_3d_body_exited(body):
	if body.name != "Floor":
		validLocation = true

