extends PanelContainer

@export var player: Player

var Bonfire:PackedScene = load("res://Scenes/bonfire.tscn")
var Tent:PackedScene = load("res://Scenes/tent.tscn")
var Plant1:PackedScene = load("res://Scenes/plant1.tscn")
var Plant2:PackedScene = load("res://Scenes/plant2.tscn")
var Lantern:PackedScene = load("res://Scenes/lantern.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open():
	visible = true
	player.ui_opened = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func close():
	visible = false
	player.ui_opened = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_pressed():
	pass # Replace with function body.


func _on_bonfire_button_pressed():
	var bonfire = Bonfire.instantiate()
	bonfire.beingPlaced = true
	player.build_spawn.add_child(bonfire)
	player.building = true
	player.ui_opened = false
	visible = false


func _on_tent_button_pressed():
	var tent = Tent.instantiate()
	tent.beingPlaced = true
	player.build_spawn.add_child(tent)
	player.building = true
	player.ui_opened = false
	visible = false


func _on_plant_1_button_pressed():
	var plant = Plant1.instantiate()
	plant.beingPlaced = true
	player.build_spawn.add_child(plant)
	player.building = true
	close()


func _on_plant_2_button_pressed():
	var plant = Plant2.instantiate()
	plant.beingPlaced = true
	player.build_spawn.add_child(plant)
	player.building = true
	close()


func _on_lantern_button_pressed():
	var lantern = Lantern.instantiate()
	lantern.beingPlaced = true
	player.build_spawn.add_child(lantern)
	player.building = true
	close()
