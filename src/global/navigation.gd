extends Node

const TILE_SIZE: int = 16

var grid: AStarGrid2D
var unit_lookup: Callable

func init_level(tilemap: TileMap, unit_lookup_callable: Callable) -> void:
	unit_lookup = unit_lookup_callable
	
	grid = AStarGrid2D.new()
	grid.cell_size = Vector2i.ONE * TILE_SIZE
	grid.region = tilemap.get_used_rect()
	grid.update()
	
	for cell in tilemap.get_used_cells(0):
		if tilemap.get_cell_tile_data(0, cell).get_custom_data('is_solid'):
			grid.set_point_solid(cell, true)

func snap_to_tile(pos: Vector2, include_half_offset: bool = false) -> Vector2:
	var snapped = floor(pos / float(TILE_SIZE)) * TILE_SIZE
	
	if include_half_offset:
		snapped += Vector2.ONE * TILE_SIZE * 0.5
	
	return snapped

func world_to_cell(pos: Vector2) -> Vector2:
	return snap_to_tile(pos) / TILE_SIZE

func cell_to_world(pos: Vector2, include_half_offset: bool = false) -> Vector2:
	return snap_to_tile(pos * TILE_SIZE, include_half_offset)

func get_ac_block_point(ac: ActionInstance) -> Vector2:
	var units: Array[Unit] = unit_lookup.call()
	units = units.filter(
		func (unit):
			return unit != ac.unit
	)
	var unit_cells = units.map(
		func (unit):
			return unit.cell
	)
	
	for i in range(ac.full_path.size()):
		var cell = ac.full_path[i]
		if !grid.region.has_point(cell) or grid.is_point_solid(Vector2i(cell)):
			return cell
		for ucell in unit_cells:
			if cell.distance_to(ucell) < 0.1:
				return cell
		
	return Vector2(INF, INF)
