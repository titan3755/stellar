extends Node2D

@export var UNIVERSAL_GRAVITATIONAL_CONSTANT: float = 6.6743 * pow(10, -1)
@export var gui_state: bool = false
var shown:bool = false

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	screen_size = get_viewport_rect().size
	$TBPGui.hide()
	$CobjOne.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$CobjTwo.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$CobjThree.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !gui_state:
		input_process(delta)
	if gui_state && !shown:
		$TBPGui.show()
		shown = true
	if !gui_state && shown:
		$TBPGui.hide()
		shown = false
	$CobjOne.effective_force = resultant_vector_force($CobjOne.mass, $CobjTwo.mass, $CobjThree.mass, $CobjOne.position, $CobjTwo.position, $CobjThree.position, 0, UNIVERSAL_GRAVITATIONAL_CONSTANT)
	$CobjTwo.effective_force = resultant_vector_force($CobjOne.mass, $CobjTwo.mass, $CobjThree.mass, $CobjOne.position, $CobjTwo.position, $CobjThree.position, 1, UNIVERSAL_GRAVITATIONAL_CONSTANT)
	$CobjThree.effective_force = resultant_vector_force($CobjOne.mass, $CobjTwo.mass, $CobjThree.mass, $CobjOne.position, $CobjTwo.position, $CobjThree.position, 2, UNIVERSAL_GRAVITATIONAL_CONSTANT)

func distance(coord_one: Vector2, coord_two: Vector2) -> float:
	return sqrt(pow(coord_two.x - coord_one.x, 2) + pow(coord_two.y - coord_one.y, 2))
	
func resultant_vector_force(mass_one: float, mass_two:float, mass_three: float, pos_one: Vector2, pos_two: Vector2, pos_three: Vector2, wrt_indx: int, grav_const: float) -> Vector2:
	if wrt_indx == 0:
		var force_wrt_two: Vector2 = ((grav_const * mass_one * mass_two) / pow(distance(pos_one, pos_two), 2)) * ((pos_two - pos_one) / sqrt(pow((pos_two - pos_one).x, 2) + pow((pos_two - pos_one).y, 2)))
		var force_wrt_three: Vector2 = ((grav_const * mass_one * mass_three) / pow(distance(pos_one, pos_three), 2)) * ((pos_three - pos_one) / sqrt(pow((pos_three - pos_one).x, 2) + pow((pos_three - pos_one).y, 2)))
		var resultant_wrt_twonthree: Vector2 = force_wrt_two + force_wrt_three
		return resultant_wrt_twonthree
	elif wrt_indx == 1:
		var force_wrt_one: Vector2 = ((grav_const * mass_two * mass_one) / pow(distance(pos_two, pos_one), 2)) * ((pos_one - pos_two) / sqrt(pow((pos_one - pos_two).x, 2) + pow((pos_one - pos_two).y, 2)))
		var force_wrt_three: Vector2 = ((grav_const * mass_two * mass_three) / pow(distance(pos_two, pos_three), 2)) * ((pos_three - pos_two) / sqrt(pow((pos_three - pos_two).x, 2) + pow((pos_three - pos_two).y, 2)))
		var resultant_wrt_onenthree: Vector2 = force_wrt_one + force_wrt_three
		return resultant_wrt_onenthree
	elif wrt_indx == 2:
		var force_wrt_one: Vector2 = ((grav_const * mass_three * mass_one) / pow(distance(pos_three, pos_one), 2)) * ((pos_one - pos_three) / sqrt(pow((pos_one - pos_three).x, 2) + pow((pos_one - pos_three).y, 2)))
		var force_wrt_two: Vector2 = ((grav_const * mass_three * mass_two) / pow(distance(pos_three, pos_two), 2)) * ((pos_two - pos_three) / sqrt(pow((pos_two - pos_three).x, 2) + pow((pos_two - pos_three).y, 2)))
		var resultant_wrt_onentwo: Vector2 = force_wrt_one + force_wrt_two
		return resultant_wrt_onentwo
	else:
		return Vector2(0, 0)
		
func input_process(_del: float):
	if Input.is_action_just_pressed("reset_viewport"):
		$Camera2D.position = Vector2.ZERO
		$Camera2D.zoom = Vector2.ONE
		$CobjOne.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		$CobjTwo.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		$CobjThree.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		$CobjOne.velocity = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		$CobjTwo.velocity = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		$CobjThree.velocity = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		$CobjOne.acceleration = Vector2.ONE
		$CobjTwo.acceleration = Vector2.ONE
		$CobjThree.acceleration = Vector2.ONE

