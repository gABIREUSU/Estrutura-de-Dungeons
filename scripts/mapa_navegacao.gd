extends CanvasLayer

@onready var grafo = $Control/GrafoNode
@onready var botao_voltar = $Control/botao_voltar
@onready var container_acoes = $Control/ContainerAcoes

func _ready():
	botao_voltar.text = "↩ Voltar no tempo  (" + str(GameManager.pops_restantes) + " restantes)"
	if GameManager.pops_restantes <= 0 or GameManager.pilha.size() <= 1:
		botao_voltar.disabled = true
	botao_voltar.pressed.connect(_on_voltar_pressed)

	if GameManager.checar_roubo_encruzilhada():
		grafo._mostrar_popup("Um Goblin saiu das sombras e roubou sua chave!\nEle fugiu de volta para o Templo...")

	if GameManager.sala_atual == "Mercado" and GameManager.jogador["tem_chave"] and GameManager.mercado_inspecionado:
		_mostrar_botao_jogar_chave()

func _mostrar_botao_jogar_chave():
	var botao = Button.new()
	botao.name = "BotaoJogarChave"
	botao.text = "Jogar chave pelo buraco"
	botao.pressed.connect(_on_jogar_chave_pressed)
	container_acoes.add_child(botao)

func _on_jogar_chave_pressed():
	GameManager.jogar_chave_pela_abertura()
	grafo._mostrar_popup("Você jogou a chave pelo buraco!\nEla caiu nas Catacumbas do outro lado.")
	grafo.queue_redraw()
	var botao = container_acoes.get_node_or_null("BotaoJogarChave")
	if botao:
		botao.queue_free()

func _on_voltar_pressed():
	queue_free()
	GameManager.voltar()
