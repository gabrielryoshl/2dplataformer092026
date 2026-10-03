extends State


@onready var player: Player = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var floor_secondary_cooldown: Timer = %FloorSecondaryCooldown
@onready var explosive_dust_particles_2d_2: CPUParticles2D = %ExplosiveDustParticles2D2


func on_enter() -> void:
	var action_direction: int = sign(input_component.last_valid_input_direction)
	var height_boost: float = 2
	if sign(player.velocity.x) != action_direction:
		player.velocity.x = 0
	else:
		player.velocity.x *= 0.25
		height_boost += abs(player.velocity.x) / 100
	
	player.velocity += Vector2(action_direction, -height_boost) * 225
	
	animation_player.play("FloorSecondary")
	explosive_dust_particles_2d_2.emitting = true
	
	await animation_player.animation_finished
	
	floor_secondary_cooldown.start()
	change_state("Falling")


func on_physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += 2000 * delta
	
	player.move_and_slide()
