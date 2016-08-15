#!/bin/bash

########################
# DEFINICAO DE FUNCOES #
########################

# Funcao "iana"
# Verifica se o arquivo com OIDs Enterprise esta presente e atualizado.
# Caso contrario baixa o arquivo.

iana ()
{
if [ ! -s iana.txt ]
then
        echo "Baixando lista de OIDs Enterprise da IANA, aguarde por favor ..."
        curl -s http://www.iana.org/assignments/enterprise-numbers/enterprise-numbers > iana.txt
        echo " "
        echo "Processo finalizado"
else
        if [ `grep 'last updated' iana.txt | cut -d" " -f3 | cut -d')' -f1` != `curl -s http://www.iana.org/assignments/enterprise-numbers/enterprise-numbers | head -3 | tail -1 | cut -d" " -f3 | cut -d')' -f1` ]
        then
                echo "Atualizando lista de OIDs Enterprise da IANA, aguarde por favor ..."
                curl -s http://www.iana.org/assignments/enterprise-numbers/enterprise-numbers > iana.txt
                echo " "
                echo "Processo finalizado"
        fi
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
        oid=$(echo $snmp | cut -d ' ' -f2 | cut -d'.' -f8)
        sed -n "/^$oid$/{n;p;}" iana.txt | tr -s ' ' | cut -d' ' -f2
        fi
        ;;
snmp_02)iana
        snmp=$(snmpget -Oqn -v2c -c "$2" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid=$(echo $snmp | cut -d ' ' -f2 | cut -d'.' -f8)
        sed -n "/^$oid$/{n;p;}" iana.txt | tr -s ' ' | cut -d' ' -f2
        fi
        ;;
snmp_03)iana
        snmp=$(snmpget -Oqn -v3 -u "$2" -n "" -l noAuthNoPriv "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid=$(echo $snmp | cut -d ' ' -f2 | cut -d'.' -f8)
        sed -n "/^$oid$/{n;p;}" iana.txt | tr -s ' ' | cut -d' ' -f2
        fi
        ;;
snmp_04)iana
        snmp=$(snmpget -Oqn -v3 -u "$2" -n "" -l authNoPriv -a "$4" -A "$5" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid=$(echo $snmp | cut -d ' ' -f2 | cut -d'.' -f8)
        sed -n "/^$oid$/{n;p;}" iana.txt | tr -s ' ' | cut -d' ' -f2
        fi
        ;;
snmp_05)iana
        snmp=$(snmpget -Oqn -v3 -u "$2" -n "" -x "$6" -X "$7" -l authPriv -a "$4" -A "$5" "$3" sysObjectID.0)
        if [ $? -eq 0 ]
        then
        oid=$(echo $snmp | cut -d ' ' -f2 | cut -d'.' -f8)
        sed -n "/^$oid$/{n;p;}" iana.txt | tr -s ' ' | cut -d' ' -f2
        fi
        ;;
*) echo "Uso: ./$0 snmp_01 \"comunidade\" \"IP\" - Para SNMP v1
Uso: ./$0 snmp_02 \"comunidade\" \"IP\" - Para SNMP v2c
Uso: ./$0 snmp_03 \"usuario\" \"IP\" - Para SNMP v3 noAuthNoPriv
Uso: ./$0 snmp_04 \"usuario\" \"IP\" \"tipo de hash\" \"<senha do hash>\" - Para SNMP v3 authNoPriv
Uso: ./$0 snmp_05 \"usuario\" \"IP\" \"tipo de hash\" \"<senha do hash>\" \"tipo de criptografia\" \"<senha da chave>\" - Para SNMP v3 authPriv"
esac
