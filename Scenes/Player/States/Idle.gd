extends State


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var floor_primary_cooldown: Timer = %FloorPrimaryCooldown


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
	
	if input_component.just_pressed_secondary:
		change_state("FloorSecondary")
		return
	
	if input_component.is_input_direction_valid:
		change_state("Walking")


func on_physics_process(delta: float) -> void:
	player.velocity -= player.velocity * 10 * delta
	player.move_and_slide()
