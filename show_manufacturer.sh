#!/bin/bash

##########################
# DEFINICAO DE VARIAVEIS #
##########################

# Informe aqui o caminho onde o script sera armazenado
# O arquivo com as definicoes da IANA sera armazenado no mesmo local
scrip_path=/Scripts/Scripts_Zabbix

# Informe aqui o caminho do arquivo de configuracao do Agente Zabbix
zabbix_conf=/usr/local/etc/zabbix_agentd.conf

# Informe aqui o nome da chave criada no Zabbix
zabbix_key=show_manufacturer

# ARmazena o nome do host, sera utilizado na funcao sender
host="$4"

########################
# DEFINICAO DE FUNCOES #
########################

# Funcao "iana"
# Verifica se o arquivo com OIDs Enterprise esta presente e atualizado.
# Caso contrario baixa o arquivo.

iana ()
{
if [ ! -s $scrip_path/iana.txt ]
then
        echo "Baixando lista de OIDs Enterprise da IANA, aguarde por favor ..."
        curl -s http://www.iana.org/assignments/enterprise-numbers/enterprise-numbers > $scrip_path/iana.txt
        echo " "
        echo "Processo finalizado"
else
        if [ `grep 'last updated' $scrip_path/iana.txt | cut -d" " -f3 | cut -d')' -f1` != `curl -s http://www.iana.org/assignments/enterprise-numbers/enterprise-numbers | head -3 | tail -1 | cut -d" " -f3 | cut -d')' -f1` ]
        then
                echo "Atualizando lista de OIDs Enterprise da IANA, aguarde por favor ..."
                curl -s http://www.iana.org/assignments/enterprise-numbers/enterprise-numbers > $scrip_path/iana.txt
                echo " "
                echo "Processo finalizado"
        fi
fi
}

# Funcao "oid"
# Recorta do OID a parte que contem o fabricante do equipamento
# Pesquisa o Fabricante no arquivo e retorna o valor encontrado

oid ()
{
oid=$(echo $snmp | cut -d ' ' -f2 | cut -d'.' -f8)
resultado=$(sed -n "/^$oid$/{n;p;}" $scrip_path/iana.txt | tr -s ' ' | cut -d' ' -f2-)
}

# Funcao "sender"
# Envia os dados para o equipamento atraves do zabbix_sender

sender ()
{
if [ -z "$resultado" ]
then
        zabbix_sender -s "$host" -k "$zabbix_key" -o "Fabricante nao encontrado" -r -c "$zabbix_conf" >> /dev/null
else
        zabbix_sender -s "$host" -k "$zabbix_key" -o "$resultado" -r -c "$zabbix_conf" >> /dev/null
fi
}

####################################
# COLETA DOS DADOS DOS EQUIPAMENTOS#
####################################

case $1 in
snmp_01)iana
        snmp=$(snmpget -Oqn -v1 -c "$2" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid
        sender
        fi
        ;;

snmp_02)iana
        snmp=$(snmpget -Oqn -v2c -c "$2" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid
        sender
        fi
        ;;
snmp_03)iana
        snmp=$(snmpget -Oqn -v3 -u "$2" -n "" -l noAuthNoPriv "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid
        sender
        fi
        ;;
snmp_04)iana
        snmp=$(snmpget -Oqn -v3 -u "$2" -n "" -l authNoPriv -a "$5" -A "$6" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid
        sender
        fi
        ;;
snmp_05)iana
        snmp=$(snmpget -Oqn -v3 -u "$2" -n "" -x "$7" -X "$8" -l authPriv -a "$5" -A "$6" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid
        sender
        fi
        ;;
*) echo "Uso: $0 snmp_01 \"comunidade\" \"IP\" \"Nome do Host no Zabbix\" - Para SNMP v1
Uso: $0 snmp_02 \"comunidade\" \"IP\" \"Nome do Host no Zabbix\" - Para SNMP v2c
Uso: $0 snmp_03 \"usuario\" \"IP\" \"Nome do Host no Zabbix\" - Para SNMP v3 noAuthNoPriv
Uso: $0 snmp_04 \"usuario\" \"IP\" \"Nome do Host no Zabbix\" \"tipo de hash\" \"<senha do hash>\" - Para SNMP v3 authNoPriv
Uso: $0 snmp_05 \"usuario\" \"IP\" \"Nome do Host no Zabbix\" \"tipo de hash\" \"<senha do hash>\" \"tipo de criptografia\" \"<senha da chave>\" - Para SNMP v3 authPriv"
esac
