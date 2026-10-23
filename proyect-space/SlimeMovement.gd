
extends CharacterBody2D

@export var speed: float = 200.0
@export var slide_speed: float = 500.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var sliding: bool = false
var slide_ready: bool = true
var slide_direction: Vector2 = Vector2.RIGHT

var slide_timer: float = 0.0
var cooldown_timer: float = 0.0


func _physics_process(delta: float) -> void:
	# Tiempo de espera del slide
	if not slide_ready:
		cooldown_timer -= delta

		if cooldown_timer <= 0.0:
			slide_ready = true

	# Ejecutar el slide
	if sliding:
		slide_timer -= delta
		velocity = slide_direction * slide_speed

		if slide_timer <= 0.0:
			sliding = false

		move_and_slide()
		return

	# Movimiento directo con WASD
	var direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.y += 1.0

	direction = direction.normalized()
	velocity = direction * speed

	move_and_slide()

	# Mirar hacia la izquierda o derecha
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false

	# Activar slide con Space
	if Input.is_key_pressed(KEY_SPACE) and slide_ready:
		sliding = true
		slide_ready = false
		slide_timer = 0.2
		cooldown_timer = 1.0

		if direction != Vector2.ZERO:
			slide_direction = direction
		else:
			slide_direction = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT

		anim.play("Slime_Side")
		return

	# Caminar o quedarse quieto
	if direction != Vector2.ZERO:
		if anim.current_animation != "Slime_Walk":
			anim.play("Slime_Walk")
	else:
		if anim.current_animation != "Slime_Idle":
			anim.play("Slime_Idle")
