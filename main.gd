extends Node2D

var screen_size
var tbp_button
var title
var guibg
var tbp_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	tbp_button = $MainGUI/TBPButton
	title = $MainGUI/Title
	guibg = $MainGUI/GUIBackground
	tbp_scene = preload("res://three_body_problem_container.tscn")
	
func _process(delta: float) -> void:
	pass

func _on_tbp_button_pressed() -> void:
	$MainGUI.hide()
	add_child(tbp_scene.instantiate())
	
