extends Node3D

@onready var notice_label:Label = $UI/NoticeLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	notice_label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Save"):
		notice_label.text = "Saving..."
		notice_label.show()
		var map = get_node("Map")
		
		set_children_owner(map,map)
		
		var save_build = PackedScene.new()
		save_build.pack(map)
		ResourceSaver.save(save_build,"res://Save/save.tscn")
		
		notice_label.text = "Saved!"
		var timer = Timer.new()
		timer.wait_time = 2
		add_child(timer)
		timer.start()
		timer.timeout.connect(func():
			notice_label.hide()
			remove_child(timer)
		)
	
	if Input.is_action_just_pressed("Load"):
		notice_label.text = "Loading..."
		notice_label.show()
		var MapScene:PackedScene = load("res://Save/save.tscn")
		var map = MapScene.instantiate()
		remove_child($Map)
		add_child(map)
		
		notice_label.text = "Loaded!"
		var timer = Timer.new()
		timer.wait_time = 2
		add_child(timer)
		timer.start()
		timer.timeout.connect(func():
			notice_label.hide()
			print("test")
			remove_child(timer)
		)

func set_children_owner(owner: Node3D, node: Node3D):
	for child in node.get_children():
		#if child.name == "Table":
			#print(child.name)
			#for t in child.get_children():
				#print(t.name)
		if child.is_in_group("Persistent"):
			child.set_owner(owner)
			set_children_owner(owner,child)
