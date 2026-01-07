#  Battle at Traitor's Castle (Versão Assembly)

Este repositório apresenta uma **releitura moderna em Assembly (x86-64, Linux)** do jogo clássico **"Battle at Traitor's Castle"**, originalmente publicado em **1982** no livro  
**_Computer Battlegames_**, da **Usborne Publishing**.

O jogo original foi escrito em **BASIC** para microcomputadores da época, como o **ZX Spectrum** e o **BBC Micro**.  
Esta implementação busca preservar a **lógica e a mecânica original**, adaptando-as para um ambiente moderno em **Linux**, utilizando **Assembly x86-64**.

---

##  Contexto Histórico

- **Livro:** *Computer Battlegames*  
- **Autores:** Daniel Isaaman e Jenny Tyler  
- **Editora:** Usborne Publishing Ltd  
- **Ano:** 1982  

Este projeto é inspirado especificamente no jogo apresentado na **página 14** do livro, incluindo adaptações sugeridas na seção *Puzzle Corner*.

---

##  Sobre o Jogo

Você é um dos arqueiros de elite do Rei, escondido atrás dos arbustos fora do **Castelo do Barão Traidor**.  
Seu objetivo é acertar os soldados inimigos quando eles aparecem brevemente sobre as muralhas do castelo.

O desafio exige **atenção, rapidez e precisão**, já que o tempo para reagir é limitado.

---

##  Como Jogar (Nesta Versão)

- O jogo exibe uma linha com **9 posições**, por exemplo:


* O computador exibirá uma linha com 9 posições (`.......O.` ou `S........`).
- Cada posição representa um possível local onde o inimigo pode aparecer.
- Você deve digitar um número de **1 a 9**, correspondente à posição do alvo.
- Você tem **3 segundos** para responder.
- O jogo dura **10 rodadas** ou pode ser encerrado a qualquer momento digitando `q`.

### Tipos de Alvo

| Símbolo | Descrição             | Pontuação |
|--------|------------------------|-----------|
| `O`    | Soldado comum          | 1 ponto   |
| `S`    | Soldado especial       | 5 pontos  |

---

## Como Compilar e Executar

Este projeto foi desenvolvido para **Linux** e utiliza:

- **NASM** (Netwide Assembler)
- **LD** (GNU Linker)

### 🔹 Opção 1: Usando Make (Recomendado)

```bash
git clone https://github.com/AlicyRibeiro/Battle-at-Traitor-s-Castle.git
cd Battle-at-Traitor-s-Castle
make
./castle
````

#### Comandos disponíveis no `Makefile`:

- `make` — Compila o projeto
- `make run` — Compila e executa o jogo
- `make clean` — Remove arquivos gerados (`castle` e `castle.c`)

```bash
git clone [https://github.com/AlicyRibeiro/Battle-at-Traitor-s-Castle.git](https://github.com/AlicyRibeiro/Battle-at-Traitor-s-Castle.git)
cd Battle-at-Traitor-s-Castle
make
./castle
```
O `Makefile` também inclui outros comandos úteis:
* `make clean`: Remove os arquivos compilados (`castle` e `castle.o`).
* `make run`: Compila e executa o jogo em um único passo.

### 2. Compilação Manual (Sem Makefile)

Se preferir compilar e lincar manualmente, use os seguintes comandos no seu terminal:

```bash
# 1. Compile o código Assembly (dentro de src/) para um arquivo objeto
nasm -f elf64 src/castle.asm -o castle.o

# 2. Linke o arquivo objeto para criar o executável final
ld castle.o -o castle

# 3. Execute o jogo
./castle
```

##  Estrutura do Repositório

```bash
Battle-at-Traitor-s-Castle/
│
├── src/
│   └── castle.asm        # Código-fonte principal em Assembly
│
├── docs/
│   └── analise_jogo_original.txt  # Análise do jogo BASIC original
│
├── reference_material/
│   ├── Computer Battlegames (Usborne Publishing).pdf
│   └── panfleto.png
│
├── Makefile              # Automação da compilação
├── README.md             # Este arquivo
└── LICENSE
`````
##  Desenvolvedor

Esta versão em Assembly (x86-64, Linux) foi desenvolvida por **Ana Alicy Ribeiro & Kaylane Castro**.

* **GitHub:** `@AlicyRibeiro(https://github.com/AlicyRibeiro)`
* **Livro:** *Computer Battlegames*
* **Autores:** Daniel Isaaman e Jenny Tyler
* **Publicação:** Usborne Publishing Ltd, 1982


## Licença e Créditos

Este projeto é uma adaptação educacional, sem fins comerciais, baseada em um jogo publicado originalmente pela Usborne Publishing.
Todos os direitos sobre o jogo original pertencem aos seus respectivos autores.
