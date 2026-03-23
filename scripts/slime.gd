extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var ultima_posicion_x: float
var hp := 3
var is_dead := false

func _ready() -> void:
	ultima_posicion_x = global_position.x

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	var vagon = get_parent()
	if vagon is PathFollow2D:
		if vagon.progress_ratio >= 0.99:
			Global.vidas -= 1
			print("Te pegaron. Vidas restantes: ", Global.vidas)
			vagon.queue_free()
			return
		
	var diferencia_x = global_position.x - ultima_posicion_x
	
	if diferencia_x > 0.1:
		animated_sprite_2d.flip_h = false
	elif diferencia_x < -0.1:
		animated_sprite_2d.flip_h = true
		
	animated_sprite_2d.play("Walk")
	ultima_posicion_x = global_position.x

func take_damage(daño: int) -> void:
	if is_dead:
		return
		
	hp -= daño
	animated_sprite_2d.play("Hurt")
	
	if hp <= 0:
		die()

func die() -> void:
	is_dead = true
	animated_sprite_2d.play("Death")
	
	Global.oro += 10
	print("Mataste a uno. Oro actual: ", Global.oro)
	
	get_parent().set_process(false) 
	
	await get_tree().create_timer(0.6).timeout
	
	get_parent().queue_free()
