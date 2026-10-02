extends State


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var floor_secondary_cooldown: Timer = %FloorSecondaryCooldown


func on_enter() -> void:
	var action_direction: int = sign(input_component.last_valid_input_direction)
	var height_boost: float = 2
	if sign(player.velocity.x) != action_direction:
		player.velocity.x = 0
	else:
		player.velocity.x *= 0.25
		height_boost += abs(player.velocity.x) / 100
	
	player.velocity += Vector2(action_direction, -height_boost) * 250
	
	animation_player.play("FloorSecondary")
	
	await animation_player.animation_finished
	
	floor_secondary_cooldown.start()
	change_state("Falling")


func on_physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += 2000 * delta
	
	player.move_and_slide()
