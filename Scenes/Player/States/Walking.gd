extends State


const MOVE_SPEED: float = 150
const ACCELERATION: float = 10


@onready var player: Player = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var floor_primary_cooldown: Timer = %FloorPrimaryCooldown
@onready var floor_secondary_cooldown: Timer = %FloorSecondaryCooldown
@onready var dust_particles_2d: CPUParticles2D = %DustParticles2D


func on_exit() -> void:
	player.wall_jumps = 0
	dust_particles_2d.emitting = false


func on_process(_delta: float) -> void:
	if not player.is_on_floor():
		coyote_timer.start()
		change_state("Falling")
		return
	
	if input_component.just_jumped:
		change_state("Jumping")
		return
	
	if floor_primary_cooldown.is_stopped() and input_component.just_pressed_primary:
		change_state("FloorPrimary")
		return
	
	if floor_secondary_cooldown.is_stopped() and input_component.just_pressed_secondary:
		change_state("FloorSecondary")
		return
	
	if is_zero_approx(Input.get_axis("move_left", "move_right")):
		change_state("Idle")


func on_physics_process(delta: float) -> void:
	var desired_velocity := Input.get_axis("move_left", "move_right") * MOVE_SPEED
	var velocity_diff := desired_velocity - player.velocity.x
	
	player.velocity.x += velocity_diff * ACCELERATION * delta
	player.move_and_slide()
	
	dust_particles_2d.emitting = true
