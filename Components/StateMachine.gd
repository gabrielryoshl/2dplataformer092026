class_name StateMachine
extends Node


@export var current_state: State :
	set(new_value):
		if current_state:
			current_state.on_exit()
		
		current_state = new_value
		
		if current_state:
			current_state.on_enter()


var _states: Dictionary[StringName, State]


func _ready() -> void:
	for child in get_children():
		if child is State:
			_states.set(child.name, child)
			child.requested_state_change.connect(_on_requested_state_change)


func _process(delta: float) -> void:
	if current_state:
		current_state.on_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.on_physics_process(delta)


func _on_requested_state_change(emitter: State, new_state_name: StringName) -> void:
	if emitter != current_state or not _states.has(new_state_name):
		return
	
	current_state = _states.get(new_state_name)
