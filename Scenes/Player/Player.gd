extends CharacterBody2D


@onready var visuals: Node2D = %Visuals
@onready var hand_sprite: Sprite2D = %HandSprite
@onready var hand_marker_2d: Marker2D = %HandMarker2D


func _physics_process(delta: float) -> void:
	if not is_zero_approx(velocity.x):
		var direction: int = sign(velocity.x)
		
		visuals.scale = Vector2(direction, 1)
		hand_sprite.scale = visuals.scale
	
	hand_sprite.global_position = hand_sprite.global_position.lerp(hand_marker_2d.global_position, 50 * delta)
	hand_sprite.rotation = hand_marker_2d.rotation * hand_sprite.scale.x
