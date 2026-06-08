extends Node

var salas: Dictionary = {
	"Entrada": {
		"cena": "res://scenes/rooms/Entrada.tscn",
		"vizinhos": ["Encruzilhada"],
		"desbloqueada": true,
		"combate_concluido": true,
		"inspecao": ""
	},
	"Encruzilhada": {
		"cena": "res://scenes/rooms/Encruzilhada.tscn",
		"vizinhos": ["Entrada", "Floresta", "Cripta", "Mercado"],
		"desbloqueada": true,
		"combate_concluido": false,
		"inspecao": "Paredes cobertas de musgo. Três caminhos se abrem à sua frente.",
		"inimigos": [
			{"nome": "Goblin", "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"}
		]
	},

	# ── Caminho A ──
	"Floresta": {
		"cena": "res://scenes/rooms/Floresta.tscn",
		"vizinhos": ["Encruzilhada", "Pantano"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "cura",
		"cura": 20,
		"inimigos": [
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Pantano": {
		"cena": "res://scenes/rooms/Pantano.tscn",
		"vizinhos": ["Floresta", "Ruinas"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "O chão encharcado esconde apenas lama e ossos. Nada de importante aqui.",
		"inimigos": [
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Ruinas": {
		"cena": "res://scenes/rooms/Ruinas.tscn",
		"vizinhos": ["Pantano", "Torre"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "cura",
		"cura": 15,
		"inimigos": [
			{"nome": "Goblin", "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Goblin", "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Torre": {
		"cena": "res://scenes/rooms/Torre.tscn",
		"vizinhos": ["Ruinas", "Antesala"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "Uma torre abandonada. O vento uiva pelas frestas. Nada de importante aqui.",
		"inimigos": [
			{"nome": "Arqueiro",   "hp": 30, "ataque": 8,  "precisao": 80, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Boss Menor", "hp": 80, "ataque": 12, "precisao": 75, "defendendo": false, "tipo": "inimigo"}
		]
	},

	# ── Caminho B ──
	"Cripta": {
		"cena": "res://scenes/rooms/Cripta.tscn",
		"vizinhos": ["Encruzilhada", "Altar", "Catacumba"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "Cheira a mofo e sangue velho. Dois caminhos se ramificam daqui.",
		"inimigos": [
			{"nome": "Goblin", "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Altar": {
		"cena": "res://scenes/rooms/Altar.tscn",
		"vizinhos": ["Cripta"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "alavanca",
		"tem_alavanca": true,
		"inimigos": [
			{"nome": "Goblin", "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Catacumba": {
		"cena": "res://scenes/rooms/Catacumba.tscn",
		"vizinhos": ["Cripta", "Camara", "Arsenal"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "Há duas aberturas na parede para duas salas trancadas,\numa com buraco de chave e outra com mecanismo",
		"inimigos": [
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Camara": {
		"cena": "res://scenes/rooms/Camara.tscn",
		"vizinhos": ["Catacumba", "Salao"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "cura",
		"cura": 25,
		"requer_alavanca": true,
		"inimigos": [
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Salao": {
		"cena": "res://scenes/rooms/Salao.tscn",
		"vizinhos": ["Camara", "Antesala"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "Um salão vasto e silencioso. Nada de importante aqui.",
		"inimigos": [
			{"nome": "Boss Menor", "hp": 80, "ataque": 12, "precisao": 75, "defendendo": false, "tipo": "inimigo"}
		]
	},

	# ── Caminho C ──
	"Mercado": {
		"cena": "res://scenes/rooms/Mercado.tscn",
		"vizinhos": ["Encruzilhada", "Templo"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "mercado",
		"tem_abertura_para": "Catacumba",
		"inimigos": [
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Templo": {
		"cena": "res://scenes/rooms/Templo.tscn",
		"vizinhos": ["Mercado"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "chave",
		"tem_chave": true,
		"inimigos": [
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Arsenal": {
		"cena": "res://scenes/rooms/Arsenal.tscn",
		"vizinhos": ["Catacumba", "Antesala"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "cura",
		"cura": 20,
		"requer_chave": true,
		"inimigos": [
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Goblin",   "hp": 40, "ataque": 5, "precisao": 70, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},

	# ── Final ──
	"Antesala": {
		"cena": "res://scenes/rooms/Antesala.tscn",
		"vizinhos": ["Torre", "Salao", "Arsenal", "Boss"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "cura",
		"cura": 30,
		"inimigos": [
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"},
			{"nome": "Arqueiro", "hp": 30, "ataque": 8, "precisao": 80, "defendendo": false, "tipo": "inimigo"}
		]
	},
	"Boss": {
		"cena": "res://scenes/rooms/Boss.tscn",
		"vizinhos": ["Antesala"],
		"desbloqueada": false,
		"combate_concluido": false,
		"inspecao": "Silêncio absoluto. O chão está coberto de cinzas.",
		"inimigos": [
			{"nome": "Boss Final", "hp": 250, "ataque": 30, "precisao": 90, "defendendo": false, "tipo": "inimigo"}
		]
	}
}

var jogador = {
	"nome": "Herói",
	"hp": 150,
	"hp_max": 150,
	"ataque": 100,
	"precisao": 100,
	"defendendo": false,
	"tem_chave": false, 
	"tipo": "jogador"
}

var sala_atual: String = "Entrada"

var alavanca_ativada: bool = false
var chave_nas_catacumbas: bool = false
var mercado_inspecionado: bool = false
var pilha: Array = []
const MAX_POPS: int = 5
var pops_restantes: int = MAX_POPS

func _ready():
	pilha.push_back("Entrada")
	for nome in salas:
		if salas[nome]["combate_concluido"]:
			for vizinho in salas[nome]["vizinhos"]:
				salas[vizinho]["desbloqueada"] = true

func ir_para(destino: String) -> bool:
	if destino not in salas[sala_atual]["vizinhos"]:
		print("Sala não é vizinha!")
		return false
	if not salas[destino]["desbloqueada"]:
		print("Sala trancada! Conclua o combate primeiro.")
		return false
	if salas[destino].get("requer_alavanca", false) and not alavanca_ativada:
		print("A porta está trancada. Há uma alavanca em algum lugar...")
		return false
	if salas[destino].get("requer_chave", false) and not chave_nas_catacumbas:
		print("A porta está trancada. Você precisa de uma chave...")
		return false

	pilha.push_back(destino)
	sala_atual = destino
	_limpar_overlays()
	get_tree().change_scene_to_file(salas[sala_atual]["cena"])
	return true

func voltar() -> bool:
	if pops_restantes <= 0:
		print("Você não tem mais como voltar no tempo!")
		return false
	if pilha.size() <= 1:
		print("Você está na Entrada, não pode voltar mais.")
		return false

	# Reseta o combate da sala que está saindo (o topo atual)
	var sala_abandonada = pilha.back()
	salas[sala_abandonada]["combate_concluido"] = false

	pilha.pop_back()
	pops_restantes -= 1
	sala_atual = pilha.back()

	print("Pops restantes: ", pops_restantes)
	_limpar_overlays()
	get_tree().change_scene_to_file(salas[sala_atual]["cena"])
	return true

func ativar_alavanca():
	alavanca_ativada = true
	print("Alavanca ativada! A Câmara foi destrancada.")

func jogar_chave_pela_abertura():
	if sala_atual != "Mercado":
		print("Você não está no Mercado!")
		return
	if not jogador["tem_chave"]:
		print("Você não tem a chave!")
		return
	jogador["tem_chave"] = false
	chave_nas_catacumbas = true
	print("A chave caiu pelas catacumbas!")
	
func checar_roubo_encruzilhada():
	if sala_atual == "Encruzilhada" and jogador["tem_chave"]:
		jogador["tem_chave"] = false
		chave_nas_catacumbas = false
		# Reseta — chave volta ao templo
		salas["Templo"]["combate_concluido"] = false
		salas["Templo"]["desbloqueada"] = true
		return true
	return false

func combate_concluido():
	salas[sala_atual]["combate_concluido"] = true
	for vizinho in salas[sala_atual]["vizinhos"]:
		salas[vizinho]["desbloqueada"] = true
	print("Sala ", sala_atual, " concluída!")

func get_inimigos_sala_atual() -> Array:
	if salas[sala_atual].has("inimigos"):
		var copia = []
		for inimigo in salas[sala_atual]["inimigos"]:
			copia.push_back(inimigo.duplicate())
		return copia
	return []

func abrir_mapa():
	var mapa = preload("res://scenes/ui/MapaNavegacao.tscn").instantiate()
	get_tree().root.add_child(mapa)
	
func game_over():
	var tela = preload("res://scenes/ui/GameOver.tscn").instantiate()
	get_tree().root.add_child(tela)

func _limpar_overlays():
	# Remove qualquer mapa ou combate aberto antes de trocar de cena
	for no in get_tree().root.get_children():
		if no.scene_file_path in [
			"res://scenes/ui/MapaNavegacao.tscn",
            "res://scenes/combat/GerenciadorCombate.tscn"
		]:
			no.queue_free()
