extends CanvasLayer

@onready var inventory_interface:Control = $InventoryInterface
@onready var player = $"../Player"
@onready var crafting = $Crafting

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		inventory_interface.visible = !inventory_interface.visible
		player.ui_opened = inventory_interface.visible

	if Input.is_action_just_pressed("Crafting"):
		if crafting.visible:
			crafting.close()
		else:
			crafting.open()
