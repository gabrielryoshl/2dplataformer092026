extends State


@onready var player: Player = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var floor_primary_cooldown: Timer = %FloorPrimaryCooldown
@onready var floor_secondary_cooldown: Timer = %FloorSecondaryCooldown
@onready var sliding_cooldown: Timer = %SlidingCooldown


func on_enter() -> void:
	if not player:
		return
	
	player.wall_jumps = 0


func on_process(_delta: float) -> void:
	if not player.is_on_floor():
		coyote_timer.start()
		change_state("Falling")
		return
	
	if input_component.just_jumped:
		change_state("Jumping")
		return
	
	if input_component.is_pressing_slide and sliding_cooldown.is_stopped():
		change_state("Sliding")
		return
	
	if input_component.just_pressed_primary and floor_primary_cooldown.is_stopped():
		change_state("FloorPrimary")
		return
	
	if input_component.just_pressed_secondary and floor_secondary_cooldown.is_stopped():
		change_state("FloorSecondary")
		return
	
	if input_component.is_input_direction_valid:
		change_state("Walking")


func on_physics_process(delta: float) -> void:
	player.velocity -= player.velocity * 10 * delta
	player.move_and_slide()
