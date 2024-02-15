extends Control

@onready var player:Player = $"../../Player"
@onready var player_inventory:InventoryUI = $PlayerInventory

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_inventory.populate_item_grid(player.Inventory.slot_data)
