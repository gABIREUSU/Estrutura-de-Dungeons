<div align="center">

# ⚔️ Estrutura de Dungeons

<img src="https://img.shields.io/badge/Godot-4.x-478CBF?style=for-the-badge&logo=godot-engine&logoColor=white"/>
<img src="https://img.shields.io/badge/GDScript-blue?style=for-the-badge&logo=godot-engine&logoColor=white"/>
<img src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=for-the-badge"/>

<br/>

> RPG tático por turnos desenvolvido como trabalho prático de **Estrutura de Dados II**  
> Cada mecânica do jogo é sustentada por uma estrutura de dados real e funcional.

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

</div>

## 📖 Sobre

**Estrutura de Dungeons** é um RPG onde o jogador explora um calabouço com múltiplos caminhos, enfrenta inimigos em combate tático por turnos e resolve puzzles para avançar — tudo enquanto gerencia um recurso precioso: a capacidade de **voltar no tempo**.

O diferencial do projeto é que as estruturas de dados não são apenas implementadas no código — elas **aparecem visualmente na tela** e definem diretamente a experiência de jogo.

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🧠 Estruturas de Dados

<table>
<tr>
<td width="33%" align="center">

### 🗺️ Grafo
**Navegação entre Salas**

O mapa completo é um grafo renderizado em tempo real. O jogador visualiza todos os nós e arestas e navega clicando nas salas acessíveis. Salas trancadas, becos e caminhos alternativos são representados visualmente com cores diferentes.

</td>
<td width="33%" align="center">

### 📚 Pilha
**Viagem no Tempo**

Cada sala visitada é empilhada. O jogador pode desfazer movimentos com `pop()`, voltando ao estado anterior — inimigos ressuscitam, eventos se resetam. O limite de pops cria tensão estratégica.

</td>
<td width="33%" align="center">

### 🎯 Fila
**Ordem de Combate**

Todos os participantes rolam iniciativa (1d20) no início de cada batalha. A ordem forma uma fila circular visível na tela: cada personagem age ao chegar à frente e retorna ao fim após seu turno.

</td>
</tr>
</table>

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🗺️ Mapa do Calabouço

```
                    ╔═══════╗   ╔═════════╗   ╔════════╗   ╔═══════╗
                    ║Floresta╠───╣  Pântano ╠───╣ Ruínas  ╠───╣ Torre  ║
                    ╚═══╤═══╝   ╚═════════╝   ╚════════╝   ╚═══╤═══╝
                        │                                       │
╔═══════╗   ╔═══════════╧══╗   ╔════════╗                       │
║Entrada╠───╣ Encruzilhada ╠───╣  Cripta ╠──╔═══════╗           │
╚═══════╝   ╚══════════════╝   ╚════╤═══╝  ║ Altar ║(beco ⚙️)  │
                    │               │      ╚═══════╝             │
                    │        ╔══════╧═════╗                      │
                    │        ║  Catacumba ╠──╔════════╗──╔══════╗│
                    │        ╚══════╤═════╝  ║ Câmara ╠──╣ Salão╠╝
                    │               │        ╚════════╝  ╚══════╝
                    │        ╔══════╧═════╗
                    │        ║  Arsenal   ║
                    │        ╚══════╤═════╝
                    │               │
                ╔═══╧════╗          │         ╔══════════╗   ╔══════╗
                ║Mercado ║          └─────────╣ Antesala ╠───╣ Boss ║
                ╚═══╤════╝                    ╚══════════╝   ╚══════╝
                    │
               ╔════╧═══╗
               ║ Templo ║ (beco 🗝️)
               ╚════════╝
```

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🧩 Puzzles

<details>
<summary><b>⚙️ O Puzzle da Alavanca — Caminho B</b></summary>
<br/>

A **Cripta** se bifurca em dois caminhos. Um leva ao **Altar** — um beco sem saída onde está uma alavanca. O outro segue para a **Catacumba** e eventualmente chega na **Câmara**, que está trancada.

