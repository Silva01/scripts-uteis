
#!/bin/sh
#
# versao 0.1
#
# NOME
#   metricas.sh
#
# DESCRICAO
#   Gerador de métricas de estudos
#
# NOTA
#   Grava os dados em um arquivo csv
#
#
#  MODIFICADO_POR  (DD/MM/YYYY)
#  daniel.silva     16/12/2017 - Implementada a função createArq que cria um arquivo
#                                caso esse arquivo não exista
#  daniel.silva     16/12/2017 - Implementada a função createMetricas, que insere
#                                os dados informados por parametros em no arquivo
#                                gerado pelo usuário
#


####################################################################################
####################################################################################
#                                                                                  #
#                                                                                  #
#                            Bloco de Variaveis                                    # 
#                                                                                  #
#                                                                                  #
####################################################################################

materias[0]="Português"
materias[1]="Direito Constitucional"
materias[2]="Direito Administrativo"
materias[3]="Raciocinio Logico"
materias[4]="Outros"

####################################################################################
####################################################################################
#                                                                                  #
#                                                                                  #
#                             Bloco de Funções                                     # 
#                                                                                  #
#                                                                                  #
####################################################################################

function createArq() {
    _name_arq=$1
    
    echo "Total Questões;Acertos;Erros;Data;Materia;Aproveitamento" > "$_name_arq.csv"
    echo "Terminado!"
}


function createMetricas() {
    _total_quest=$1
    _total_acert=$2
    _materia=$3
    _name_arq=$4

    _erros=$((_total_quest-_total_acert))

    echo "$_total_quest;$_total_acert;$_erros;$(date +%d/%m/%Y);$_materia" >> "$_name_arq.csv"
}


####################################################################################
####################################################################################
#                                                                                  #
#                                                                                  #
#                            Bloco de execução                                     # 
#                                                                                  #
#                                                                                  #
####################################################################################


echo "Você deseja começar um novo arquivo? (sim/nao)"
read new_arq

if [ $new_arq == "sim" ];then
    echo "Qual o nome do arquivo a ser criado?"
    read name_arq
    createArq $name_arq
elif [ $new_arq == "nao" ];then
    
    echo "Qual o nome do arquivo para registro"
    read name_register_arq    

    echo "Quantas questões foram respondidas por você?"
    read total_quest

    echo "Quantas questões você acertou?"
    read total_acert

    echo "Qual a matéria das questões?"
    echo "(0) Português"
    echo "(1) Direito Constitucional"
    echo "(2) Direito Administrativo"
    echo "(3) Raciocinio logico"
    echo "(4) Outros"
    read materia

    createMetricas $total_quest $total_acert ${materias[$materia]} $name_register_arq
fi



