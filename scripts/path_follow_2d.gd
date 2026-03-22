extends PathFollow2D

const SPEED = 100.0

func _process(delta: float) -> void:
	# La propiedad progress suma distancia y empuja el nodo por la línea
	progress += SPEED * delta
