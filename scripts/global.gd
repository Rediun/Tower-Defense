extends Node

signal oro_actualizado(valor)
signal vidas_actualizadas(valor)

var oro := 50:
	set(value):
		oro = value
		oro_actualizado.emit(oro)

var vidas := 10:
	set(value):
		vidas = value
		vidas_actualizadas.emit(vidas)
