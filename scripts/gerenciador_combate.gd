extends Node2D

var fila_combate = []
var inimigos_vivos = []
var personagem_atual = null

@onready var canvas = $CanvasLayer
@onready var botao_defender = $CanvasLayer/BotaoDefender
@onready var container_inimigos = $CanvasLayer/ContainerInimigos
@onready var label_status = $CanvasLayer/PanelContainer2/LabelStatus
@onready var label_hp_jogador = $CanvasLayer/PanelContainer3/LabelHpJogador
@onready var container_acoes = $CanvasLayer/ContainerAcoes
@onready var container_fila = $CanvasLayer/PanelContainer/ContainerFila

func _ready():
	iniciar_combate()

func iniciar_combate():
	inimigos_vivos = GameManager.get_inimigos_sala_atual()

	var participantes = []
	for inimigo in inimigos_vivos:
		participantes.append({
			"personagem": inimigo,
			"iniciativa": randi_range(1, 20)
		})
	participantes.append({
		"personagem": GameManager.jogador,
		"iniciativa": randi_range(1, 20)
	})

	participantes.sort_custom(func(a, b): return a["iniciativa"] > b["iniciativa"])

	for p in participantes:
		fila_combate.push_back(p["personagem"])

	gerar_botoes_inimigos()
	atualizar_interface()
	atualizar_visual_fila()
	proximo_turno()

func gerar_botoes_inimigos():
	for filho in container_inimigos.get_children():
		filho.queue_free()
	for i in range(inimigos_vivos.size()):
		var inimigo = inimigos_vivos[i]
		var botao = Button.new()
		botao.text = "Atacar " + inimigo["nome"] + " (HP: " + str(inimigo["hp"]) + ")"
		botao.name = "Botao_" + str(i)
		botao.pressed.connect(_on_botao_inimigo_pressed.bind(i))
		container_inimigos.add_child(botao)

func _acertou(personagem: Dictionary) -> bool:
	return randi_range(1, 100) <= personagem["precisao"]

func proximo_turno():
	if fila_combate.is_empty():
		return
	personagem_atual = fila_combate.pop_front()
	if personagem_atual["hp"] <= 0:
		proximo_turno()
		return
	atualizar_interface()
	if personagem_atual["tipo"] == "jogador":
		personagem_atual["defendendo"] = false
		label_status.text = "Seu turno! Escolha uma ação."
		_habilitar_botoes(true)
	else:
		_habilitar_botoes(false)
		label_status.text = personagem_atual["nome"] + " está atacando..."
		await get_tree().create_timer(0.8).timeout
		if not is_instance_valid(self):
			return
		_turno_inimigo(personagem_atual)

func _turno_inimigo(inimigo: Dictionary):
	if not _acertou(inimigo):
		label_status.text = inimigo["nome"] + " errou o ataque!"
		await get_tree().create_timer(0.8).timeout
		if not is_instance_valid(self):
			return
		finalizar_turno(inimigo)
		return

	var dano = inimigo["ataque"]
	if GameManager.jogador["defendendo"]:
		dano = int(dano / 2)
		label_status.text = inimigo["nome"] + " atacou! Escudo reduziu pra " + str(dano) + " de dano."
	else:
		label_status.text = inimigo["nome"] + " atacou! " + str(dano) + " de dano."

	GameManager.jogador["hp"] -= dano
	GameManager.jogador["hp"] = max(GameManager.jogador["hp"], 0)

	await get_tree().create_timer(0.8).timeout
	if not is_instance_valid(self):
		return
	finalizar_turno(inimigo)

func finalizar_turno(personagem: Dictionary):
	if personagem["hp"] > 0:
		fila_combate.push_back(personagem)

	atualizar_interface()

	if checar_fim_do_combate():
		if GameManager.jogador["hp"] <= 0:
			_resolver_derrota()
		else:
			_resolver_vitoria()
		return

	proximo_turno()

func checar_fim_do_combate() -> bool:
	if GameManager.jogador["hp"] <= 0:
		return true
	for inimigo in inimigos_vivos:
		if inimigo["hp"] > 0:
			return false
	return true

func atualizar_interface():
	var j = GameManager.jogador
	label_hp_jogador.text = "Herói: " + str(j["hp"]) + " / " + str(j["hp_max"])
	botao_defender.text = "Defender"
	for i in range(inimigos_vivos.size()):
		var inimigo = inimigos_vivos[i]
		var botao = container_inimigos.get_node_or_null("Botao_" + str(i))
		if botao:
			if inimigo["hp"] > 0:
				botao.text = "Atacar " + inimigo["nome"] + " (HP: " + str(inimigo["hp"]) + ")"
				botao.disabled = false
			else:
				botao.text = inimigo["nome"] + " (morto)"
				botao.disabled = true
	atualizar_visual_fila()

func _habilitar_botoes(habilitar: bool):
	botao_defender.disabled = not habilitar
	for botao in container_inimigos.get_children():
		botao.disabled = not habilitar

