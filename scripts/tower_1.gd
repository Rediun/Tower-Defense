extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# Suponiendo que tus nodos se llaman Hitbox y Hitbox/CollisionShape2D
@onready var hitbox_area: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D

const ATAQUE_DURATION = 0.6 # Segundos que dura todo el ataque
const HITBOX_START_TIME = 0.1 # Cuándo se activa la hitbox (frame 1 en tu anim)
const HITBOX_DURATION = 0.3 # Cuánto tiempo se queda prendida la hitbox

var is_attacking := false
var target_enemy: Node2D = null

func _physics_process(delta: float) -> void:
	if is_attacking or target_enemy == null:
		return
		
	# Si tenemos un enemigo y no estamos atacando, lo hacemos
	iniciar_ataque()

func iniciar_ataque() -> void:
	is_attacking = true
	
	# 1. Determinar dirección al enemigo para elegir animación
	var direction = global_position.direction_to(target_enemy.global_position)
	var anim_name = ""
	
	# Usamos las animaciones que creaste en image_1.png
	if abs(direction.x) > abs(direction.y):
		# Ataque Horizontal (Right o Left)
		anim_name = "Right_attack"
		# ¡TRUCO CHIDO! Si el enemigo está a la izquierda, espejeamos el sprite y la hitbox
		animated_sprite_2d.flip_h = direction.x < 0
		hitbox_area.scale.x = -1 if direction.x < 0 else 1
		# Reposicionar hitbox rectangular a la derecha (o izq por el scale)
		hitbox_shape.position = Vector2(20, 0) # Ajusta este Vector2 a ojo
	else:
		# Ataque Vertical (Up o Down)
		animated_sprite_2d.flip_h = false # Reset flip horizontal
		hitbox_area.scale.x = 1 # Reset scale horizontal
		
		if direction.y > 0:
			anim_name = "Down_attack"
			# Reposicionar hitbox abajo
			hitbox_shape.position = Vector2(0, 20) # Ajusta este Vector2
		else:
			anim_name = "Up_attack"
			# Reposicionar hitbox arriba
			hitbox_shape.position = Vector2(0, -20) # Ajusta este Vector2

	animated_sprite_2d.play(anim_name)
	
	# 2. Manejar el tiempo de la hitbox (activar/desactivar en el momento exacto)
	await get_tree().create_timer(HITBOX_START_TIME).timeout
	hitbox_shape.disabled = false # ¡ACTIVAMOS LA HITBOX!
	
	await get_tree().create_timer(HITBOX_DURATION).timeout
	hitbox_shape.disabled = true # ¡DESACTIVAMOS LA HITBOX!
	
	# 3. Esperar a que termine la animación completa
	await get_tree().create_timer(ATAQUE_DURATION - HITBOX_START_TIME - HITBOX_DURATION).timeout
	is_attacking = false
	animated_sprite_2d.play("idle_espadachin") # Pon aquí el nombre de tu anim quieto

# SEÑALES de RangoDetect
func _on_rango_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos") and target_enemy == null:
		target_enemy = body

func _on_rango_detect_body_exited(body: Node2D) -> void:
	if body == target_enemy:
		target_enemy = null

# SEÑAL de Hitbox (La que hace daño)
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos") and body.has_method("take_damage"):
		# ¡Le metemos daño al slime!
		body.take_damage(1) # Suponiendo que el slime tiene take_damage(valor)
