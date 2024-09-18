class_name ActionDefinition
extends Resource

enum ActionType {
	Move,
	Ability
}

enum BlockMode {
	Cancel,
	TruncateBefore,
	TruncateOn,
	Ignore,
}

@export var block_mode: BlockMode

## All values relative to the origin at (0, 0)
@export var path: Array[Vector2] = []
## All values relative to the origin at (0, 0)
@export var end_point: Vector2

var full_path: Array:
	get:
		return path + [end_point]

func to_action_instance(unit: Unit) -> ActionInstance:
	var current_cell = Navigation.world_to_cell(unit.global_position)
	var ac = ActionInstance.new(self, unit)
	ac.path = path.map(
		func (cell):
			return cell + current_cell
	)
	ac.end_point = end_point + current_cell
	return ac
