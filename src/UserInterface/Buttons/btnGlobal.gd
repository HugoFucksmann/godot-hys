extends Button

@export var button_text: String = "Button"
@export var on_pressed_script: String = ""

func _ready():
	text = button_text
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	# Ejecuta el script asignado (puede ser una función que esté en otro script)
	if on_pressed_script != "":
		var func_ref = get_node(on_pressed_script)
		if func_ref and func_ref.has_method("execute"):
			func_ref.call("execute")
