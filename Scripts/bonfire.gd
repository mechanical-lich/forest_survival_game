extends Buildable



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):			
	super(delta)

#
#func _on_area_3d_body_entered(body):
	#if body.name != "Floor" and body != $Mesh/StaticBody3D:
		#print(body.name)
		#validLocation = false
#
#
#func _on_area_3d_body_exited(body):
	#if body.name != "Floor":
		#validLocation = true
