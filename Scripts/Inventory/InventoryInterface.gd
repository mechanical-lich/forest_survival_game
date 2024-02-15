extends Control

@onready var player:Player = $"../../Player"
@onready var player_inventory:InventoryUI = $PlayerInventory

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		player_inventory.populate_item_grid(player.Inventory.slot_data)
