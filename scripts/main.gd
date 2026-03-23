extends Node2D

var enemigo_escena = preload("res://Scenes/enemigo_ruta.tscn")
var torre_escena = preload("res://Scenes//tower_1.tscn")
@onready var ruta_enemigos: Path2D = $Path2D

var construyendo := false
var torre_fantasma: Node2D = null
var costo_torre := 20

func _on_timer_timeout() -> void:
	var nuevo_slime = enemigo_escena.instantiate()
	ruta_enemigos.add_child(nuevo_slime)

func _on_button_pressed() -> void:
	if not construyendo and Global.oro >= costo_torre:
		construyendo = true
		crear_fantasma()
	elif Global.oro < costo_torre:
		# Mandamos llamar al CanvasLayer para mostrar la alerta
		$CanvasLayer.mostrar_mensaje("¡U are poor nigga!")

func crear_fantasma() -> void:
	torre_fantasma = torre_escena.instantiate()
	torre_fantasma.modulate = Color(1, 1, 1, 0.5) 
	torre_fantasma.set_process(false)
	torre_fantasma.set_physics_process(false)
	add_child(torre_fantasma)

func _physics_process(delta: float) -> void:
	if construyendo and torre_fantasma != null:
		var mouse_pos = get_global_mouse_position()
		torre_fantasma.global_position = mouse_pos
		
		var state = get_world_2d().direct_space_state
		var forma_base = CircleShape2D.new()
		forma_base.radius = 15.0 
		
		var query = PhysicsShapeQueryParameters2D.new()
		query.shape = forma_base
		query.transform = Transform2D(0, mouse_pos)
		query.collision_mask = 2 
		query.collide_with_areas = true
		
		var result = state.intersect_shape(query)
		
		if result.size() > 0:
			torre_fantasma.modulate = Color(1, 0, 0, 0.5) 
		else:
			torre_fantasma.modulate = Color(1, 1, 1, 0.5) 

func _unhandled_input(event: InputEvent) -> void:
	if construyendo and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			var state = get_world_2d().direct_space_state
			
			var forma_base = CircleShape2D.new()
			forma_base.radius = 15.0
			var query = PhysicsShapeQueryParameters2D.new()
			query.shape = forma_base
			query.transform = Transform2D(0, mouse_pos)
			query.collision_mask = 2 
			query.collide_with_areas = true
			
			var result = state.intersect_shape(query)
			
			if result.size() == 0:
				Global.oro -= costo_torre
				var nueva_torre = torre_escena.instantiate()
				nueva_torre.global_position = mouse_pos
				add_child(nueva_torre)
				desactivar_construccion()
			else:
				# Alerta visual en lugar de print
				$CanvasLayer.mostrar_mensaje("¡Gdyum dumb ashit!")

func _input(event: InputEvent) -> void:
	if construyendo and event.is_action_pressed("ui_cancel"):
		desactivar_construccion()

func desactivar_construccion() -> void:
	construyendo = false
	if torre_fantasma != null:
		torre_fantasma.queue_free()
		torre_fantasma = null
