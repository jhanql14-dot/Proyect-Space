extends CharacterBody2D

# --- CONFIGURACIÓN DE VELOCIDADES ---
const WALK_SPEED = 200.0
const SLIDE_SPEED = 500.0

# --- CONFIGURACIÓN DE TIEMPOS ---
const SLIDE_DURATION = 0.2    # El slide dura 0.2 segundos
const SLIDE_COOLDOWN = 1.0    # Esperar 1 segundo para volver a usar

# --- VARIABLES DE ESTADO ---
var current_speed = WALK_SPEED
var is_sliding = false
var can_slide = true
var slide_direction = Vector2.RIGHT # Por defecto mira a la derecha

# --- REFERENCIAS ---
@onready var sprite = $AnimatedSprite2D # Cambia por $Sprite2D si usas uno simple

func _physics_process(delta: float) -> void:
	# 1. OBTENER DIRECCIÓN DE MOVIMIENTO (WASD)
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input_direction = input_direction.normalized()

	# 2. LÓGICA DEL SLIDE (DESLIZAMIENTO)
	if Input.is_action_just_pressed("ui_accept") and can_slide and not is_sliding:
		# Si se mueve, desliza en esa dirección. Si está quieto, desliza hacia la derecha.
		if input_direction != Vector2.ZERO:
			slide_direction = input_direction
		else:
			slide_direction = Vector2.RIGHT 
			
		start_slide()

	# 3. MOVER AL PERSONAJE
	if is_sliding:
		# Durante el slide, se mueve automáticamente en la dirección guardada
		velocity = slide_direction * SLIDE_SPEED
	else:
		# Movimiento normal caminando
		velocity = input_direction * WALK_SPEED

	move_and_slide()
	
	# 4. CONTROL DE ANIMACIONES
	actualizar_animaciones(input_direction)

# --- FUNCIONES AUXILIARES ---

func start_slide() -> void:
	is_sliding = true
	can_slide = false
	
	# Temporizador para terminar el slide (0.2s)
	await get_tree().create_timer(SLIDE_DURATION).timeout
	is_sliding = false
	
	# Temporizador para la recarga del slide (1.0s)
	await get_tree().create_timer(SLIDE_COOLDOWN).timeout
	can_slide = true

func actualizar_animaciones(input_direction: Vector2) -> void:
	if is_sliding:
		sprite.play("Slime_Slide")
	elif input_direction != Vector2.ZERO:
		sprite.play("Slime_Walk")
	else:
		sprite.play("Slime_Idle")
