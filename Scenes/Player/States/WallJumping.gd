extends State

const MOVE_SPEED: float = 200
const ACCELERATION: float = 5


@onready var player: Player = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var jump_cancel_timer: Timer = %JumpCancelTimer
@onready var jump_dust_particles_2d: CPUParticles2D = %JumpDustParticles2D
@onready var jump_dust_particles_2d_2: CPUParticles2D = %JumpDustParticles2D2


func on_enter() -> void:
	var wall_jump_force: float = max(1 - (0.15 * player.wall_jumps), 0)
	
	input_component.consume_jump_buffer()
	player.velocity.y -= 300 * wall_jump_force
	player.velocity += player.wall_sliding_normal * 200 * wall_jump_force
	jump_cancel_timer.start()
	if not jump_dust_particles_2d.emitting:
		jump_dust_particles_2d.emitting = true
	else:
		jump_dust_particles_2d_2.emitting = true
	
	player.wall_jumps += 1


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
