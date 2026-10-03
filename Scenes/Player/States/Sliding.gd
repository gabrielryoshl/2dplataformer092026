extends State

@onready var player: Player = $"../.."
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var input_component: InputComponent = %InputComponent
@onready var default_collision_shape: CollisionShape2D = %DefaultCollisionShape
@onready var sliding_collision_shape: CollisionShape2D = %SlidingCollisionShape
@onready var sliding_cooldown: Timer = %SlidingCooldown


var previous_snap_length: float


func on_enter() -> void:
	animation_player.play("Sliding")
	previous_snap_length = player.floor_snap_length
	player.floor_snap_length = 10
	
	default_collision_shape.disabled = true
	sliding_collision_shape.disabled = false
	
	player.velocity = player.get_real_velocity().slide(player.get_floor_normal())
	player.velocity.x += 50 * sign(player.velocity.x)


func on_exit() -> void:
	animation_player.play("RESET")
	player.floor_snap_length = previous_snap_length
	
	default_collision_shape.disabled = false
	sliding_collision_shape.disabled = true
	
	sliding_cooldown.start()


func on_process(_delta: float) -> void:
	if not player.is_on_floor():
		change_state("Falling")
		return
	
	if not input_component.is_pressing_slide:
		change_state("Walking" if input_component.is_input_direction_valid else "Idle")
		return
	
	if input_component.just_jumped:
		change_state("Jumping")
		return


func on_physics_process(delta: float) -> void:
	var movement_delta := player.velocity.x * 0.75 * delta
	var floor_normal_dot := player.get_floor_normal().dot(player.velocity.normalized())
	
	if floor_normal_dot > 0:
		var floor_angle := player.get_floor_angle()
		if floor_angle > deg_to_rad(15):
			movement_delta *= -(1 + floor_angle)
	elif floor_normal_dot < 0:
		player.velocity = player.get_real_velocity()
	
	player.velocity.x -= movement_delta
	player.velocity.y += 500 * delta
	player.move_and_slide()
