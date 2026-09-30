class_name State
extends Node


signal requested_state_change(emitter: State, new_state_name: StringName)


func on_enter() -> void:
	pass


func on_exit() -> void:
	pass


func on_process(_delta: float) -> void:
	pass


func on_physics_process(_delta: float) -> void:
	pass


func change_state(new_state_name: StringName) -> void:
	requested_state_change.emit(self, new_state_name)
