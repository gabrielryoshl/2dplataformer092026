extends State


const MOVE_SPEED: float = 200
const ACCELERATION: float = 5


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var floor_primary_cooldown: Timer = %FloorPrimaryCooldown


func on_exit() -> void:
	coyote_timer.stop()


func on_process(_delta: float) -> void:
	if not coyote_timer.is_stopped():
		if input_component.just_jumped:
			change_state("Jumping")
			return
		
		if floor_primary_cooldown.is_stopped() and input_component.just_pressed_primary:
			change_state("FloorPrimary")
			return
		
		if input_component.just_pressed_secondary:
			change_state("FloorSecondary")
			return
	
	if player.is_on_floor():
		change_state("Idle" if is_zero_approx(Input.get_axis("move_left", "move_right")) else "Walking")


func on_physics_process(delta: float) -> void:
	var desired_velocity := Input.get_axis("move_left", "move_right") * MOVE_SPEED
	var velocity_diff := desired_velocity - player.velocity.x
	
	player.velocity.x += velocity_diff * ACCELERATION * delta
	player.velocity.y += 1200 * delta
	player.move_and_slide()
