extends Node2D

var enemigo_escena = preload("res://Scenes/enemigo_ruta.tscn")
@onready var ruta_enemigos: Path2D = $Path2D

func _on_timer_timeout() -> void:
	var nuevo_slime = enemigo_escena.instantiate()
	ruta_enemigos.add_child(nuevo_slime)
