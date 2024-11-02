extends Node2D

var screen_size
var tbp_button
var title
var guibg
var tbp_scene
var tbp_instantiated_scene
var tbp_instantiated_state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	tbp_button = $MainGUI/TBPButton
	title = $MainGUI/Title
	guibg = $MainGUI/GUIBackground
	tbp_scene = preload("res://three_body_problem_container.tscn")
	
func _process(_delta: float) -> void:
	input_process()

func _on_tbp_button_pressed() -> void:
	tbp_instantiated_scene = tbp_scene.instantiate()
	tbp_instantiated_state = true
	$MainGUI.hide()
	add_child(tbp_instantiated_scene)
	
func input_process():
	if Input.is_action_just_pressed("exit_simulation") && tbp_instantiated_state && tbp_instantiated_scene:
		remove_child(tbp_instantiated_scene)
		$MainGUI.show()
		tbp_instantiated_scene = null
		tbp_instantiated_state = false
	
