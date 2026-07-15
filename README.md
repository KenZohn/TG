# Jogo Cognitivo

Jogo desenvolvido em **Godot Engine 4.5** que combina um sistema de batalha no estilo RPG com minijogos voltados ao estímulo de habilidades cognitivas, como memória, atenção, raciocínio lógico e tempo de reação.

Em vez de um ataque convencional, cada ação do jogador em combate corresponde à resolução de um minijogo cognitivo. O desempenho nesse desafio (acerto, erro e tempo de resposta) determina o dano causado, a chance de crítico e a defesa aplicada contra o inimigo. Ao final de cada batalha, o jogador recebe um resumo de desempenho com número de acertos, erros, tempo total e precisão, além de pontos que podem ser investidos em uma árvore de habilidades para evoluir o personagem.

## Funcionalidades

- Sistema de batalha por turnos integrado aos minijogos cognitivos
- Mapa de progressão entre estágios
- Árvore de habilidades para evolução de atributos (vida, dano, defesa, crítico e tempo)
- Inventário e loja de itens equipáveis, com efeitos sobre os atributos do personagem
- Gráfico de radar para visualização das habilidades cognitivas do jogador (memória, agilidade, foco, coordenação e raciocínio)
- Sistema de save local em múltiplos slots
- Sincronização opcional de saves na nuvem via Supabase
- Trilha sonora e efeitos sonoros dedicados a cada contexto do jogo

## Minijogos

| Minijogo | Objetivo |
|---|---|
| Caminho | Unir dois pontos sem tocar nos obstáculos (bombas) |
| Cor Correta | Verificar se o significado da palavra corresponde à cor exibida, com base no efeito Stroop |
| Reação | Responder ao estímulo em até 0,6 segundo |
| Reflexo | Responder ao estímulo com a maior velocidade possível |
| Menor ao Maior | Selecionar os valores em ordem crescente |
| Memória | Localizar pares de cartas em um jogo da memória |
| Cálculo Rápido | Identificar a operação matemática que completa a equação |
| Classificação | Identificar a posição relativa de um elemento na tela |
| Colete e Desvie | Controlar o personagem para coletar itens e evitar obstáculos |
| Único | Identificar o elemento que se diferencia dos demais em cor, número ou forma |

## Tecnologias

- **Motor de jogo:** Godot Engine 4.5
- **Linguagem:** GDScript
- **Persistência:** arquivos locais em JSON, com sincronização opcional via Supabase
- **Resolução base:** 1280x720, com escalonamento adaptativo (canvas_items)

## Estrutura do projeto

```
battle/
├── assets/          # Sprites, ícones, áudio e temas visuais
├── resources/       # Recursos do Godot (.tres)
├── saves/           # Arquivos de save locais
├── scenes/          # Cenas do jogo (telas, batalha, mapa, minijogos)
├── scripts/
│   ├── autoloads/   # Singletons globais (estado do jogo, itens, estágios)
│   ├── challenges/  # Lógica de cada minijogo cognitivo
│   ├── game/        # Lógica de batalha e navegação no mapa
│   ├── managers/    # Save, inventário, áudio, estatísticas e sincronização
│   ├── resources/   # Definições de recursos (itens, etc.)
│   └── ui/          # Telas de interface do usuário
├── themes/          # Temas visuais da interface
└── project.godot    # Arquivo de configuração do projeto
```

## Como executar

1. Instale a [Godot Engine 4.5](https://godotengine.org/download) ou versão superior.
2. Clone este repositório.
3. Na Godot, selecione "Importar" e aponte para o arquivo `battle/project.godot`.
4. Execute o projeto (F5).

### Sincronização em nuvem (opcional)

Para habilitar a sincronização de saves via Supabase, crie um arquivo `config.cfg` dentro da pasta `battle/`, com o seguinte conteúdo:

```ini
[supabase]
url="https://seu-projeto.supabase.co"
key="sua-chave-anon"
```

Esse arquivo é ignorado pelo controle de versão e o recurso é inteiramente opcional; o jogo funciona normalmente utilizando apenas os saves locais.

## Build e exportação

O projeto já conta com um preset de exportação configurado para Windows Desktop (`battle/export_presets.cfg`). Para gerar o executável, utilize o menu Project > Export no editor da Godot, após instalar os templates de exportação correspondentes à versão da engine.

## Créditos

Parte das trilhas sonoras, efeitos sonoros e alguns sprites são provenientes de bibliotecas de terceiros. Os devidos créditos estão listados nos arquivos `credits.txt` e `readme.txt` disponíveis nas subpastas de `assets/`.

