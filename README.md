# Battle at Traitor's Castle (Versão Assembly)

Este repositório é uma **releitura** moderna em Assembly (x86-64, Linux) do jogo "Battle at Traitor's Castle". O jogo original foi publicado em 1982 no livro **Computer Battlegames** da Usborne Publishing.

Este projeto é baseado no jogo da página 14 do livro, que foi originalmente escrito em BASIC para microcomputadores como o ZX Spectrum e BBC Micro.

## Sobre o Jogo

Você é um dos arqueiros de elite do Rei, agachado atrás dos arbustos fora do Castelo do Barão Traidor. Seu objetivo é acertar os soldados do Barão quando eles aparecem acima das muralhas.

### Como Jogar (Esta Versão)

* O computador exibirá uma linha com 9 posições (`.......O.` ou `S........`).
* Você deve digitar o número (1-9) correspondente à posição do alvo.
* Você tem **3 segundos** para acertar.
* **Tipos de Alvo:** (Baseado na sugestão "Puzzle corner" do livro original)
    * `O` = Soldado Comum (Vale 1 ponto)
    * `S` = Soldado Especial (Vale 5 pontos)
* O jogo termina após 10 rodadas ou se você digitar `q` para sair.

##  Como Compilar e Rodar

Este projeto foi desenvolvido para Linux e utiliza `nasm` e `ld`.

### 1. Usando Make (Recomendado)

Basta clonar o repositório e executar `make`:

```bash
git clone [https://github.com/seu-usuario/Battle-at-Traitor-s-Castle.git](https://github.com/seu-usuario/Battle-at-Traitor-s-Castle.git)
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

* **/src**: Contém o código-fonte principal em Assembly (`castle.asm`).
* **/docs**: Contém a análise do código BASIC original (`analise_jogo_original.txt`).
* **/reference_material**:
* **Makefile**: Automatiza o processo de compilação.
* **README.md**: Este arquivo.

## 👨‍💻 Desenvolvedor

Esta versão em Assembly (x86-64, Linux) foi desenvolvida por **[Ana Alicy Ribeiro & Kaylane Castro]**.

* **GitHub:** `[@AlicyRibeiro](https://github.com/AlicyRibeiro)`
* **Livro:** *Computer Battlegames*
* **Autores:** Daniel Isaaman e Jenny Tyler
* **Publicação:** Usborne Publishing Ltd, 1982
