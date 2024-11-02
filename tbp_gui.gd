extends CanvasLayer

signal control_lock(state: bool);
signal paramsEditorData(data: String)
@export var control_lock_state: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	input_process()
		
func input_process():
	if Input.is_action_just_pressed("show_gui"):
		control_lock_state = !control_lock_state
		control_lock.emit(control_lock_state)
		
func _on_input_text_submitted(new_text: String) -> void:
	paramsEditorData.emit(new_text)
