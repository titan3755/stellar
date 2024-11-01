extends CanvasLayer

signal start_game(type)

var tbp_btn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tbp_btn = $TBPButton


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
