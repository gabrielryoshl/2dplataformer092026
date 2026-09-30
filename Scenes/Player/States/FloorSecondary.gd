extends State


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent


func on_physics_process(_delta: float) -> void:
	player.move_and_slide()
