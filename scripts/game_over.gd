extends CanvasLayer

@onready var botao = $Control/Button

func _ready():
	botao.pressed.connect(_on_voltar_pressed)

func _on_voltar_pressed():

	GameManager.jogador["hp"] = GameManager.jogador["hp_max"]
	GameManager.jogador["defendendo"] = false

	GameManager.pilha = ["Entrada"]
	GameManager.sala_atual = "Entrada"
	GameManager.pops_restantes = GameManager.MAX_POPS

	GameManager.alavanca_ativada = false
	GameManager.chave_no_mercado = false
	GameManager.mercado_inspecionado = false
	
	for nome in GameManager.salas:
		GameManager.salas[nome]["combate_concluido"] = false
		GameManager.salas[nome]["desbloqueada"] = false
	GameManager.salas["Entrada"]["desbloqueada"] = true
	GameManager.salas["Entrada"]["combate_concluido"] = true
	GameManager.salas["Encruzilhada"]["desbloqueada"] = true
	queue_free()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
