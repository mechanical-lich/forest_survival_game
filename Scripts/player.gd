extends CharacterBody3D
class_name Player
# Constants
const WALK_SPEED: float = 4.0
const RUN_SPEED: float = 6.0
const BACKWARD_SPEED: float = 2.0
const STRAFE_SPEED: float = 3.0
const JUMP_VELOCITY: float = 6

# Params
@export var MOUSE_X_SENSITIVITY: = 0.2
@export var MOUSE_Y_SENSITIVITY = 0.05
@export var DefaultRightHandSlot : PackedScene
@export var Inventory : InventoryData

# Globals
@onready var animationPlayer:AnimationPlayer = $Visuals.get_node("AnimationPlayer")
@onready var rightHand:Node3D = get_node("Visuals/Armature_001/Skeleton3D/RightHandAttachment/Slot")
@onready var build_spawn = $build_spawn
@onready var camera_3d:Camera3D = $camera_mount/Camera3D
@onready var head_camera:Camera3D = $HeadCamera
@onready var build_ray_cast:RayCast3D = $BuildRayCast
@onready var camera_mount = $camera_mount
@onready var visuals = $Visuals

var Axe:PackedScene = load("res://Scenes/axe.tscn")
var Bonfire:PackedScene = load("res://Scenes/bonfire.tscn")

var ui_opened: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed: float = 5.0
var locked: bool = false
var building: bool = false
var highlightedBuildable: Buildable = null
var selectedBuildable: Buildable = null


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animationPlayer.play("idle")
	if DefaultRightHandSlot != null:
		if rightHand.get_child_count() == 0:
			var i = DefaultRightHandSlot.instantiate()
			rightHand.add_child(i)
	
func _input(event):
	if ui_opened:
		return
		
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_X_SENSITIVITY))
		if head_camera.current:
			head_camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_Y_SENSITIVITY))
		else:
			visuals.rotate_y(-deg_to_rad(-event.relative.x * MOUSE_X_SENSITIVITY))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * MOUSE_Y_SENSITIVITY))
			build_ray_cast.rotate_x(deg_to_rad(-event.relative.y * MOUSE_Y_SENSITIVITY))
			# Point camera at player
			var target_pos:Vector3 = position
			target_pos.y = target_pos.y + 2
			$camera_mount/Camera3D.look_at(target_pos)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if !ui_opened:
		handleInput()
				
	# Don't let the player move if they are chopping
	if locked:
		velocity.x = 0
		velocity.z = 0
		if !animationPlayer.is_playing():
			# Release the lock and reset the axe's collision layer
			locked = false
			var axe = get_node("Visuals/Armature_001/Skeleton3D/RightHandAttachment/Slot/Axe")
			if axe != null:
				axe.set_collision_layer_value(2,false)
			animationPlayer.play("idle")
	else:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Default to walk speed
		speed = WALK_SPEED
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
		var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			visuals.global_rotation = global_rotation
			#camera_mount.rotate_y(-rot)
			# Set the move speed and animation
			var anim = "walk"
			if Input.is_action_pressed("Run"):
				speed = RUN_SPEED
				anim = "run"
			if Input.is_action_pressed("Left"):
				speed = STRAFE_SPEED
				anim = "strafe_left"
			if Input.is_action_pressed("Right"):
				speed = STRAFE_SPEED
				anim = "strafe_right"
			if Input.is_action_pressed("Down"):
				anim = "walk_backwards"
				speed = BACKWARD_SPEED

				
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
			# Set the currently playing animation if needed
			if animationPlayer.current_animation != anim:
				animationPlayer.play(anim)
		else:
			# Stop moving and idle
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			if animationPlayer.current_animation != "idle":
				animationPlayer.play("idle")


	if build_ray_cast.is_colliding():
		if build_spawn.get_child_count() > 0:
			build_spawn.get_child(0).outOfRange = false
		build_spawn.global_position = build_ray_cast.get_collision_point()
		build_spawn.global_position.y += .01
	else:
		if build_spawn.get_child_count() > 0:
			build_spawn.get_child(0).outOfRange = true
	
	
	if !building:
		if build_ray_cast.is_colliding():
			var body = build_ray_cast.get_collider()
			if highlightedBuildable != body.owner:
				if highlightedBuildable != null: 
					highlightedBuildable.SafeBox.hide()
					highlightedBuildable = null
				if body.owner is Buildable:
					if body.owner.SafeBox != null:
						body.owner.SafeBox.show()
						highlightedBuildable = body.owner
		else:
			if highlightedBuildable != null:
				highlightedBuildable.SafeBox.hide()
		
	move_and_slide()
	
	# Push other physics based objects
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())

