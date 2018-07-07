#Vou pegar algum valor aqui em v0 que seja 1<=v0<=100
#iniciar s0 como 1 e ir subindo ate esse valor, while(s0<v0){faca isso)


.data
	newline: .asciiz "\n"
	str: .asciiz "Numero invalido"

.text

	.globl main


#Funcao M-> 
M:	addi $sp, $sp, -4  #Gera uma casa na pilha
	sw $ra, 0($sp)	   #Coloca atual endereco de retorno na pilha

#if(n<=100)
M2:	slti $t0, $a3, 101 #Verifica se o n<=100 
	bne $t0, $zero, if #Se o valor de t0 nao for igual a 0 ele pula para o if 
	
#return n - 10;
	addi $a3, $a3, -10 #Faz o argumento -10 para a proxima funcao ja ter computado
	jr $ra		  
	
if:	addi $a3, $a3, 11  #Mudo o argumento, para o valor do argumento + 11 
	jal M2
	jal M2
	lw $ra, 0($sp)
	addi $sp, $sp, 4  #Destruo a parte da pilha que eu acabei de usar
	jr $ra	 	   #Retorna o ultimo endereco salvo

#Bloco main->
main:	
	addi $s0, $zero, 1    #Coloco o valor 1 para s0 que servira para ir ate o valor recebido
	li $v0, 5	          # codigo para ler um inteiro
	syscall		          # executa a chamada do SO para ler
	slti $t0, $v0, 1	  #Vamos verificar se temos o valor <1
	bne $t0, $zero, erro  #t0 != 0
	slti $t1, $v0, 101    #Vamos verificar se temos o valor <=100
	beq $t1, $zero, erro  #Se for negativo, pula tambem

	addi $s1, $v0, 1      #Salva o valor daquilo passado + 1 para poder deixar menor igual (<= v0)
	j L1		          #Vai testar o while

#Caso entre no while

while:	
	add $a3, $s0, $zero   #Passa o valor para o argumento da funcao
	addi $s0, $s0, 1
	jal M		          #vai executar a funcao
	li $v0, 1		      # codigo para imprimir um inteiro
	la $a0, ($a3)	      # $a3 eh o registrador que ira conter o valor a ser impresso
	syscall		          # executa a chamado do SO para imprimir
	li $v0, 4             # you can call it your way as well with addi 
	la $a0, newline       # load address of the string
	syscall

L1:	slt $t1, $s0, $s1     #Verificamos se o nosso valor de entrada ainda e maior ou igual a s1
	bne $t1, $zero, while #Caso seja maior, vamos para o while
	li $v0, 10			  #salvando comando de saida
	syscall

erro:
	li $v0, 4 			   #print mensagem de erro
	la $a0, str 
	syscall
	li $v0, 10
	syscall