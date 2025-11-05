# Define o compilador (assembler) e o linker
ASM = nasm
LD = ld

# Flags do assembler
# -f elf64: Formato do arquivo (executável de 64 bits para Linux)
ASM_FLAGS = -f elf64

# Nome do executável final
TARGET = castle

# Nome do arquivo objeto
OBJ = castle.o

# Localização do código-fonte
SRC = src/castle.asm

# Regra principal (default): o que 'make' faz por padrão
all: $(TARGET)

# Regra para criar o executável (linker)
# Depende do arquivo objeto
$(TARGET): $(OBJ)
	$(LD) $(OBJ) -o $(TARGET)
	@echo "Executável '$(TARGET)' criado com sucesso!"

# Regra para criar o arquivo objeto (assembler)
# Depende do arquivo-fonte
$(OBJ): $(SRC)
	$(ASM) $(ASM_FLAGS) $(SRC) -o $(OBJ)

# Regra "clean" para limpar os arquivos gerados
clean:
	rm -f $(TARGET) $(OBJ)
	@echo "Arquivos compilados removidos."

# Regra "run" para compilar e executar
run: all
	./$(TARGET)