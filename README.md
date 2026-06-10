# ⚔️ Estrutura de Dungeons

> Trabalho prático da disciplina **Estrutura de Dados II** — FUMEC  
> Desenvolvido em **Godot 4** como demonstração aplicada de estruturas de dados clássicas em um jogo funcional.

---

## 🎮 Sobre o Jogo

**Estrutura de Dungeons** é um RPG tático por turnos onde o jogador explora um calabouço composto por salas interligadas, enfrenta inimigos em combates estratégicos e resolve puzzles para abrir novos caminhos — tudo enquanto gerencia um recurso limitado: a capacidade de **voltar no tempo**.

---

## 🧠 Estruturas de Dados Aplicadas

### 🗺️ Grafo — Navegação entre Salas
O mapa do jogo é modelado como um **grafo não-direcionado**, onde cada sala é um nó e cada conexão entre salas é uma aresta. O jogador visualiza o grafo completo na tela e navega clicando nos nós acessíveis.

```
Entrada → Encruzilhada → Floresta → Pântano → Ruínas → Torre
                       → Cripta  → Altar (beco)
                                 → Catacumba → Câmara → Salão
                       → Mercado → Templo (beco)
                                 → Catacumba → Arsenal
                                            → Antesala → Boss
```

### 📚 Pilha — Histórico de Navegação
Cada sala visitada é empilhada (`push`). O jogador pode **voltar no tempo** desfazendo o último movimento (`pop`), com um limite de usos. Ao dar pop, os inimigos da sala abandonada **ressuscitam** — você realmente voltou no tempo.

```
Topo → [Catacumba]
       [Cripta]
       [Encruzilhada]
       [Entrada]
```

### 🎯 Fila — Ordem de Combate
No início de cada batalha, todos os participantes rolam **iniciativa (1d20)**. A ordem resultante forma uma **fila**, onde cada personagem age quando chega à frente e retorna ao fim ao terminar seu turno. Mortos são removidos permanentemente.

```
► Goblin → Herói → Arqueiro → Goblin → ...
```

---

## 🧩 Puzzles

### ⚙️ Alavanca
Na **Cripta**, um ramal leva ao **Altar** (beco sem saída) onde está uma alavanca. Ativá-la destrava a **Câmara** mais adiante. O jogador precisa usar o pop para voltar e avançar pelo caminho correto.

### 🗝️ Chave Viajante
No **Templo** (beco sem saída acessado pelo Mercado) há uma chave antiga. Ao inspecionar o **Mercado**, o jogador descobre uma abertura na parede e pode arremessar a chave pelas Catacumbas. Se passar pela Encruzilhada com a chave, um **Goblin a rouba** e a devolve ao Templo — forçando o uso do pop.

---

## ⚔️ Sistema de Combate

- **Turnos por iniciativa** — ordem aleatória a cada combate
- **Ataque** — dano fixo com chance de acerto baseada em precisão
- **Defesa** — reduz o dano recebido no próximo ataque inimigo pela metade
- **HP persistente** — a vida do herói não regenera entre salas
- **Inspeção pós-combate** — cada sala pode conter cura, itens ou pistas

---

## 🏆 Pontuação

| Fator | Efeito |
|---|---|
| Pontos base | +1000 |
| Salas visitadas | -20 por sala |
| Pops usados | -50 por pop |
| Usou alavanca | +200 |
| Usou chave | +200 |
| Vida restante | +até 150 |

---

## 🛠️ Como Executar

### Pré-requisitos
- [Godot Engine 4.x](https://godotengine.org/download)

### Passos
```bash
git clone https://github.com/gABIREUSU/Estrutura-de-Dungeons.git
```
1. Abra o Godot 4
2. Clique em **Import** e selecione a pasta do projeto
3. Pressione **F5** ou clique em ▶ para rodar

---

## 📁 Estrutura do Projeto

```
res://
├── scenes/
│   ├── ui/          # Menu, Mapa de Navegação, Game Over, Vitória
│   ├── rooms/       # Cenas de cada sala do calabouço
│   └── combat/      # Gerenciador de Combate
└── scripts/
    ├── GameManager.gd        # Autoload — grafo, pilha, estado global
    ├── gerenciador_combate.gd # Fila de combate e lógica de turnos
    ├── grafo_node.gd          # Renderização e interação do grafo
    ├── sala_base.gd           # Classe base para todas as salas
    ├── mapa_navegacao.gd      # Menu de navegação entre salas
    └── main_menu.gd           # Tela inicial
```

---

## 👥 Integrantes

| Nome |
|---|
| Gabriel Andrade |
| Taylor  |

---

## 📚 Disciplina

**Estrutura de Dados II** — Ciência da Computação  
Universidade FUMEC · 1º Semestre 2025  
Profª. Amanda Danielle Lima de Oliveira
