class_name UnitsContainer
extends Node2D

var groups: Array = []

var current_group: Node
var current_group_index: int = 0
var current_unit_index: int = 0
var current_unit: Unit
var has_moved: bool = false
var has_attacked: bool = false
var current_acs: Array

func _ready() -> void:
	for child in get_children():
		if child.get_child_count() > 0:
			groups.append(child)

func start_battle() -> void:
	current_group = groups[0]
	_begin_turn()

func get_active_units() -> Array[Unit]:
	var units: Array[Unit] = []
	
	for group in groups:
		for child in group.get_children():
			if child.health > 0:
				units.append(child)
	
	return units

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var cell = Navigation.world_to_cell(get_global_mouse_position())
		var match_ac = null
		for ac in current_acs:
			if cell == ac.end_point:
				match_ac = ac
				break
		if !has_moved:
			EventBus.show_move_path.emit(match_ac)
			
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var cell = Navigation.world_to_cell(get_global_mouse_position())
		
		for ac in current_acs:
			if cell == ac.end_point:
				if has_moved:
					has_attacked = true
					await _process_attack(ac)
				else:
					current_unit.move_along_path(ac.path + [ac.end_point])
					await current_unit.movement_complete
					has_moved = true
				update_status()
				return

func _process_attack(ac: ActionInstance):
	current_unit.attack(ac)
	await current_unit.attack_complete
	for cell in ac.path:
		var children = []
		for group in groups:
			children.append_array(group.get_children())
		for child in children:
			if child.cell == cell:
				if child != current_unit:
					child.health -= 1

func update_status() -> void:
	if has_attacked and has_moved:
		_step_turn()
	else:
		_update_paths()

func _step_turn() -> void:
	var prev_group_index = current_group_index
	var prev_index = current_unit_index
	
	var next_unit: Unit
	
	while true:
		current_unit_index += 1
		if current_unit_index >= current_group.get_child_count():
			current_group_index = wrapi(current_group_index + 1, 0, groups.size())
			current_group = groups[current_group_index]
			current_unit_index = 0
		print(current_unit_index)
		if prev_group_index == current_group_index and prev_index == current_unit_index:
			next_unit = null
			break
		
		if current_group.get_child(current_unit_index).is_active:
			next_unit = current_group.get_child(current_unit_index)
			break
	
	if next_unit != null:
		_begin_turn()
	else:
		print('no unit!')

func _begin_turn() -> void:
	current_unit = current_group.get_child(current_unit_index)
	has_attacked = false
	has_moved = false
	_update_paths()

func _update_paths() -> void:
	EventBus.show_move_path.emit(null)
	if has_moved:
		current_acs = current_unit.get_attack_paths()
		EventBus.show_attack_acs.emit(current_acs)
		EventBus.show_move_acs.emit([])
		return
	
	current_acs = current_unit.get_move_paths()
	EventBus.show_move_acs.emit(current_acs)
	EventBus.show_attack_acs.emit([])