func paramEditorDataProcessor(data: String):
	var keyValuePair = data.trim_prefix(" ").trim_suffix(" ").split("=", false, 1)
	var key = keyValuePair[0]
	var value = keyValuePair[1]
	var twoValVector: Vector2
	var threeValVector: Vector3
	var pathToProperty = key.split("-", false, 0)
	var celObjStore
	
	if !value.is_valid_float() && (pathToProperty[0] == "CelestialObjOne" || pathToProperty[0] == "CelestialObjTwo" || pathToProperty[0] == "CelestialObjThree") && (pathToProperty[1] == "position" || pathToProperty[1] == "velocity" || pathToProperty[1] == "acceleration") && (pathToProperty[1] != "color"):
		var strSplt = value.split(",")
		if strSplt.size() != 2:
			return
		if !strSplt[0].is_valid_float() || !strSplt[1].is_valid_float():
			return
		twoValVector = Vector2(strSplt[0].to_float(), strSplt[1].to_float())
	
	if !value.is_valid_int() && (pathToProperty[0] == "CelestialObjOne" || pathToProperty[0] == "CelestialObjTwo" || pathToProperty[0] == "CelestialObjThree") && (pathToProperty[1] == "color"):
		var strSplt = value.split(",")
		if strSplt.size() != 3:
			return
		if !strSplt[0].is_valid_int() || !strSplt[1].is_valid_int() || !strSplt[2].is_valid_int():
			return
		if strSplt[0].to_int() > 255 || strSplt[0].to_int() < 0 || strSplt[1].to_int() > 255 || strSplt[1].to_int() < 0 || strSplt[2].to_int() > 255 || strSplt[2].to_int() < 0:
			return
		threeValVector = Vector3(strSplt[0].to_int(), strSplt[1].to_int(), strSplt[2].to_int())
	
	if !value.is_valid_float() && (pathToProperty[0] == "CelestialObjOne" || pathToProperty[0] == "CelestialObjTwo" || pathToProperty[0] == "CelestialObjThree") && (pathToProperty[1] == "mass" || pathToProperty[1] == "radius" || pathToProperty[1] == "vdamp" || pathToProperty[1] == "vclamp" || pathToProperty[1] == "aclamp"):
		return
		
	#if camera ... (to do)
		
	if !value.is_valid_float() && (pathToProperty[0] == "Main") && (pathToProperty[1] == "UniGravConst"):
		return

	if pathToProperty[0] != "CelestialObjOne" && pathToProperty[0] != "CelestialObjTwo" && pathToProperty[0] != "CelestialObjThree" && pathToProperty[0] != "Camera" && pathToProperty[0] != "Main":
		return
		
	if pathToProperty[0]:
		if pathToProperty[0] == "CelestialObjOne" || pathToProperty[0] == "CelestialObjTwo" || pathToProperty[0] == "CelestialObjThree":
			if pathToProperty[0] == "CelestialObjOne":
				celObjStore = $CobjOne
			elif pathToProperty[0] == "CelestialObjTwo":
				celObjStore = $CobjTwo
			else:
				celObjStore = $CobjThree
			if pathToProperty[1]:
				if pathToProperty[1] == "mass":
					celObjStore.mass = value.to_float()
				elif pathToProperty[1] == "radius":
					celObjStore.radius = value.to_float()
				elif pathToProperty[1] == "color":
					celObjStore.color == Color8(threeValVector.x, threeValVector.y, threeValVector.z, 255)
				elif pathToProperty[1] == "position":
					celObjStore.position = twoValVector
				elif pathToProperty[1] == "velocity":
					celObjStore.velocity = twoValVector
				elif pathToProperty[1] == "acceleration":
					celObjStore.acceleration = twoValVector
				elif pathToProperty[1] == "vclamp":
					celObjStore.velocity_clamp = value.to_float()
				elif pathToProperty[1] == "vdamp":
					celObjStore.velocity_damping = value.to_float()
				elif pathToProperty[1] == "aclamp":
					celObjStore.acceleration_clamp = value.to_float()
					
		#if camera ... (to do)
				
		if pathToProperty[0] == "Main":
			if pathToProperty[1]:
				if pathToProperty[1] == "UniGravConst":
					UNIVERSAL_GRAVITATIONAL_CONSTANT = value.to_float()
			

func _on_tbp_gui_control_lock(state: bool) -> void:
	gui_state = state

func _on_tbp_gui_params_editor_data(data: String) -> void:
	paramEditorDataProcessor(data)
	
func _on_button_pressed() -> void:
	$Camera2D.position = Vector2.ZERO
	$Camera2D.zoom = Vector2.ONE
	$CobjOne.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$CobjTwo.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$CobjThree.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$CobjOne.velocity = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	$CobjTwo.velocity = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	$CobjThree.velocity = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	$CobjOne.acceleration = Vector2.ONE
	$CobjTwo.acceleration = Vector2.ONE
	$CobjThree.acceleration = Vector2.ONE
	UNIVERSAL_GRAVITATIONAL_CONSTANT = 6.6743 * pow(10, -1)
	
## Modifiable data -->>
## 1. CobjOne -->>
## [mass][radius][color][position][velocity][acceleration][clamping/limits]
## 2. CobjTwo -->>
## [mass][radius][color][position][velocity][acceleration][clamping/limits]
## 3. CobjThree -->>
## [mass][radius][color][position][velocity][acceleration][clamping/limits]
## 4. Camera2D -->>
## [position][zoom/limits][zoom/scale][cam_velocity][zoom_velocity]
## 5. Main -->>
## [UNIVERSAL_GRAVITATIONAL_CONSTANT]
