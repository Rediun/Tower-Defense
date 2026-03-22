extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var ultima_posicion_x: float
var hp := 3
var is_dead := false

func _ready() -> void:
	ultima_posicion_x = global_position.x

func _physics_process(delta: float) -> void:
	# Si ya colgó los tenis, que no haga cálculos de movimiento ni cambie animaciones
	if is_dead:
		return
		
	var diferencia_x = global_position.x - ultima_posicion_x
	
	if diferencia_x > 0.1:
		animated_sprite_2d.flip_h = false
	elif diferencia_x < -0.1:
		animated_sprite_2d.flip_h = true
		
	animated_sprite_2d.play("Walk")
	ultima_posicion_x = global_position.x

# Esta es la función que manda a llamar la espada de tu torre
func take_damage(daño: int) -> void:
	if is_dead:
		return
		
	hp -= daño
	animated_sprite_2d.play("Gethit")
	
	if hp <= 0:
		die()

func die() -> void:
	is_dead = true
	
	# Asegúrate de poner el nombre exacto y quitarle el loop a la animación
	animated_sprite_2d.play("Death") 
	
	# TRUCO CHIDO: Apagamos el motor del vagón (PathFollow2D)
	# para que el cuerpo del slime no siga avanzando por el camino mientras se muere
	get_parent().set_process(false) 
	# Esperamos a que termine la animación (ajusta el 0.6 a lo que dure la tuya)
	await get_tree().create_timer(0.6).timeout
	
	# Borramos el vagón completo de la memoria, lo que también borra al slime
	get_parent().queue_free()
