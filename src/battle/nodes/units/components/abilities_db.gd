extends Node

var unit: Unit

func _filter_acs(acs: Array) -> Array:
	var valid: Array = []
	
	for ac in acs:
		if ac.definition.block_mode == ActionDefinition.BlockMode.Ignore:
			valid.append(ac)
			continue
		
		var block = Navigation.get_ac_block_point(ac)

		if block.x == INF:
			valid.append(ac)
			continue
		
		if ac.definition.block_mode == ActionDefinition.BlockMode.TruncateBefore:
			ac.end_point = block
			var idx = ac.full_path.find(ac.end_point)
			ac.path = ac.full_path.slice(0, idx)
			valid.append(ac)
			continue
		
		if ac.definition.block_mode == ActionDefinition.BlockMode.TruncateOn:
			var idx = ac.full_path.find(block)
			ac.path = ac.full_path.slice(0, idx + 1)
			ac.end_point = ac.path[ac.path.size() - 1]
			valid.append(ac)
	
	return valid

func get_attack_paths() -> Array:
	return _filter_acs(unit.def.ability_definitions.map(func (def): return def.to_action_instance(unit) as ActionInstance))

func get_move_paths() -> Array:
	return _filter_acs(unit.def.move_definitions.map(func (def): return def.to_action_instance(unit) as ActionInstance))

