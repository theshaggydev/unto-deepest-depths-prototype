extends Node2D

const TWEEN_SPEED: float = 0.5
const BOX_SIZE: Vector2 = Vector2(4, 4)
const SPACING: int = 1
const Y: int = -18

@export var OUTLINE_COLOR: Color = Color('#602217')
@export var FILL_COLOR: Color = Color('#b14d2b')
@export var EMPTY_COLOR: Color = Color('#251d22')

var tween: Tween
var max_value: int
var value: int

func _draw() -> void:
	var total_width = (BOX_SIZE.x * max_value) + (SPACING * (max_value - 1))
	
	var x = -total_width / 2.0
	
	for i in max_value:
		draw_rect(
			Rect2(
				Vector2(x, Y),
				BOX_SIZE
			),
			OUTLINE_COLOR,
			true
		)
		
		var fill = FILL_COLOR
		if value <= i:
			fill = EMPTY_COLOR

		draw_rect(
			Rect2(
				Vector2(x + 1, Y + 1),
				BOX_SIZE - Vector2(2, 2)
			),
			fill,
			true
		)
		x += BOX_SIZE.x + SPACING

func init(v: int, max_v: int) -> void:
	max_value = v
	value = v
	queue_redraw()

func update_max(v: int) -> void:
	max_value = v
	queue_redraw()

func update_value(v: int) -> void:
	value = v
	queue_redraw()
	return
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		self,
		'value',
		v,
		TWEEN_SPEED
	)
