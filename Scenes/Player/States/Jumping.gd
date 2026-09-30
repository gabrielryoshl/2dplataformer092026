extends State

const MOVE_SPEED: float = 200
const ACCELERATION: float = 5


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var jump_cancel_timer: Timer = %JumpCancelTimer


func on_enter() -> void:
	input_component.consume_jump_buffer()
	player.velocity.y -= 300
	jump_cancel_timer.start()


func on_process(_delta: float) -> void:
	if jump_cancel_timer.is_stopped() and not input_component.is_pressing_jumping:
		player.velocity.y *= 0.5
		change_state("Falling")
		return
	
	if player.velocity.y >= 0:
		change_state("Falling")


func on_physics_process(delta: float) -> void:
	var desired_velocity := Input.get_axis("move_left", "move_right") * MOVE_SPEED
	var velocity_diff := desired_velocity - player.velocity.x
	
	player.velocity.x += velocity_diff * ACCELERATION * delta
	player.velocity.y += 800 * delta
	player.move_and_slide()
