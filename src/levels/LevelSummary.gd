extends Control

func _ready():
	$ContinueButton.connect("pressed", self, "_on_continue_pressed")

func _on_continue_pressed():
	get_parent().return_to_main_screen()
