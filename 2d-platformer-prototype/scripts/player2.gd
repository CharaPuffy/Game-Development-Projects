extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true
var can_move = true

func _physics_process(delta: float) -> void:
	if !alive:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if can_move:
		# Handle jump — Up arrow or Numpad 0
		if Input.is_action_just_pressed("p2_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Animation logic
		if not is_on_floor():
			animated_sprite_2d.animation = "jumping"
		elif velocity.x != 0:
			animated_sprite_2d.animation = "running"
		else:
			animated_sprite_2d.animation = "idle"

		# Movement — Left/Right arrow keys
		var direction := Input.get_axis("p2_left", "p2_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

		if direction == 1.0:
			animated_sprite_2d.flip_h = false
		elif direction == -1.0:
			animated_sprite_2d.flip_h = true

func die() -> void:
	if alive: death_sound.play()
	animated_sprite_2d.animation = "dying"
	alive = false
