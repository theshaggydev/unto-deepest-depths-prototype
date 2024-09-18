class_name ActionInstance
extends RefCounted

var definition: ActionDefinition

var path: Array = []
var end_point: Vector2

var full_path: Array:
	get:
		return path + [end_point]

var unit: Unit

func _init(def: ActionDefinition, src_unit: Unit) -> void:
	definition = def
	unit = src_unit
