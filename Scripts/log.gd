extends Node3D
class_name Log
var Lumber:PackedScene = load("res://Scenes/lumber.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_entered(area: Area3D):
	if area.name == "Axe":
		area.set_collision_layer_value(2,false)
		for i in 4:
			var l = Lumber.instantiate()
			l.position = position
			#l.position.x += i * 0.5
			l.position.y += i * 0.5
			get_parent().add_child(l)
			l.apply_torque(Vector3(10,40,10))
		queue_free()

