extends Node2D

# ── Posições de cada sala na tela (ajusta conforme resolução) ──
var posicoes: Dictionary = {
	"Entrada":      Vector2(120, 290),
	"Encruzilhada": Vector2(250, 290),

	# Caminho A
	"Floresta":     Vector2(380, 80),
	"Pantano":      Vector2(510, 80),
	"Ruinas":       Vector2(640, 80),
	"Torre":        Vector2(770, 80),

	# Caminho B
	"Altar":        Vector2(380, 190),
	"Cripta":       Vector2(380, 290),
	"Catacumba":    Vector2(510, 290),
	"Camara":       Vector2(640, 290),
	"Salao":        Vector2(770, 290),

	# Caminho C
	"Templo":       Vector2(380, 410),
	"Mercado":      Vector2(380, 500),
	"Arsenal":      Vector2(510, 500),

	# Final
	"Antesala":     Vector2(940, 290),
	"Boss":         Vector2(1060, 290),
}

# Cores
const COR_BECO = Color(0.35, 0.35, 0.35, 1.0) 
const COR_FUNDO = Color(0.05, 0.05, 0.05, 0.95)
const COR_LINHA = Color(0.3, 0.3, 0.3, 1.0)
const COR_SALA_NORMAL = Color(0.25, 0.25, 0.25, 1.0)
const COR_SALA_ATUAL = Color(1.0, 1.0, 1.0, 1.0)
const COR_VISITADA = Color(0.5, 0.5, 0.5, 1.0)
const COR_ACESSIVEL = Color(0.9, 0.9, 0.9, 1.0)
const COR_TRANCADA = Color(0.15, 0.15, 0.15, 1.0)
const COR_BRILHO = Color(1.0, 1.0, 0.85, 1.0)

const RAIO_SALA = 18.0
const RAIO_CLIQUE = 28.0

var sala_hover: String = ""

func _draw():
	var salas = GameManager.salas
	var sala_atual = GameManager.sala_atual
	var vizinhos_acessiveis = _get_vizinhos_acessiveis()

	# ── Desenha arestas ──
	for nome in salas:
		for vizinho in salas[nome]["vizinhos"]:
			if posicoes.has(nome) and posicoes.has(vizinho):
				draw_line(posicoes[nome], posicoes[vizinho], COR_LINHA, 1.5)

	# ── Desenha nós ──
	for nome in posicoes:
		if not salas.has(nome):
			continue

		var pos = posicoes[nome]
		var cor = _get_cor_sala(nome, sala_atual, vizinhos_acessiveis)
		var raio = RAIO_SALA

		# Brilho pulsante nos acessíveis
		if nome in vizinhos_acessiveis and nome == sala_hover:
			draw_circle(pos, raio + 8, Color(cor.r, cor.g, cor.b, 0.2))

		draw_circle(pos, raio, cor)

		# Label da sala
		var fonte_cor = Color.BLACK if cor.v > 0.5 else Color.WHITE
		draw_string(
			ThemeDB.fallback_font,
			pos + Vector2(-len(nome) * 3.5, raio + 14),
			nome,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			11,
			fonte_cor if false else Color.WHITE
		)

	# ── Indicador da sala atual ──
	var pos_atual = posicoes.get(sala_atual, Vector2.ZERO)
	draw_arc(pos_atual, RAIO_SALA + 5, 0, TAU, 32, COR_SALA_ATUAL, 2.0)

func _get_cor_sala(nome: String, sala_atual: String, acessiveis: Array) -> Color:
	if nome == sala_atual:
		return COR_SALA_ATUAL
	if nome in acessiveis:
		return COR_BRILHO
	if nome in GameManager.pilha:
		return COR_VISITADA
	# becos sem saída — vizinho único
	if GameManager.salas[nome]["vizinhos"].size() == 1:
		return COR_BECO
	if GameManager.salas[nome]["desbloqueada"]:
		return COR_SALA_NORMAL
	return COR_TRANCADA

func _get_vizinhos_acessiveis() -> Array:
	var acessiveis = []
	var sala = GameManager.salas[GameManager.sala_atual]
	
	for vizinho in sala["vizinhos"]:
		# Bloqueia salas que já estão na pilha (são "passado")
		if vizinho in GameManager.pilha:
			continue
			
		var dados = GameManager.salas[vizinho]
		
		if not dados["desbloqueada"]:
			continue
		if dados.get("requer_alavanca", false) and not GameManager.alavanca_ativada:
			continue
		if dados.get("requer_chave", false) and not GameManager.chave_nas_catacumbas:
			continue
			
		acessiveis.append(vizinho)
	
	return acessiveis

func _input(event):
	if event is InputEventMouseMotion:
		sala_hover = _sala_sob_mouse(event.position)
		queue_redraw()

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var clicada = _sala_sob_mouse(event.position)
			if clicada == "":
				return

			if clicada in _get_vizinhos_acessiveis():
				# Checa roubo antes de ir
				if clicada == "Encruzilhada" and GameManager.jogador["tem_chave"]:
					GameManager.checar_roubo_encruzilhada()
					_mostrar_popup("Um Goblin te atacou pela surpresa!\nEle roubou a chave e fugiu de volta ao Templo!")
					await get_tree().create_timer(2.0).timeout
				GameManager.ir_para(clicada)
				get_parent().queue_free()
				return

			# Sala vizinha mas bloqueada
			var vizinhos_sala = GameManager.salas[GameManager.sala_atual]["vizinhos"]
			if clicada in vizinhos_sala:
				_mostrar_mensagem_bloqueio(clicada)

func _sala_sob_mouse(pos: Vector2) -> String:
	for nome in posicoes:
		if pos.distance_to(posicoes[nome]) <= RAIO_CLIQUE:
			return nome
	return ""

func _mostrar_mensagem_bloqueio(nome_sala: String):
	var dados = GameManager.salas[nome_sala]
	var mensagem = ""

	if dados.get("requer_alavanca", false) and not GameManager.alavanca_ativada:
		mensagem = "Há uma porta à frente e ela está trancada.\nParece haver algum mecanismo que a controla..."
	elif dados.get("requer_chave", false) and not GameManager.chave_nas_catacumbas:
		mensagem = "Há uma porta à frente e ela está trancada.\nHá um espaço para uma chave na fechadura."
	elif not dados["desbloqueada"]:
		mensagem = "Você ainda não pode passar por aqui.\nDerrote os inimigos desta sala primeiro."

	if mensagem != "":
		_mostrar_popup(mensagem)

func _mostrar_popup(texto: String):
	var antigo = get_parent().get_node_or_null("Popup")
	if antigo:
		antigo.queue_free()

	var popup = Label.new()
	popup.name = "Popup"
	popup.text = texto
	popup.autowrap_mode = TextServer.AUTOWRAP_WORD
	popup.custom_minimum_size = Vector2(300, 0)
	
	# Fundo escuro pra contraste
	popup.add_theme_color_override("font_color", Color.WHITE)
	popup.add_theme_stylebox_override("normal", _criar_fundo_popup())
	
	# Canto inferior esquerdo
	popup.position = Vector2(16, get_viewport().size.y - 180)
	get_parent().add_child(popup)

	await get_tree().create_timer(2.5).timeout
	if is_instance_valid(popup):
		popup.queue_free()

func _criar_fundo_popup() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.75)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style
