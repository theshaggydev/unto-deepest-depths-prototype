class_name UnitDefinition
extends Resource

enum Type {
	Knight,
	Archer,
	Mage,
	Rogue,
	Peasant
}

@export var name: String
@export var type: Type
@export var frames: SpriteFrames
@export var type_components: Array[PackedScene] = []
@export var move_definitions: Array[ActionDefinition]
@export var ability_definitions: Array[ActionDefinition]