**Solução:** entrar no Altar, ativar a alavanca, usar `pop()` para voltar à Cripta e seguir pela Catacumba. A Câmara agora está aberta.

</details>

<details>
<summary><b>🗝️ O Puzzle da Chave Viajante — Caminho C</b></summary>
<br/>

O **Templo** é um beco sem saída acessado pelo Mercado. Dentro há uma chave antiga. O **Mercado** tem uma abertura na parede que dá para as **Catacumbas**.

**Solução:** pegar a chave no Templo → usar `pop()` para voltar ao Mercado → inspecionar e arremessar a chave pela abertura → a chave cai nas Catacumbas → avançar pelo caminho da Cripta até as Catacumbas → pegar a chave → o Arsenal está desbloqueado.

> ⚠️ **Cuidado:** passar pela **Encruzilhada** com a chave faz um Goblin roubá-la e devolvê-la ao Templo.

</details>

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## ⚔️ Combate

```
┌─────────────────────────────────────────┐
│  ► Goblin → Herói → Arqueiro → Goblin   │  ← Fila de turnos (visível)
├─────────────────────────────────────────┤
│                                         │
│        Inimigos          Herói          │
│                                         │
│  ❤ Herói: 120 / 150                     │
├─────────────────────────────────────────┤
│  [Atacar Goblin]  [Atacar Arqueiro]     │
│           [🛡 Defender]                 │
└─────────────────────────────────────────┘
```

| Ação | Efeito |
|---|---|
| ⚔️ Atacar | Dano fixo com chance de acerto baseada em precisão |
| 🛡️ Defender | Reduz o próximo dano recebido pela metade |
| 🎲 Iniciativa | 1d20 por participante define a ordem da fila |
| 💀 Morte | Personagens mortos são removidos da fila permanentemente |
| 🔁 Pop | Inimigos da sala abandonada ressuscitam |

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🏆 Pontuação Final

| Fator | Pontos |
|---|---|
| Base | +1000 |
| Por sala visitada | -20 |
| Por pop usado | -50 |
| Resolveu puzzle da alavanca | +200 |
| Resolveu puzzle da chave | +200 |
| Vida restante | +até 150 |

> 💡 Caminhos com puzzles rendem bônus — explorar os becos compensa!

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 🚀 Como Executar

**Pré-requisito:** [Godot Engine 4.x](https://godotengine.org/download)

```bash
git clone https://github.com/gABIREUSU/Estrutura-de-Dungeons.git
```

1. Abra o **Godot 4**
2. Clique em **Import** e selecione a pasta do projeto
3. Pressione **F5** ou clique em ▶️ para rodar

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 📁 Estrutura do Projeto

```
res://
├── scenes/
│   ├── ui/                    # Menu, Mapa, Game Over, Vitória
│   ├── rooms/                 # Cenas das salas do calabouço
│   └── combat/                # Gerenciador de Combate
└── scripts/
    ├── GameManager.gd         # Autoload — grafo, pilha, estado global
    ├── gerenciador_combate.gd  # Fila de combate e turnos
    ├── grafo_node.gd           # Renderização do grafo na tela
    ├── sala_base.gd            # Classe base para todas as salas
    ├── mapa_navegacao.gd       # Menu de navegação
    └── main_menu.gd            # Tela inicial
```

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

## 👥 Integrantes

<table align="center">
<tr>
<td align="center">
<b>Gabriel Reus</b><br/>
<a href="https://github.com/gABIREUSU">@gABIREUSU</a>
</td>
<td align="center">
<b>Gabriel Andrade</b>
</td>
<td align="center">
<b>Taylor Junio</b>
</td>
</tr>
</table>

<br/>

![divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

<div align="center">

**Estrutura de Dados II** · Ciência da Computação · FUMEC  
Profª. Amanda Danielle Lima de Oliveira · 1º Semestre 2025

</div>
