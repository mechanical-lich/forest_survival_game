extends RigidBody3D
class_name Lumber

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_3d_body_entered(body: Node3D):
	if body.name == "Player":
		var player: Player = body
		for slot_data in player.Inventory.slot_data:
			if slot_data != null:
				if slot_data.item_data.name == "Lumber":
					slot_data.set_quantity(slot_data.quantity+1)
		queue_free()
