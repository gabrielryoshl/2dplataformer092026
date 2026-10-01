extends CharacterBody2D


@onready var visuals: Node2D = %Visuals
@onready var hand_sprite: Sprite2D = %HandSprite
@onready var hand_marker_2d: Marker2D = %HandMarker2D


func _ready() -> void:
	_update_fishing_rod(0.05)


func _physics_process(delta: float) -> void:
	if not is_zero_approx(velocity.x):
		var direction: int = sign(velocity.x)
		
		visuals.scale = Vector2(direction, 1)
		hand_sprite.scale = visuals.scale
	
	_update_fishing_rod(delta)


func _update_fishing_rod(delta: float) -> void:
	hand_sprite.global_position = hand_sprite.global_position.lerp(hand_marker_2d.global_position, 50 * delta)
	hand_sprite.rotation = hand_marker_2d.rotation * hand_sprite.scale.x
