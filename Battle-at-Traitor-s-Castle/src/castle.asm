; -----------------------------------------------------------------------------
; Jogo: Battle at Traitor's Castle (Versão Assembly)
; Autoras: [Ana Alicy Ribeiro & Kaylane Castro]
; GitHub: [https://github.com/AlicyRibeiro]
; Data: 2025
;
; Descrição: Recriação em Assembly (x86-64, Linux) do jogo "Battle at 
;            Traitor's Castle", baseado no original de 1982 do livro 
;             "Computer Battlegames" (Usborne Publishing). 
; -----------------------------------------------------------------------------


section .data
    ; (Seção de dados - Define todas as mensagens e valores fixos)
    msg1 db 10, "=== BATTLE AT TRAITOR'S CASTLE ===", 10, 10, 0
    tam_msg1 equ $ - msg1

    msg2 db "Você verá 9 posições numeradas de 1 a 9.", 10, 0
    tam_msg2 equ $ - msg2
    
    msg3 db "Um soldado aparecerá em uma dessas posições.", 10, 0
    tam_msg3 equ $ - msg3

    msg4 db "Digite o número correspondente rapidamente para acertar o alvo!", 10, 0
    tam_msg4 equ $ - msg4

    msg5 db "Legenda:", 10, 0
    tam_msg5 equ $ - msg5

    msg6 db "O = soldado comum (1 ponto), S = especial (5 pontos)", 10, 0
    tam_msg6 equ $ - msg6

    msg7 db "Digite 'q' a qualquer momento para sair do jogo.", 10, 10, 0
    tam_msg7 equ $ - msg7

    msg8 db "Pressione ENTER para comecar...", 10, 0
    tam_msg8 equ $ - msg8

    msg_invalida db "Entrada inválida. Digite um número de 1 a 9 ou 'q'.", 10, 0
    tam_msg_invalida equ $ - msg_invalida

    msg_contagem_base db "Proxima rodada em ", 0
    tam_msg_contagem_base equ $ - msg_contagem_base

    contagem_1 db "1...", 0
    tam_contagem_1 equ $ - contagem_1

    contagem_2 db "2...", 0
    tam_contagem_2 equ $ - contagem_2

    contagem_3 db "3", 0
    tam_contagem_3 equ $ - contagem_3

    msg_acerto db 27,"[32mAcertou!!!",27,"[0m",10,0
    tam_msg_acerto equ $ - msg_acerto

    msg_erro db 10, 27,"[31mErrou!! Prepara-se para proxima rodada.",27,"[0m",10,0
    tam_msg_erro equ $ - msg_erro

    msg_fim db "FIM DE JOGO! Obrigado por jogar.", 10, 0
    tam_msg_fim equ $ - msg_fim

    msg_acertos_prefix db "Você acertou ", 0
    tam_acertos_prefix equ $ - msg_acertos_prefix

    msg_acertos_suffix db " de 10.", 10, 0
    tam_acertos_suffix equ $ - msg_acertos_suffix

    limpar_tela db 27, '[2J', 27, '[H', 0
    tam_limpar_tela equ $ - limpar_tela

    prefix_rodada db "Rodada: ", 0
    tam_prefix_rodada equ $ - prefix_rodada
    
    prefix_pontos db "Pontuação: ", 0
    tam_prefix_pontos equ $ - prefix_pontos
    
    quebra_linha  db 10, 0
    instr         db "Digite um numero (1-9) ou 'q': ", 0
    tam_instr     equ $ - instr
    
    ; define o limite de tempo para a resposta do jogador em cada rodada (select)
    timeout:
        tv_sec  dq 3        ; A quantidade de segundos para esperar.
        tv_usec dq 0        ;A quantidade de microssegundos (milionésimos de segundo) adicionais.
    
    ; chamada pela função delay_1s
    tempo:                  ;Pausas fixas de 1 segundo no jogo
        dq 1                ;A quantidade de segundos de pausa (neste caso, fixo em 1).
        dq 0                ;A quantidade de nanossegundos (bilionésimos de segundo) adicionais.

section .bss
    buffer          resb 2
    select_fds      resb 128 
    entrada_jogador resb 4
    estado_atual    resb 1
    pontuacao       resd 1
    acertos_rodadas resd 1
    rodada_atual    resd 1
    num_buffer      resb 12
    alvo_str        resb 10
    posicao_alvo    resb 1
    tipo_alvo       resb 1
    random_byte     resb 1
    contagem_num    resb 1

    %define ESPERANDO_NOVA_RODADA 0
    %define MOSTRANDO_ALVO        1
    %define RODADA_ENCERRADA      2
    %define FIM_DE_JOGO           3

section .text
    global _start


; Ponto de entrada: Exibe o título, o menu de dificuldade e inicializa o jogo.
_start:
    mov rsi, msg1
    mov rdx, tam_msg1
    call escrever
    mov byte [estado_atual], ESPERANDO_NOVA_RODADA
    mov dword [pontuacao], 0
    mov dword [acertos_rodadas], 0
    mov dword [rodada_atual], 1
    jmp main_loop


; Loop principal: Roteador da máquina de estados do jogo.
main_loop:
    movzx rax, byte [estado_atual]
    cmp rax, ESPERANDO_NOVA_RODADA
    je estado_esperando
    cmp rax, MOSTRANDO_ALVO
    je estado_mostrando
    cmp rax, RODADA_ENCERRADA
    je estado_encerrada
    cmp rax, FIM_DE_JOGO
    je fim_jogo
    jmp main_loop


; Estado 1: Prepara uma nova rodada (responsável por gerar a posição e o tipo de cada alvo).
estado_esperando:
    call limpar
    cmp dword [rodada_atual], 1
    jne _pular_instrucoes
    mov rsi, msg2
    mov rdx, tam_msg2
    call escrever
    mov rsi, msg3
    mov rdx, tam_msg3
    call escrever
    mov rsi, msg4
    mov rdx, tam_msg4
    call escrever
    mov rsi, msg5
    mov rdx, tam_msg5
    call escrever
    mov rsi, msg6
    mov rdx, tam_msg6
    call escrever
    mov rsi, msg7
    mov rdx, tam_msg7
    call escrever
    mov rsi, msg8
    mov rdx, tam_msg8
    call escrever
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
    
_pular_instrucoes: ;responsável por gerar um alvo com uma posição e um tipo aleatórios.
    mov rax, 318
    mov rdi, random_byte
    mov rsi, 1
    xor rdx, rdx
    syscall
    movzx eax, byte [random_byte]
    mov ecx, 9
    xor edx, edx
    div ecx
    add dl, 1
    mov [posicao_alvo], dl
    ; Usa o mesmo byte aleatório para decidir o tipo de alvo
    movzx eax, byte [random_byte]
    ; Usa 'div' para ter uma chance de aprox. 20% (se o resto da divisão por 9 for 0)
    mov bl, 5
    div bl            
    cmp ah, 0
    je .especial      ; Se o resto for 0, o alvo é especial
    mov byte [tipo_alvo], 'O'
    jmp .montar

.especial:
    mov byte [tipo_alvo], 'S'

.montar:
    mov ecx, 0

.loop_alvo:
    mov bl, cl
    inc bl
    cmp bl, byte [posicao_alvo] 
    jne .ponto
    mov al, [tipo_alvo]
    mov [alvo_str + rcx], al
    jmp .proximo
    
.ponto:
    mov byte [alvo_str + rcx], '.'

.proximo:
    inc ecx
    cmp ecx, 9
    jl .loop_alvo
    mov byte [alvo_str + 9], 0
    mov byte [estado_atual], MOSTRANDO_ALVO
    jmp main_loop


; Estado 2: Mostra o alvo e a pontuação, gerencia a entrada com timeout.
estado_mostrando:
    mov rsi, prefix_rodada
    mov rdx, tam_prefix_rodada
    call escrever
    mov eax, [rodada_atual]
    mov rdi, num_buffer
    call imprime_inteiro
    mov rsi, rdi
    mov rdx, rax
    call escrever
    mov rsi, quebra_linha
    mov rdx, 1
    call escrever
    call delay_1s
    mov rsi, prefix_pontos
    mov rdx, tam_prefix_pontos
    call escrever
    mov eax, [pontuacao]
    mov rdi, num_buffer
    call imprime_inteiro
    mov rsi, rdi
    mov rdx, rax
    call escrever
    mov rsi, quebra_linha
    mov rdx, 1
    call escrever
    mov rsi, alvo_str
    mov rdx, 9
    call escrever
    mov rsi, quebra_linha
    mov rdx, 1
    call escrever

; Inicia o loop que aguarda a entrada do jogador com timeout.
.entrada_loop:
    mov rsi, instr
    mov rdx, tam_instr
    call escrever
    mov qword [select_fds], 0
    bts qword [select_fds], 0
    mov qword [timeout], 3
    mov qword [timeout + 8], 0
    mov rax, 23
    mov rdi, 1
    mov rsi, select_fds
    mov rdx, 0
    mov r10, 0
    mov r8, timeout
    syscall
    cmp rax, 0
    jle .tempo_esgotado
    call ler_entrada
    cmp al, 1
    je entrada_valida_estado
    jmp .entrada_loop


; Rotina executada quando o tempo do jogador se esgota.
.tempo_esgotado:
    mov rsi, msg_erro
    mov rdx, tam_msg_erro
    call escrever
    jmp fim_checa


; Rotina para processar uma entrada válida (acerto ou erro).
entrada_valida_estado:
    mov al, [entrada_jogador]
    cmp al, 'q'
    je encerrar
    cmp al, 'Q'
    je encerrar
    mov bl, [posicao_alvo]
    add bl, '0'
    cmp al, bl
    jne .erro
    inc dword [acertos_rodadas]
    movzx eax, byte [tipo_alvo]
    cmp al, 'S'
    je .add5
    add dword [pontuacao], 1
    jmp .acerto_msg

; Adiciona 5 pontos para um acerto em alvo especial.
.add5:
    add dword [pontuacao], 5

.acerto_msg:
    mov rsi, msg_acerto
    mov rdx, tam_msg_acerto
    call escrever
    jmp fim_checa

.erro:
    mov rsi, msg_erro
    mov rdx, tam_msg_erro
    call escrever

fim_checa:
    call delay_1s
    mov byte [estado_atual], RODADA_ENCERRADA
    jmp main_loop


; Estado 3: Transição entre rodadas, incrementa contador e faz contagem.
estado_encerrada:
    add dword [rodada_atual], 1
    mov eax, [rodada_atual]
    cmp eax, 11
    jge encerrar
    call contagem_regressiva
    mov byte [estado_atual], ESPERANDO_NOVA_RODADA
    jmp main_loop


; Rotina para quando o jogador digita 'q' para sair.
encerrar:
    mov byte [estado_atual], FIM_DE_JOGO
    jmp main_loop


; Estado 4: Exibe a pontuação final e encerra o programa.
fim_jogo:
    mov rsi, prefix_pontos
    mov rdx, tam_prefix_pontos
    call escrever
    mov eax, [pontuacao]
    mov rdi, num_buffer
    call imprime_inteiro
    mov rsi, rdi
    mov rdx, rax
    call escrever
    mov rsi, quebra_linha
    mov rdx, 1
    call escrever
    mov rsi, msg_acertos_prefix
    mov rdx, tam_acertos_prefix
    call escrever
    mov eax, [acertos_rodadas]
    mov rdi, num_buffer
    call imprime_inteiro
    mov rsi, rdi
    mov rdx, rax
    call escrever
    mov rsi, msg_acertos_suffix
    mov rdx, tam_acertos_suffix
    call escrever
    mov rsi, msg_fim
    mov rdx, tam_msg_fim
    call escrever
    mov rax, 60
    xor rdi, rdi
    syscall


; Função: Lê e valida a entrada do teclado.
ler_entrada:
    mov byte [entrada_jogador], 0
    mov byte [entrada_jogador+1], 0
    mov rax, 0
    mov rdi, 0
    mov rsi, entrada_jogador
    mov rdx, 4
    syscall
    cmp rax, 2
    jne entrada_invalida
    mov al, [entrada_jogador]
    cmp al, '1'
    jl entrada_invalida
    cmp al, '9'
    jle entrada_valida
    cmp al, 'q'
    je entrada_valida
    cmp al, 'Q'
    je entrada_valida

entrada_invalida:
    mov rsi, msg_invalida
    mov rdx, tam_msg_invalida
    call escrever
    mov al, 0
    ret

entrada_valida:
    mov al, 1
    ret


; Função: Escreve uma string na saída padrão (stdout).
escrever:
    mov rax, 1
    mov rdi, 1
    syscall
    ret


; Função: Exibe uma contagem regressiva na tela.
contagem_regressiva:
    mov rsi, msg_contagem_base
    mov rdx, tam_msg_contagem_base
    call escrever
    mov rsi, contagem_1
    mov rdx, tam_contagem_1
    call escrever
    call delay_1s
    mov rsi, contagem_2
    mov rdx, tam_contagem_2
    call escrever
    call delay_1s
    mov rsi, contagem_3
    mov rdx, tam_contagem_3
    call escrever
    call delay_1s
    mov rsi, quebra_linha
    mov rdx, 1
    call escrever
    ret


; Função: Utilitário para limpar a tela do terminal.
limpar:
    mov rsi, limpar_tela
    mov rdx, tam_limpar_tela
    call escrever
    ret


; Função: Converte um número inteiro (em EAX) para string.
imprime_inteiro:
    push rbx
    cmp eax, 0
    jne .continuar
    mov byte [rdi], '0'
    mov byte [rdi+1], 0
    mov rax, 1
    pop rbx
    ret


; Inicia a conversão para números diferentes de zero.
.continuar:
    mov rcx, 10
    xor rdx, rdx
    mov rbx, rdi
    add rbx, 11
    mov byte [rbx], 0
    mov rsi, rbx


; Loop que extrai cada dígito do número através da divisão.
.loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test eax, eax
    jnz .loop
    mov rax, rbx
    sub rax, rsi
    mov rdi, rsi
    pop rbx
    ret


; Função: Pausa a execução por 1 segundo.
delay_1s:
    mov rax, 35
    lea rdi, [rel tempo]
    xor rsi, rsi
    syscall
    ret