extends Node2D
class_name SalaBase

func _ready():
	if GameManager.salas[GameManager.sala_atual]["combate_concluido"]:
		# Sala já foi limpa antes (voltou por pop), vai direto pro mapa
		GameManager.abrir_mapa()
	else:
		iniciar_combate()

func iniciar_combate():
	var combate = preload("res://scenes/combat/gerenciador_combate.tscn").instantiate()
	get_tree().root.add_child(combate)
