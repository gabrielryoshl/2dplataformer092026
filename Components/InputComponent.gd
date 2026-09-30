class_name InputComponent
extends Node


const BUFFER_TIME: float = 0.075


var input_direction: float
var is_input_direction_valid: bool
var last_valid_input_direction: float

var just_jumped: bool
var is_pressing_jumping: bool

var just_pressed_primary: bool
var is_pressing_primary: bool

var just_pressed_secondary: bool
var is_pressing_secondary: bool

var _jump_buffer_timer: Timer
var _primary_action_buffer_timer: Timer


func _ready() -> void:
	process_priority = -1
	process_physics_priority = -1
	
	_jump_buffer_timer = Timer.new()
	_jump_buffer_timer.wait_time = BUFFER_TIME
	_jump_buffer_timer.one_shot = true
	
	add_child(_jump_buffer_timer)
	
	_primary_action_buffer_timer = Timer.new()
	_primary_action_buffer_timer.wait_time = BUFFER_TIME
	_primary_action_buffer_timer.one_shot = true
	
	add_child(_primary_action_buffer_timer)


func _process(_delta: float) -> void:
	if is_input_direction_valid:
		last_valid_input_direction = input_direction
	
	input_direction = Input.get_axis("move_left", "move_right")
	is_input_direction_valid = not is_zero_approx(input_direction)
	
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer.start()
	
	just_jumped = not _jump_buffer_timer.is_stopped()
	is_pressing_jumping = Input.is_action_pressed("jump")
	
	if Input.is_action_just_pressed("primary_action"):
		_primary_action_buffer_timer.start()
	
	just_pressed_primary = not _primary_action_buffer_timer.is_stopped()
	is_pressing_primary = Input.is_action_pressed("primary_action")
	
	just_pressed_secondary = Input.is_action_just_pressed("secondary_action")
	is_pressing_secondary = Input.is_action_pressed("secondary_action")


func consume_jump_buffer() -> void:
	_jump_buffer_timer.stop()
