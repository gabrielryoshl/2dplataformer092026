extends State


@onready var player: CharacterBody2D = $"../.."
@onready var input_component: InputComponent = %InputComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var floor_primary_cooldown: Timer = %FloorPrimaryCooldown


func on_enter() -> void:
	player.velocity.x = 200 * sign(input_component.last_valid_input_direction)
	player.velocity.y = -300
	
	animation_player.play("FloorPrimary")
	
	await animation_player.animation_finished
	
	floor_primary_cooldown.start()
	change_state("Idle")


func on_physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += 2000 * delta
	
	player.move_and_slide()
