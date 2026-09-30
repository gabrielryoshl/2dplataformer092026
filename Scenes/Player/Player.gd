extends CharacterBody2D


@onready var visuals: Node2D = %Visuals


func _physics_process(delta: float) -> void:
	if is_zero_approx(velocity.x):
		return
	
	visuals.scale = Vector2(sign(velocity.x), 1)
