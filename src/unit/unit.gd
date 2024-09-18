class_name Unit
extends Node2D

signal movement_complete
signal attack_beginning(ac)
signal attack_complete

@export var def: UnitDefinition
@export var move_speed_per_cell: float = 0.15
@export var flash_color: Color = Color('#b76954')

@onready var abilities_db: Node = %abilities_db
@onready var sprite: AnimatedSprite2D = %sprite
@onready var health_bar: Node2D = %health_bar

var cell: Vector2:
	get:
		return Navigation.world_to_cell(global_position)

var max_health: int = 2
var health: int = 2: set = _set_health
var flash_tween: Tween

var is_active: bool:
	get:
		return health > 0

func _ready() -> void:
	global_position = Navigation.snap_to_tile(global_position, true)
	abilities_db.unit = self
	health_bar.init(health, max_health)
	
	_init_def()

func _init_def() -> void:
	sprite.sprite_frames = def.frames
	sprite.play()
	
	for component in def.type_components:
		var comp = component.instantiate() as UnitTypeComponent
		add_child(comp)
		comp.unit = self

func attack(ac: ActionInstance) -> void:
	attack_beginning.emit(ac)
	sprite.play('attack')
	
	if ac.end_point.x < cell.x:
		sprite.flip_h = true
	elif ac.end_point.x > cell.x:
		sprite.flip_h = false
	
	await sprite.animation_finished
	attack_complete.emit()
	sprite.play('idle')

func move_along_path(path: Array) -> void:
	var move_tween = create_tween()
	move_tween.set_ease(Tween.EASE_OUT)
	move_tween.set_trans(Tween.TRANS_CUBIC)
	move_tween
	for pcell in path:
		move_tween.tween_property(
			self,
			'global_position',
			Navigation.cell_to_world(pcell, true),
			move_speed_per_cell
		)
		if pcell.x < cell.x:
			sprite.flip_h = true
		elif pcell.x > cell.x:
			sprite.flip_h = false
	await move_tween.finished
	movement_complete.emit()

func get_attack_paths() -> Array:
	return abilities_db.get_attack_paths()

func get_move_paths() -> Array:
	return abilities_db.get_move_paths()

func _set_health(value: int) -> void:
	if value < health and value != 0:
		if flash_tween and flash_tween.is_valid():
			flash_tween.kill()
		
		sprite.play('hit')
		sprite.modulate = flash_color
		flash_tween = create_tween()
		flash_tween.set_ease(Tween.EASE_OUT)
		flash_tween.tween_property(
			sprite,
			'modulate',
			Color.WHITE,
			0.35
		)
		await sprite.animation_finished
		sprite.play('idle')
	health = value
	health_bar.update_value(health)
	if health == 0:
		sprite.play('death')
	
