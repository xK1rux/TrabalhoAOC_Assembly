.data 
	msg1: .asciiz "\nDigite um número que deseja saber se é octal ou não: "
	msg2: .asciiz "\nDigite um número positivo: "
	msg3: .asciiz "\nO seu número não é octal"
	msg4: .asciiz "\nO seu número é octal"
.text
main:
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 5
	syscall
	blt $v0, 0, negativo		#verificação se o número é negativo 
	j positivo
	
 negativo:
 	li $v0, 4
 	la $a0, msg2
 	syscall
 	li $v0, 5
 	syscall
 	blt $v0, 0, negativo		#repetição enquanto o número for negativo
 	
 positivo:
	add $t0, $v0, 0		#numero recebido
	li $t9, 10		#contador para descobrir o tamanho do numero recebido
	blt $t0, 10, menor10
	
enquanto: 
	blt $t0, $t9, fimenquanto
	mul $t9, $t9, 10	#aumentando um digito para descobrir o tamanho do numero
	add $t8, $t8, 1 	#contador de digitos aumentados
	j enquanto
fimenquanto:
	
	sub $t8, $t8, 1		#descobrindo quantas vezes deve multiplicar para o divisor correto
	li $t9, 10
	
divisor:
	blt $t8, 0, fimdivisor
	beq $s7, $t8, fimdivisor
	mul $t9, $t9, 10	#encontrando o divisor correto
	add $s7, $s7, 1 
	j divisor
fimdivisor:
	
maior10:
	div $t1, $t0, $t9	
	beq $t1, 8, naooctal
	beq $t1, 9, naooctal	#verificando se o resultado da divisão é 8 ou 9
	rem $t0, $t0, $t9
menor10:
	beq $t0, 8, naooctal
	beq $t0, 9, naooctal	#vericando se o resto da divisão é 8 ou 9
	blt $t0, 10, octal	#se o resultado e o resto forem diferentes de 8 e 9, e menores que 10, o numero é octal

divideD:
	div $t9, $t9, 10	#encontrando o novo divisor correto
	bgt $t0, $t9, maior10	#se o resto for maior q o divisor atual volta para as verificações
	j divideD

naooctal:
	li $v0, 4
	la $a0, msg3	#numero não octal
	syscall
	j fim

octal:
	li $v0, 4
	la $a0, msg4	#numero octal
	syscall
	
fim: