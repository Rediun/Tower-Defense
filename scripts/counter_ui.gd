extends HBoxContainer

@onready var sprite: AnimatedSprite2D = $IconoWrapper/AnimatedSprite2D
@onready var label: Label = $Label

# Esta función la llamaremos desde afuera para actualizar el número
func set_valor(nuevo_valor: int) -> void:
	label.text = str(nuevo_valor)

# Esta función es para elegir qué animación reproducir
func set_icono(animacion: String) -> void:
	# Asegúrate de haber creado las animaciones en el SpriteFrames
	sprite.play(animacion)