func setChopping():
	var axe = get_node("Visuals/Armature_001/Skeleton3D/RightHandAttachment/Slot/Axe")
	if axe != null:
		axe.set_collision_layer_value(2,true)
	
func handleInput():
	if Input.is_action_just_pressed("Switch_Camera"):
		if head_camera.current:
			camera_3d.current = true
		else:
			head_camera.current = true
	# Bonfire
	if Input.is_action_just_pressed("Spawn_Bonfire") and build_spawn.get_child_count() == 0:
		var bonfire = Bonfire.instantiate()
		bonfire.beingPlaced = true
		build_spawn.add_child(bonfire)
		building = true
	
	# Equip Axe
	if Input.is_action_just_pressed("Tool_1"):
		if rightHand.get_child_count() == 0:
			var a = Axe.instantiate()
			rightHand.add_child(a)
		else:
			rightHand.remove_child(rightHand.get_child(0))
	
			
	if Input.is_action_just_pressed("Cancel_Build") and build_spawn.get_child_count() > 0:
		building = false
		var c = build_spawn.get_child(0)
		build_spawn.remove_child(c)
		c.queue_free()	
	
	
	if Input.is_action_just_pressed("Build"):
		if building == true:	
			var buildable:Node3D = build_spawn.get_child(0)
			
			if buildable != null and buildable.canPlace() and build_ray_cast.is_colliding():
				building = false
				buildable.beingPlaced = false
				buildable.SafeBox.hide()
				var pos = buildable.global_position
				var rot = buildable.global_rotation
				build_spawn.remove_child(buildable)
				
				# Get root node
				var p_node = build_ray_cast.get_collider()
				while(p_node and (not p_node is Buildable )):
					p_node = p_node.get_parent()
				
				if p_node == null:
					p_node = $"../Map/Floor"
				print(p_node)
				p_node.add_child(buildable)
				buildable.global_position = pos
				buildable.global_rotation = rot
				selectedBuildable = null
				return
		else:
			if highlightedBuildable != null:
				selectedBuildable = highlightedBuildable
				selectedBuildable.beingPlaced = true
				selectedBuildable.SafeBox.show()
				selectedBuildable.position = Vector3(0,0,0)
				var rot = selectedBuildable.global_rotation
				selectedBuildable.get_parent_node_3d().remove_child(selectedBuildable)
				build_spawn.add_child(selectedBuildable)
				selectedBuildable.global_rotation = rot
				building = true
				return
	
	# Rotate Selected/Building item
	if Input.is_action_just_pressed("Rotate_Selected_Left"):
		if build_spawn.get_child_count() > 0:
			build_spawn.get_child(0).rotate_y(.1)
	if Input.is_action_just_pressed("Rotate_Selected_Right"):
		if build_spawn.get_child_count() > 0:
			build_spawn.get_child(0).rotate_y(-.1)
	# Chop on mouse click
	if Input.is_action_just_pressed("Chop") and building == false and selectedBuildable == null:
		if selectedBuildable == null:
			if animationPlayer.current_animation != "chop":
				animationPlayer.play("chop")
				locked = true


