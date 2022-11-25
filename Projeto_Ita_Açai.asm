#Bruna Keila Oliveira Santos
#Eduardo Santos Santana Bispo
#Luis Gabriel Costa Lima
#Janaina Ferreira Santos
.data
	nome: .space 25
	msgpedido: .asciiz "\n\nDigite o complemento escolhido: "
	pedido: .space 21
	complemento: .asciiz "\n--------COMPLEMENTOS--------\nAmendoim        Kiwi\nBanana          Raspas de chocolate\nBis             Nutella\ncastanha        Leite em po\nCereja          Gotas de chocolate\nConfete         Creme de chocolate\nCreme de limao\nCreme de morango\nMorango"
	menu: .asciiz "\n   Menu\nEscolha o tamanho:\n 1 - P (3 Complementos) R$ 10\n 2 - M (4 Complementos) R$ 12\n 3 - G (5 complementos) R$ 16\n"
	inicio: .asciiz "*****************************\n    ___   _________    ____\n   /   | / ____/   |  /  _/\n  / /| |/ /   / /| |  / /  \n / ___ / /___/ ___ |_/ /   \n/_/  |_\\____/_/  |_/___/   \n        /_)                \n*****************************\nInforme o nome para nota fiscal: "
	maisComplemento: .asciiz "\nDeseja adicionar mais complementos?\n1 - Sim (R$ 4.0 cada adicional)\n0 - NAO\n"
	falaComp: .asciiz "\nComplementos:\n\n"
	falaCompAdd: .asciiz "\nComplementos Adicionais:\n\n"
	tam1: .asciiz "\nTamanho escolhido -- Pequeno\n" 
	tam2: .asciiz "\nTamanho escolhido -- Medio\n"
	tam3: .asciiz "\nTamanho escolhido -- Grande\n"
	compPrice: .float 4.0
	zero: .float 0.0 #Caso seja necessario formatar o valor
	grande: .float 16.0
	medio: .float 12.0
	pequeno: .float 10.0
	linhaNova: .asciiz "\n"
	conteudoArq: .asciiz "Nota fiscal\n\nCliente: "
	localArq: .asciiz "nota.txt"
	quantidade: .asciiz "\nQuantos acais voce deseja?\n"
	teste: .asciiz " "
	cont: .word 0
	finalizar: .asciiz "\n\nO valor total da compra foi de: R$ "
