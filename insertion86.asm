global main
extern gets
extern printf
extern fopen
extern fread

section  .data
    msjPedirMayorOMenor             db "Ingrese 0 para ordenar la lista de menor o mayor. Ingrese 1 para ordenarla de mayor a menor ",10,0
    msjMayorAMenor                  db "La lista sera ordenada de mayor a menor",10,0
    msjMenorAMayor                  db "La lista sera ordenada de mayor a menor y luego sera invertida",10,0
    msjError                        db  "No se pudo abrir el archivo. ",0
    fileName                        db  "Lista",0
    modo                            db "r",0
    msjAperturaOk                   db "El archivo se abrio correctamente. La lista es: ",10,0
    msjEOF                          db  "Se termino de leer el file.",10,0
    posicionActualVector            db 0
    lengthLista                     db 0
    msjNumero                       db "%i  ",0
    msjNumeroNegativo               db "-%i  ",0
    msjNuevaLinea                   db "",10,0
    msjFinIteracion                 db "Termina la iteracion ",10,0
    msjComienzoInsercion            db "Comienzo insercion",10,0
    msjSwapA                        db "Se esta cambiando el ",0
    msjSwapB                        db "por el ",0
    msjComparacionA                 db "Se estan comparando el elemento en la posicion %i (  ",0
    msjComparacionB                 db ") y el de la posicion %i (  ",0
    msjComparacionC                 db  ")",10,0
    msjIteraciones                  db 10,"Comienza la iteracion numero %i del algoritmo de insercion: ",10,0
    msjJ                            db "Ahora j = %i",10,0
    msjListaVacia                   db "La lista cargada esta vacia. Fin del programa",10,0
    msjFinOrdenamiento              db "La lista ya fue ordenada. La lista es:",10,0
    msjFinPrograma                  db "Fin del programa",10,0
    msjFinIteracionComparacion      db "Los elementos no deben ser swappeados asi que termina la iteracion",10,0



section  .bss
    indicadorOrientacionLista    resb 1
    byteActual                   resb 1
    idArchivo                    resb 10
    lista                        resb 30
    j                            resb 1

section  .text

main:
    jmp AbrirArchivo

AbrirArchivo:
    mov rcx, fileName
    mov rdx, modo
    call fopen
    cmp rax, 0
    jg  AperturaOk
    mov rcx, msjError
    call printf
    jmp finListaVacia
    
AperturaOk:
    mov rcx, msjAperturaOk
    mov qword[idArchivo], rax
    call printf

read:
    mov rcx, byteActual
    mov rdx, 1
    mov r8, 1
    mov r9, [idArchivo]
    sub rsp, 32
    call fread
    add rsp, 32
    cmp		rax,0			
	jle		eof
    jmp agregarElementoAlVector

eof:
    cmp byte[lengthLista], 0
    je finListaVacia
    mov rcx, msjNuevaLinea
    call printf
    mov rcx, msjEOF
    call printf
    jmp PedirDigito

;pre: el numero a imprimir debe estar guardado en r14b
imprimirNumero:
    mov rcx, msjNumero
    mov rdx, 0
    mov dl, r14b
    sub rsp, 32
    call printf
    add rsp, 32
    ret

;pre: el numero a imprimir debe estar guardado en r14b
imprimirComplemento:

    mov rdx, 0
    mov dl, r14b
    neg dl
    mov rcx, msjNumeroNegativo
    sub rsp, 32
    call printf
    add rsp, 32
    ret 

agregarElementoAlVector:

    mov rbx, 0
    mov edi, lista
    mov bl, byte[posicionActualVector]
    mov r12b, byte[byteActual]
    mov [edi + ebx], r12b
    inc byte[posicionActualVector]
    inc byte[lengthLista]
    cmp r12b, 127 ;Vemos si el numero leido es negativo 
    mov r14b, r12b
    push read
    jbe imprimirNumero
    ja imprimirComplemento

PedirDigito:

    mov rcx, msjPedirMayorOMenor
    sub rsp, 32
    call printf
    add rsp, 32
    mov rcx, indicadorOrientacionLista
    call gets
    

verificarDigitoIngresado:

    cmp byte[indicadorOrientacionLista], "0"
    je MenorAMayor

    cmp byte[indicadorOrientacionLista], "1"
    je MayorAMenor

    jmp PedirDigito

MenorAMayor:
    mov rcx, msjMenorAMayor
    call printf
    jmp Ordenar

