extends CharacterBody2D

@export var move_speed = 200.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var current_anim: String = "idle"

signal falling
signal jumping
signal idle
signal walking

func _start() -> void:
	velocity = Vector2.ZERO

func _physics_process(delta):
	process_movement(delta)

func process_movement(delta: float) -> void:
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	print(velocity)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	if !$AnimationPlayer.current_animation == current_anim:
		$AnimationPlayer.play(current_anim)
	move_and_slide()

func get_gravity() -> float:
	if velocity.y < 0.0:
		return jump_gravity
	return fall_gravity

func jump():
	velocity.y = jump_velocity
	emit_signal("jumping")

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
		$Sprite2D.scale.y = -1
	if Input.is_action_pressed("right"):
		horizontal += 1.0
		$Sprite2D.scale.y = 1
	
	if horizontal == 0.0:
		emit_signal("idle")
	else:
		emit_signal("walking")
	return horizontal
