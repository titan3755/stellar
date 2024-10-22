extends Area2D

@export var feffx:float = 0
@export var feffy:float = 0
@export var accx:float = 0
@export var accy:float = 0
@export var velx:float
@export var vely:float
@export var init_pos_x:float
@export var init_pos_y:float
@export var mass:float
@export var radius:float
@export var color:Color

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(velx, vely) * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	draw_circle(Vector2(init_pos_x, init_pos_y), radius, color, true, -1.0, true)
