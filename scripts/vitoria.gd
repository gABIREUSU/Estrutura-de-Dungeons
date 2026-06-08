extends CanvasLayer

@onready var label_pontos = $Control/LabelPontos
@onready var label_detalhes = $Control/LabelDetalhes
@onready var botao = $Control/Button
@onready var container_fila = $CanvasLayer/ContainerFila  # HBoxContainer no topo

func _ready():
	var pontos = GameManager.calcular_pontuacao()
	var pops_usados = GameManager.MAX_POPS - GameManager.pops_restantes
	var bonus_alavanca = 200 if GameManager.usou_alavanca else 0
	var bonus_chave = 200 if GameManager.usou_chave else 0
	var bonus_vida = int((float(GameManager.jogador["hp"]) / GameManager.jogador["hp_max"]) * 150)

	label_pontos.text = "Pontuação Final: " + str(pontos)
	label_detalhes.text = (
		"Pontos base: 1000\n" +
		"Salas visitadas: " + str(GameManager.salas_visitadas) + "  (-" + str(GameManager.salas_visitadas * 20) + " pts)\n" +
		"Pops usados: " + str(pops_usados) + "  (-" + str(pops_usados * 50) + " pts)\n" +
		"Bônus alavanca: +" + str(bonus_alavanca) + " pts\n" +
		"Bônus chave: +" + str(bonus_chave) + " pts\n" +
		"Bônus vida restante: +" + str(bonus_vida) + " pts"
	)

func _on_voltar_pressed():
	GameManager.jogador["hp"] = GameManager.jogador["hp_max"]
	GameManager.jogador["defendendo"] = false
	GameManager.jogador["tem_chave"] = false
	GameManager.pilha = ["Entrada"]
	GameManager.sala_atual = "Entrada"
	GameManager.pops_restantes = GameManager.MAX_POPS
	GameManager.alavanca_ativada = false
	GameManager.chave_nas_catacumbas = false
	GameManager.mercado_inspecionado = false
	GameManager.salas_visitadas = 0
	for nome in GameManager.salas:
		GameManager.salas[nome]["combate_concluido"] = false
		GameManager.salas[nome]["desbloqueada"] = false
	GameManager.salas["Entrada"]["desbloqueada"] = true
	GameManager.salas["Entrada"]["combate_concluido"] = true
	GameManager.salas["Encruzilhada"]["desbloqueada"] = true
	queue_free()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