func _on_botao_inimigo_pressed(indice: int):
	if personagem_atual == null or personagem_atual["tipo"] != "jogador":
		return
	var inimigo = inimigos_vivos[indice]
	if inimigo["hp"] <= 0:
		label_status.text = inimigo["nome"] + " já está morto!"
		return
	if not _acertou(GameManager.jogador):
		label_status.text = "Você errou o ataque!"
		_habilitar_botoes(false)
		await get_tree().create_timer(0.8).timeout
		if not is_instance_valid(self):
			return
		finalizar_turno(GameManager.jogador)
		return
	inimigo["hp"] -= GameManager.jogador["ataque"]
	inimigo["hp"] = max(inimigo["hp"], 0)
	label_status.text = "Você acertou " + inimigo["nome"] + "! " + str(GameManager.jogador["ataque"]) + " de dano."
	finalizar_turno(GameManager.jogador)

func _on_botao_defender_pressed():
	if personagem_atual == null or personagem_atual["tipo"] != "jogador":
		return
	GameManager.jogador["defendendo"] = true
	label_status.text = "Você levantou o escudo!"
	finalizar_turno(GameManager.jogador)

func _resolver_vitoria():
	label_status.text = "Vitória! Sala limpa."
	_habilitar_botoes(false)
	await get_tree().create_timer(1.2).timeout
	if not is_instance_valid(self):
		return
	GameManager.combate_concluido()

	if GameManager.sala_atual == "Boss":
		queue_free()
		GameManager.vitoria()
		return

	_mostrar_botao_inspecao()
	
func _resolver_derrota():
	label_status.text = "Você foi derrotado..."
	_habilitar_botoes(false)
	await get_tree().create_timer(1.5).timeout
	if not is_instance_valid(self):
		return
	queue_free()
	GameManager.game_over()

func _mostrar_botao_inspecao():
	# Limpa container antes de adicionar
	for filho in container_acoes.get_children():
		filho.queue_free()

	var botao_inspecionar = Button.new()
	botao_inspecionar.name = "BotaoInspecionar"
	botao_inspecionar.text = "Investigar sala"
	botao_inspecionar.pressed.connect(_on_inspecionar_pressed)
	container_acoes.add_child(botao_inspecionar)

	var botao_sair = Button.new()
	botao_sair.name = "BotaoSair"
	botao_sair.text = "Continuar →"
	botao_sair.pressed.connect(_on_continuar_pressed)
	container_acoes.add_child(botao_sair)

func _on_inspecionar_pressed():
	var sala = GameManager.salas[GameManager.sala_atual]
	var tipo = sala.get("inspecao", "")

	var botao = container_acoes.get_node_or_null("BotaoInspecionar")
	if botao:
		botao.queue_free()

	match tipo:
		"cura":
			var cura = sala.get("cura", 20)
			var j = GameManager.jogador
			var curado = min(cura, j["hp_max"] - j["hp"])
			j["hp"] += curado
			label_status.text = "Você encontrou suprimentos! +" + str(curado) + " HP."
			atualizar_interface()
		"alavanca":
			if not GameManager.alavanca_ativada:
				GameManager.ativar_alavanca()
				label_status.text = "Você encontrou uma alavanca e a ativou!\nUma porta se abre em algum lugar..."
			else:
				label_status.text = "A alavanca já foi ativada."
		"chave":
			if not GameManager.jogador["tem_chave"] and not GameManager.chave_nas_catacumbas:
				GameManager.jogador["tem_chave"] = true
				label_status.text = "Você encontrou uma chave antiga.\nTalvez ela abra algo por aqui..."
			else:
				label_status.text = "Você já pegou a chave."
		"mercado":
			GameManager.mercado_inspecionado = true
			if GameManager.jogador["tem_chave"]:
				GameManager.jogar_chave_pela_abertura()
				label_status.text = "Você vê uma abertura na parede.\nVocê joga a chave pelo buraco para as Catacumbas!"
			elif GameManager.chave_nas_catacumbas:
				label_status.text = "Você já jogou a chave pela abertura.\nEla está nas Catacumbas, caminho para o Arsenal."
			else:
				label_status.text = "Há uma abertura na parede dando para as Catacumbas.\nSe você tivesse uma chave, poderia jogá-la pelo buraco..."
		"catacumba":
			if GameManager.chave_nas_catacumbas:
				GameManager.chave_nas_catacumbas = false
				GameManager.salas["Arsenal"]["desbloqueada"] = true
				label_status.text = "Você encontrou a chave no chão!\nA passagem para o Arsenal está aberta."
			else:
				label_status.text = "Túneis escuros e úmidos.\nNada de importante aqui."
		_:
			label_status.text = tipo if tipo != "" else "Nada de importante aqui."
			
func _on_continuar_pressed():
	queue_free()
	GameManager.abrir_mapa()

func atualizar_visual_fila():
	# Limpa o container
	for filho in container_fila.get_children():
		filho.queue_free()

	# Mostra todos na fila + quem já agiu (fila completa = fila_combate + personagem_atual)
	var fila_completa = []
	if personagem_atual != null and personagem_atual["hp"] > 0:
		fila_completa.append(personagem_atual)
	for p in fila_combate:
		if p["hp"] > 0:
			fila_completa.append(p)

	for i in range(fila_completa.size()):
		var p = fila_completa[i]
		var label = Label.new()

		# Destaca quem é o atual (primeiro da lista)
		if i == 0:
			label.text = "► " + p["nome"]
			label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			label.text = p["nome"]
			label.add_theme_color_override("font_color", Color.WHITE)

		# Separador entre nomes
		if i < fila_completa.size() - 1:
			var seta = Label.new()
			seta.text = " → "
			seta.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			container_fila.add_child(label)
			container_fila.add_child(seta)
		else:
			container_fila.add_child(label)