.text
	#O valor total da conta do cliente esta sendo guardado em '$t9'
	
	#Imprime o nome acai, pede nome do cliente
	li $v0, 4
	la $a0, inicio
	syscall
	
	#Le o nome do cliente
	li $v0, 8
	la $a0, nome
	la $a1, 25
	syscall
	
	#Abre o arquivo -> nome /n
	li $v0, 13
	la $a0,localArq
	li $a1,1 #Indica modo escrita
	syscall
	
	move $s0, $v0 # coloca $s0 como descritor do meu arq
	
	li $v0, 15
	#Descritor tem que estar em $a0
	#Escreve no aqr
	move $a0, $s0
	la $a1, conteudoArq
	li $a2, 22
	syscall
	
	#Escreve o nome no arquivo
	li $v0,15 
	move $a0, $s0 
	la $a1, nome
	la $a2, 25
	syscall
	
	li $v0,15 
	move $a0, $s0 
	la $a1, linhaNova
	la $a2, 1
	syscall
	
	#imprime fala de quantidade
	la $a0, quantidade
	li $v0, 4
	syscall
		
	#le a quantidade escolhida
	li $v0 5
	syscall
	
	move $s7, $v0
	
	whileAca:
	
	#Imprime o menu
	li $v0, 4
	la $a0, menu
	syscall
	
	#Le o tamanho escolhido
	li $v0, 5
	syscall
	
	#Move o tamanho escolhido para o resgistrador $t0
	move $t0, $v0
	li $v0, 1
	la $a0, ($t0)
	syscall
	
	#Imprime lista de complementos
	li $v0, 4
	la $a0, complemento
	syscall
	
	#Testa se o tamanho escolhido foi o 1
	teste_1:bne $t0, 1, teste_2
		addi $t2, $zero, 3
		
		#Adiciona o valor do acai a $t6 para calcular o total a pagar, registradores no co-processador 1, por isso o 'c1'
		lwc1 $f1, pequeno
		
		#Calculo total do valor vai ser colocado em $f12 para facilitar salvar no arquivo e imprimir na tela
		add.s $f12, $f1, $f12
		
		li $v0,15 
		move $a0, $s0 
		la $a1, tam1
		la $a2, 30
		syscall
	
		li $v0,15 
		move $a0, $s0 
		la $a1, falaComp
		la $a2, 16
		syscall
		
		#Laco para pedir o complemento 3 vezes
		while_1:beq $t2, 0, sai_teste 
			#Imprime mensagem pedindo o complemento
			li $v0, 4
			la $a0, msgpedido
			syscall
	
			#Le o complemento escolhido
			li $v0, 8
			la $a0, pedido
			la $a1, 21
			syscall
			#Salva no arquivo
			li $v0,15 
			move $a0, $s0 
			la $a1, pedido
			la $a2, 21
			syscall
			
			#Limpando o que tem em pedido
			la $t6, pedido
			la $t4, teste
			add $t7, $zero, 1
			limpa1: bge $t7, 20, continue1
				
				lb $t5, 0($t4)
				sb $t5, ($t6)
				addi $t6, $t6, 1
				addi $t7, $t7, 1
				j limpa1
			continue1: 			
			li $v0,15 
			move $a0, $s0 
			la $a1, linhaNova
			la $a2,1
			syscall
			
			subi $t2, $t2, 1
			j while_1
	
	#Testa se o tamanho escolhido foi o 2
	teste_2:bne $t0, 2, teste_3
		addi $t2, $zero, 4
		
		#Adiciona o valor do a�ai a $f1 para calcular o total a pagar, registradores no co-processador 1, por isso o 'c1'
		lwc1 $f1, medio
		
		#Calculo total do valor vai ser colocado em $f12 para facilitar salvar no arquivo e imprimir na tela
		add.s $f12, $f1, $f12
		
		#Escreve no arquivo o tamanho 
		li $v0,15 
		move $a0, $s0 
		la $a1, tam2
		la $a2, 29
		syscall
	
		li $v0,15 
		move $a0, $s0 
		la $a1, falaComp
		la $a2, 16
		syscall
		
		#Laco para pedir o complemento 4 vezes
		while_2:beq $t2, 0, sai_teste 
			#Imprime mensagem pedindo o complemento
			li $v0, 4
			la $a0, msgpedido
			syscall
	
			#Le o complemento escolhido
			li $v0, 8
			la $a0, pedido
			la $a1, 21
			syscall
			
			#Salva no arquivo
			li $v0,15 
			move $a0, $s0 
			la $a1, pedido
			la $a2, 21
			syscall
			
			#Limpando o que tem em pedido
			la $t6, pedido
			la $t4, teste
			add $t7, $zero, 1
			limpa2: bge $t7, 20, continue2
				
				lb $t5, 0($t4)
				sb $t5, ($t6)
				addi $t6, $t6, 1
				addi $t7, $t7, 1
				j limpa2
			continue2: 			
			li $v0, 15 
			move $a0, $s0 
			la $a1, linhaNova
			la $a2,1
			syscall
		
			subi $t2, $t2, 1
			j while_2
	
	#Testa se o tamanho escolhido foi o 3
	teste_3:bne $t0, 3, sai_teste
		addi $t2, $zero, 5
		
		#Adiciona o valor do açai a $f1 para calcular o total a pagar, registradores no co-processador 1, por isso o 'c1'
		lwc1 $f1, grande
		
		#Calculo total do valor vai ser colocado em $f12 para facilitar salvar no arquivo e imprimir na tela
		add.s $f12, $f1, $f12
		
		#Escreve no arquivo o tamanho 
		li $v0,15 
		move $a0, $s0 
		la $a1, tam3
		la $a2, 30
		syscall
	
		li $v0,15 
		move $a0, $s0 
		la $a1, falaComp
		la $a2, 16
		syscall
		
		#Laco para pedir o complemento 5 vezes
		while_3:beq $t2, 0, sai_teste 
			#Imprime mensagem pedindo o complemento
			li $v0, 4
			la $a0, msgpedido
			syscall
	
			#Le o complemento escolhido
			li $v0, 8
			la $a0, pedido
			la $a1, 21
			syscall
			
			#Salva no arquivo
			li $v0,15 
			move $a0, $s0 
			la $a1, pedido
			la $a2, 21
			syscall
			
			#Limpando o que tem em pedido
			la $t6, pedido
			la $t4, teste
			add $t7, $zero, 1
			limpa3: bge $t7, 20, continue3
				
				lb $t5, 0($t4)
				sb $t5, ($t6)
				addi $t6, $t6, 1
				addi $t7, $t7, 1
				j limpa3
			continue3: 					
			li $v0,15 
			move $a0, $s0 
			la $a1, linhaNova
			la $a2, 1
			syscall
			
			subi $t2, $t2, 1
			j while_3
	
	sai_teste:
	
	#Pergunta se a pessoa quer mais complementos(adcionais)
	li $v0, 4
	la $a0, maisComplemento
	syscall
	
	#le resposta
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	bne $t0, 1, complementos
		#Imprime lista de complementos
		li $v0, 4
		la $a0, complemento
		syscall
		
		#Carrega o valor de um complemento adicional
		lwc1 $f2, compPrice
		
		li $v0,15 
		move $a0, $s0 
		la $a1, falaCompAdd
		la $a2, 27
		syscall
		
		while_comp:
			#Imprime mensagem pedindo o complemento
			li $v0, 4
			la $a0, msgpedido
			syscall
	
			#Le o complemento escolhido
			li $v0, 8
			la $a0, pedido
			la $a1, 21
			syscall
			
			#Escreve o pedido adicional
			li $v0,15 
			move $a0, $s0 
			la $a1, pedido
			la $a2, 21
			syscall
			
			#Limpando o que tem em pedido
			la $t6, pedido
			la $t4, teste
			add $t7, $zero, 1
			limpa4: bge $t7, 20, continue4
				
				lb $t5, 0($t4)
				sb $t5, ($t6)
				addi $t6, $t6, 1
				addi $t7, $t7, 1
				j limpa4
			continue4: 		
			
			li $v0,15 
			move $a0, $s0 
			la $a1, linhaNova
			la $a2,1
			syscall
			
			#Soma a conta
			add.s $f12, $f12, $f2
						
			subi $t2, $t2, 1
			
			#Pergunta se quer mais complementos(adcionais)
			li $v0, 4
			la $a0, maisComplemento
			syscall
	
			#le resposta
			li $v0, 5
			syscall
	
			move $t0, $v0
			
			beq $t0, 0, complementos
				j while_comp
	complementos:
	
		addi $s7, $s7, -1
		beq $s7, $zero, sai_whileAca
			j whileAca
	sai_whileAca:
		
		#Imprime o total da compra
		li $v0, 4
		la $a0, finalizar
		syscall
		
		li $v0, 2
		syscall
		
	#fecha o ARQUIVO
	li $v0, 16
	move $a0, $s0
	syscall
	#Return 0
	li $v0, 10
	syscall
