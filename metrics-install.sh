#!/bin/sh
#
# versao 0.1
#
# NOME
#   metrics-install.sh
#
# DESCRICAO
#   Instala o aplicativo Metrics
#
# NOTA
#   Sobe os containers responsável por deixar o aplicativo funcionando
#
#
#  MODIFICADO_POR  (DD/MM/YYYY)
#  daniel.silva     31/12/2017 - Implementada a Função para subir os containers
#                                docker do metrics e mysql e função para execução
#                                de script SQL
#


####################################################################################
####################################################################################
#                                                                                  #
#                                                                                  #
#                            Bloco de Variaveis                                    # 
#                                                                                  #
#                                                                                  #
####################################################################################



####################################################################################
####################################################################################
#                                                                                  #
#                                                                                  #
#                             Bloco de Funções                                     # 
#                                                                                  #
#                                                                                  #
####################################################################################

function dockerMysql(){
    passRoot=$1
    user=$2
    pass=$3

    docker run -d --name banco \ 
        -e "MYSQL_ROOT_PASSWORD=$passRoot" \
        -e "MYSQL_DATABASE=metrics" \
        -e "MYSQL_USER=$user" \
        -e "MYSQL_PASSWORD=$pass" \
        mysql
}

function dockerMetrics(){
    pass=$2
    user=$1
    docker run -d --name metrics \
        --link banco:banco \
        -p 8085:80 \
        -e "DB_USER=$user" \
        -e "DB_PASS=$pass" \
        silva01/metrics:beta-1.31
}

function sqlExec(){
    user=$1
    pass=$2

    docker exec banco -e "mysql -u $user -p $pass metrics < exec.sql"
}



####################################################################################
####################################################################################
#                                                                                  #
#                                                                                  #
#                            Bloco de execução                                     # 
#                                                                                  #
#                                                                                  #
####################################################################################


if [ -z $1 ] && [ -z $2 ] && [ -z $3 ];then
    echo "Informe os seguintes parametros em ordem \n"
    echo " 1 - rootPassword  2 - Usuário da base de dados 3 - Senha da base de dados"
    exit
fi

rootPass=$1
dbUser=$2
dbPass=$3

echo "Criando Container MySQL"
dockerMysql $rootPass $dbUser $dbPass
echo "Pronto!"

echo "Criando container do Metrics"
dockerMetrics $dbUser $dbPass
echo "Pronto!"

echo "Carregando os usuários iniciais e outras configurações"
sqlExec
echo "Pronto!"
echo "Instalação Realizada com Sucesso"