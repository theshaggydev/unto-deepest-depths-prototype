extends Node2D

const HIGHLIGHT_STROKED = preload('res://src/maps/highlights/cell_highlight.png')
const HIGHLIGHT_STROKE_ONLY = preload('res://src/maps/highlights/cell_highlight_stroke_only.png')
const HIGHLIGHT_FILL = preload('res://src/maps/highlights/cell_highlight_no_stroke.png')

@onready var paths_fill: Node2D = $paths_fill
@onready var paths_highlights: Node2D = $paths
@onready var attacks_highlights: Node2D = $attacks
@onready var mouse_highlight: Sprite2D = $mouse_highlight

func _ready() -> void:
	EventBus.show_move_acs.connect(_on_show_move_acs)
	EventBus.show_attack_acs.connect(_on_show_attack_acs)
	EventBus.show_move_path.connect(_on_show_move_path)

func _process(delta: float) -> void:
	mouse_highlight.global_position = Navigation.snap_to_tile(get_global_mouse_position())

func _on_show_attack_acs(acs: Array) -> void:
	for child in attacks_highlights.get_children():
		child.queue_free()
	
	for ac in acs:
		for cell in ac.path:
			add_highlight(Color(1.0, 0.5, 0.0, 0.5), Navigation.cell_to_world(cell), attacks_highlights, HIGHLIGHT_FILL)
		add_highlight(Color(1.0, 0.5, 0.0, 0.5), Navigation.cell_to_world(ac.end_point), attacks_highlights, HIGHLIGHT_FILL)
		add_highlight(Color(1.0, 0.5, 0.0, 1.0), Navigation.cell_to_world(ac.end_point), attacks_highlights, HIGHLIGHT_STROKE_ONLY)
		

func _on_show_move_acs(acs: Array) -> void:
	for child in paths_highlights.get_children():
		child.queue_free()
	
	for ac in acs:
		add_highlight(Color(0.0, 0.75, 1.0, 1.0), Navigation.cell_to_world(ac.end_point), paths_highlights, HIGHLIGHT_STROKE_ONLY)

func _on_show_move_path(ac: ActionInstance) -> void:
	for child in paths_fill.get_children():
		child.queue_free()
	
	if ac:
		for cell in ac.path:
			add_highlight(Color(0.0, 0.5, 1.0, 0.5), Navigation.cell_to_world(cell), paths_fill, HIGHLIGHT_FILL)
	

func add_highlight(color: Color, pos: Vector2, parent: Node, tex: Texture) -> void:
	var s = Sprite2D.new()
	s.texture = tex
	parent.add_child(s)
	s.centered = false
	s.global_position = pos
	s.modulate = color
