extends UnitTypeComponent

const tile_flame = preload('res://src/unit/art/mage/tile_flame_spriteframes.tres')
const DELAY: float = 0.3
const OFFSET = Vector2(0, -8)

@onready var timer: Timer = $timer

var sprites: Array[AnimatedSprite2D] = []

func _on_attack_beginning(ac: ActionInstance) -> void:
	for child in sprites:
		child.queue_free()
	
	sprites.clear()
	
	for cell in ac.path:
		var sprite = AnimatedSprite2D.new()
		sprite.sprite_frames = tile_flame
		sprite.z_index += 1
		add_child(sprite)
		sprite.global_position = Navigation.cell_to_world(cell, true) + OFFSET
		sprites.append(sprite)
		sprite.visible = false
	
	sprites.shuffle()
	
	timer.start(DELAY)
	await timer.timeout
	
	for child in sprites:
		child.visible = true
		child.play('default')
		await get_tree().process_frame