MayorAMenor:
    mov rcx, msjMayorAMenor
    call printf
    jmp Ordenar

finListaVacia:
    mov rcx, msjListaVacia
    call printf
    jmp final
Ordenar:
    mov rbx, 0
    mov edi , lista
    mov byte[posicionActualVector], 1
    ;Lo que seria el ciclo de i
cicloExterno:
    mov bl, byte[posicionActualVector] ;bl = i
    cmp bl, byte[lengthLista]
    jge finOrdenamiento
imprimirMensajeComienzoIteracion:
    mov rcx, msjIteraciones
    mov rdx, 0
    mov dl, bl
    sub rsp, 32
    call printf
    add rsp, 32

cicloJ:
    mov byte[j], bl
    mov rcx, msjJ
    mov rdx, 0
    mov dl, byte[j]
    sub rsp, 32
    call printf
    add rsp, 32
    jmp cargarElementosDeLaLista

finCicloExterno:
    mov rcx, msjFinIteracion
    sub rsp, 32
    call printf
    add rsp, 32
    inc byte[posicionActualVector]
    jmp cicloExterno

cargarElementosDeLaLista:
    mov dl, bl
    mov r12b, byte[edi + ebx]
    dec bl
    mov r13b, byte[edi + ebx]

imprimirComparacion:

    mov rcx, msjComparacionA
    mov rdx, 0
    mov dl, bl
    inc dl
    call printf
    cmp r12b, 0
    mov r14b, r12b
    push imprimirComparacionB
    jl imprimirComplemento
    jge imprimirNumero

imprimirComparacionB:

    mov rcx, msjComparacionB
    mov rdx, 0
    mov dl, bl
    sub rsp, 32
    call printf
    add rsp, 32
    cmp r13b, 0
    mov r14b, r13b
    push imprimirComparacionC
    jl imprimirComplemento
    jge imprimirNumero

imprimirComparacionC:

    mov rcx, msjComparacionC
    sub rsp, 32
    call printf
    add rsp, 32

comparacionDeElementos:

    cmp r12b, r13b
    jg imprimirSwapA
    mov rcx, msjFinIteracionComparacion
    sub rsp, 32
    call printf
    add rsp, 32
    inc byte[posicionActualVector]
    jmp cicloExterno ;Si el elemento en j no debe ser swappeado por j-1, tampoco debera ser swapeado por j-2. Incremento i

imprimirSwapA:

    mov rcx, msjSwapA
    sub rsp, 32
    call printf
    add rsp, 32
    mov r14b, r12b
    cmp r12b, 0
    
    push imprimirSwapB
    jl imprimirComplemento
    jge imprimirNumero

imprimirSwapB:

    mov rcx, msjSwapB
    sub rsp, 32
    call printf
    add rsp, 32
    cmp r13b, 0
    mov r14b, r13b
    push swap
    jl imprimirComplemento
    jge imprimirNumero

swap:
    mov rcx, msjNuevaLinea
    call printf
    mov byte[edi + ebx], r12b
    inc bl
    mov byte[edi + ebx], r13b
    dec bl
    mov rcx, msjJ
    mov rdx, 0
    mov dl, bl
    
    sub rsp, 32
    call printf
    add rsp, 32
    cmp bl, 0
    je finCicloExterno
    jmp cargarElementosDeLaLista

finOrdenamiento:

    mov rcx, msjFinOrdenamiento
    call printf
    mov byte[posicionActualVector], 0
    mov edi, lista
    mov rbx, 0
    mov r15b, byte[posicionActualVector]
    cmp byte[indicadorOrientacionLista], "1"
    je imprimirLista
    mov r15b, byte[lengthLista]
    dec r15b
    jmp imprimirLista
    
imprimirLista:
    mov r14, 0
    mov bl, r15b
    mov r14b, byte[edi + ebx]

    push IncrementarIndiceLista
    cmp r14b, 0
    jl imprimirComplemento
    jge imprimirNumero

IncrementarIndiceLista:
    cmp byte[indicadorOrientacionLista], "1"
    je imprimirListaMayor
    jmp imprimirListaMenor
imprimirListaMayor:
    inc r15b
    cmp r15b, byte[lengthLista]
    je finPrograma
    jmp imprimirLista
imprimirListaMenor:
    dec r15b
    cmp r15b, 0
    je finPrograma
    jmp imprimirLista

finPrograma:
    mov rcx, msjNuevaLinea
    call printf
    mov rcx, msjFinPrograma
    call printf
    
final:
