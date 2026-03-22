extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 200.0
const ROLL_SPEED = 300.0
const ROLL_DURATION = 0.9
const HURT_DURATION = 0.4

var is_rolling := false
var is_hurt := false
var is_dead := false
var roll_direction := Vector2.ZERO
var hp := 3

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	movement()
	move_and_slide()

func movement() -> void:
	if is_hurt:
		velocity = Vector2.ZERO
		animations(velocity)
		return

	if is_rolling:
		velocity = roll_direction * ROLL_SPEED
	else:
		var direction := Input.get_vector("left", "right", "up", "down")
		velocity = direction * SPEED
		
		if Input.is_action_just_pressed("ui_accept") and direction != Vector2.ZERO:
			start_roll(direction)
			
	animations(velocity)

func start_roll(dir: Vector2) -> void:
	is_rolling = true
	roll_direction = dir 
	animated_sprite_2d.play("Roll")
	
	await get_tree().create_timer(ROLL_DURATION).timeout
	
	is_rolling = false

func take_damage() -> void:
	if is_hurt or is_rolling or is_dead:
		return
		
	hp -= 1
	if hp <= 0:
		die()
	else:
		is_hurt = true
		animated_sprite_2d.play("Hurt")
		await get_tree().create_timer(HURT_DURATION).timeout
		is_hurt = false

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("Death")
	
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()

func animations(dir: Vector2) -> void:
	if is_hurt or is_dead:
		return
		
	if is_rolling:
		if roll_direction.x != 0:
			animated_sprite_2d.flip_h = roll_direction.x < 0
	else:
		if dir == Vector2.ZERO:
			animated_sprite_2d.play("Idle")
		elif dir.x != 0:
			animated_sprite_2d.flip_h = dir.x < 0
			animated_sprite_2d.play("Walk")
		elif dir.y != 0:
			animated_sprite_2d.play("Walk")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		take_damage()
