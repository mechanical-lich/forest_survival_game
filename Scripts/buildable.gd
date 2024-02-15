extends Node3D
class_name Buildable

@onready var SafeBox:CSGBox3D = $SafeBox
var validLocation: bool = true
var beingPlaced: bool = true

func _physics_process(delta):			
	if beingPlaced:
		if !SafeBox.visible:
			SafeBox.show()
		if validLocation:
			SafeBox.material.albedo_color = Color(0,1,0)
		else:
			SafeBox.material.albedo_color = Color(1,0,0)	


func _on_area_3d_body_entered(body):
	if body.name != "Floor" and body != $Mesh/StaticBody3D:
		print(body.name)
		validLocation = false


func _on_area_3d_body_exited(body):
	if body.name != "Floor":
		validLocation = true
