extends State


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var floor_primary_cooldown: Timer = %FloorPrimaryCooldown


func on_enter() -> void:
	var action_direction: int = sign(input_component.last_valid_input_direction)
	if sign(player.velocity.x) != action_direction:
		player.velocity.x = 0
	else:
		player.velocity.x *= 0.5
	
	player.velocity.x += 200 * action_direction
	player.velocity.y = -(300 + abs(player.velocity.x * 0.1))
	
	animation_player.play("FloorPrimary")
	
	await animation_player.animation_finished
	
	floor_primary_cooldown.start()
	change_state("Idle")


func on_physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += 2000 * delta
	
	player.move_and_slide()
