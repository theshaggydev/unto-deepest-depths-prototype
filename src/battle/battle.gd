extends Node2D

@onready var tiles: TileMap = %tiles
@onready var units: UnitsContainer = %units

func _ready() -> void:
	Navigation.init_level(tiles, units.get_active_units)
	units.start_battle()
