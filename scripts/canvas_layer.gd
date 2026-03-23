extends CanvasLayer

# Usamos la nueva ruta a tus escenas instanciadas
@onready var contador_oro: HBoxContainer = $ContenedorInterfaz/ContadorOro
@onready var contador_vidas: HBoxContainer = $ContenedorInterfaz/ContadorVidas
@onready var label_mensajes: Label = $LabelMensajes

func _ready() -> void:
	# 1. Configurar los iconos animados al arrancar
	contador_oro.set_icono("Moneda") # Pon el nombre exacto de tu animación
	contador_vidas.set_icono("Corazon")

	# 2. Conectar las señales reactivas al Global (esto no cambia)
	Global.oro_actualizado.connect(actualizar_oro)
	Global.vidas_actualizadas.connect(actualizar_vidas)
	
	# 3. Forzar actualización inicial
	actualizar_oro(Global.oro)
	actualizar_vidas(Global.vidas)

func actualizar_oro(nuevo_valor: int) -> void:
	# Llamamos a la función que creamos en el script del CounterUI
	contador_oro.set_valor(nuevo_valor)

func actualizar_vidas(nuevo_valor: int) -> void:
	contador_vidas.set_valor(nuevo_valor)
	
func mostrar_mensaje(texto: String) -> void:
	# 1. Le ponemos el texto que nos manden
	label_mensajes.text = texto
	
	# 2. Aseguramos que sea totalmente visible (opacidad al 100%)
	label_mensajes.modulate.a = .8
	
	# 3. Creamos la animación por código (Tween)s
	var tween = create_tween()
	
	# Esperamos 1.5 segundos con el texto en pantalla
	tween.tween_interval(1.5)
	
	# Lo desvanecemos poco a poco bajando su opacidad (alpha) a 0.0 en medio segundo
	tween.tween_property(label_mensajes, "modulate:a", 0.0, 0.5)
