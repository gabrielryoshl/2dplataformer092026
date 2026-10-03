extends State


@onready var player: Player = $"../.."
@onready var wall_sliding_exit_timer: Timer = %WallSlidingExitTimer
@onready var input_component: InputComponent = %InputComponent
@onready var wall_sliding_particles_2d: CPUParticles2D = %WallSlidingParticles2D
@onready var wall_sliding_ray_cast: RayCast2D = %WallSlidingRayCast


var is_exiting: bool


func on_enter() -> void:
	var new_wall_normal := wall_sliding_ray_cast.get_collision_normal()
	if player.wall_sliding_normal.dot(new_wall_normal) < 0.5:
		player.wall_jumps = 0
	
	player.wall_sliding_normal = new_wall_normal
	wall_sliding_particles_2d.emitting = true


func on_exit() -> void:
	is_exiting = false
	wall_sliding_particles_2d.emitting = false


func on_process(_delta: float) -> void:
	if player.is_on_floor():
		change_state("Idle")
		return
	
	if not wall_sliding_ray_cast.is_colliding():
		change_state("Falling")
		return
	
	if input_component.just_jumped and player.wall_jumps < player.MAX_WALL_JUMPS:
		change_state("WallJumping")
		return
	
	if input_component.input_direction != 0:
		if sign(input_component.input_direction) == sign(player.wall_sliding_normal.x):
			if is_exiting:
				if wall_sliding_exit_timer.is_stopped():
					change_state("Falling")
					return
			else:
				is_exiting = true
				wall_sliding_exit_timer.start()
		return
	
	is_exiting = false
	wall_sliding_exit_timer.stop()


func on_physics_process(delta: float) -> void:
	player.velocity -= player.wall_sliding_normal * 5
	player.velocity.y += 50 * delta
	if player.velocity.y < 0:
		player.velocity.y -= player.velocity.y * delta
	else:
		player.velocity.y = min(player.velocity.y, 50)
	
	player.move_and_slide()
