extends Camera2D

@export var cam_velocity:float = 400.0
@export var cam_zoom_velocity:float = 2.5
@export var cam_gui_state:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !cam_gui_state:
		input_process(delta)
	
func input_process(del: float):
	if Input.is_action_pressed("cam_up"):
		position.y -= cam_velocity * del
	if Input.is_action_pressed("cam_down"):
		position.y += cam_velocity * del
	if Input.is_action_pressed("cam_left"):
		position.x -= cam_velocity * del
	if Input.is_action_pressed("cam_right"):
		position.x += cam_velocity * del
	if Input.is_action_pressed("cam_zoom_in"):
		zoom += Vector2(cam_zoom_velocity * del, cam_zoom_velocity * del)
	if Input.is_action_pressed("cam_zoom_out"):
		zoom -= Vector2(cam_zoom_velocity * del, cam_zoom_velocity * del)


func _on_tbp_gui_control_lock(state: bool) -> void:
	cam_gui_state = state
