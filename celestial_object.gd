extends Area2D

@export var effective_force:Vector2 = Vector2(1, 1)
@export var acceleration:Vector2 = Vector2(1, 1)
@export var velocity:Vector2 = Vector2(1, 1)
@export var velocity_clamp:float = 30.0
@export var velocity_damping:float = 0.5
@export var acceleration_clamp:float = 10.0
@export var init_pos:Vector2
@export var mass:float
@export var radius:float
@export var color:Color

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = init_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acceleration += (effective_force / mass) * delta
	velocity += acceleration * delta
	velocity.x = clamp(velocity.x, -velocity_clamp, velocity_clamp)
	velocity.y = clamp(velocity.y, -velocity_clamp, velocity_clamp)
	acceleration.x = clamp(acceleration.x, -acceleration_clamp, acceleration_clamp)
	acceleration.y = clamp(acceleration.y, -acceleration_clamp, acceleration_clamp)
	position += velocity * delta
	damper(delta)
	queue_redraw()

func _draw() -> void:
	draw_circle(position, radius, color, true, -1.0, true)
	
func damper(del: float):
	if (velocity.x <= 0):
		velocity.x += velocity_damping * del
	if (velocity.x > 0):
		velocity.x -= velocity_damping * del
	if (velocity.y <= 0):
		velocity.y += velocity_damping * del
	if (velocity.y > 0):
		velocity.y -= velocity_damping * del
