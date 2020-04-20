#!/bin/bash
# usuarios.sh
#
# Mostra o login e nomes de usuários no sistema
# Obs: Lê os dados do arquivo /etc/passwd
#
# Versão 1.0: Mostra usuários e nomes separados por TAB
# Versão 1.2: Adicionando suporte à opção -h e -V
# Versão 1.3: Ajustando para o correr o processamento caso não tenha argumentos
# Versão 1.4: Informar a ultima versão automaticamente
# Versão 1.5: Adicionadas flags s ou --sort para ordenar a lista
# Versão 1.6: Adicionadas as flags -uppercase e -reverse
#	      -reverse para saída em modo reverso
#	      -uppercase para saída em letras maiúsculas
#
# Rafael, abril de 2020
# rafael.b.leite@outlook.com
#

MENSAGEM_USO="
	Uso: $(basename "$0") [OPÇÕES]

	OPÇÕES:
	-r, --reverse	 Inverte a listagem
	-s, --sort	 Ordena a listagem alfabeticamente
	-u, --uppercase  Listagem em letras maiúsculas

	-h	Monstra tela de ajuda e sai
	-V	Mostra a versão do programa e sai
"

ordenar=0	# A saída deverá ser ordenada?
uppercase=0 	# A saída deverá ser em letras maiúsculas?
reverse=0 	# A saída deverá ser reversa?

#Tratamento das opções da linha de comando
while test -n "$1"
do
 case "$1" in

	-h|--help)
		echo "$MENSAGEM_USO"
		exit 0
		;;
	-V|--version)
		echo -n $(basename "$0")
		# Extrai a versão diretamente do cabeçalho
		grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \# 
		exit 0
	;;
	#Opções que ligam/desligam chaves
	-s | --sort ) ordenar=1 ;;
	-u | --uppercase ) uppercase=1 ;;
	-r | --reverse ) reverse=1 ;;

	*)
	if test -n "$1"
	then
		echo Opção [$1] é inválida. 
		exit 1
	fi
	;;
 esac
#Opção $1 processada, segue o proximo da fila em $1
shift
done

# Extrai a listagem
lista=$(cut -d : -f 1,5 /etc/passwd)

# Ordena, inverte ou converte para maiúsculas (se necessário)
test "$ordenar" = 1 && lista=$(echo "$lista" | sort)
test "$uppercase" = 1 && lista=$(echo "$lista" | tr a-z A-Z)
test "$reverse" = 1 && lista=$(echo "$lista" | tac)

# Mostra o resultado ao usuário
echo "$lista" | tr : //t


