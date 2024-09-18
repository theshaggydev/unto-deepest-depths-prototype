class_name UnitTypeComponent
extends Node

var unit: Unit:
	set(value):
		if unit:
			unit.attack_beginning.disconnect(_on_attack_beginning)
		unit = value
		unit.attack_beginning.connect(_on_attack_beginning)

func _on_attack_beginning(ac: ActionInstance) -> void:
	pass
