extends Node3D
class_name ChoppableTree

var Log = load("res://Scenes/log.tscn")
@onready var area_3d = $Area3D
@onready var ray_cast_3d = $StaticBody3D/RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Mesh1").hide()
	var rng = RandomNumberGenerator.new()
	var treeOption = rng.randi_range(1, 4)
	rotate_y(deg_to_rad(rng.randi_range(0,360)))
	get_node("Mesh%d"%treeOption).show()
	
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		position = ray_cast_3d.get_collision_point()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_entered(area):
	if area.name == "Axe":
		area.set_collision_layer_value(2,false)
		for i in 2:
			var l = Log.instantiate()
			l.position = position
			l.position.y += 3 * i
			owner.add_child(l)
			l.apply_central_impulse(area.global_position.direction_to(l.position))
		queue_free()
