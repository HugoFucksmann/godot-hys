extends "res://src/Characters/Players/globalPlayer.gd"

func _ready():
	super._ready()
	# Configuraciones específicas de PlayerOne

func play_walk_animation():
	%HappyBoo.play_walk_animation()

func play_idle_animation():
	%HappyBoo.play_idle_animation()

# Sobrescribe o añade métodos específicos de PlayerOne según sea necesario
