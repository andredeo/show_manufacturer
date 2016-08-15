<h1>show_manufacturer.sh</h1>

<h3>Script em Shell para descobrir qual é o fabricante do equipamento via consulta SNMP, de acordo com o objeto sysObjectID.0</h3>

<p>
Você pode utilizar os mesmos comandos que executa para coletar dados de seus equipamentos com as respectivas comunidades (SNMP v1/v2c) ou usuario/senha (SNMP v3). Quando transportar os comandos para a secao de "coleta de dados" do Script, coloque o comando entre "$()" e substitua a comunidade/usuario por "$2", IP por "$3", a senha da chave (opcional) por "$4" e a senha do hash (opcional) por "$5".
</p>

<p><b>Exemplo de consulta SNMP v1:</b></p>
<p># snmpget -Oqn -v1 -c public 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta SNMP v2c:</b></p>
<p># snmpget -Oqn -v2c -c public 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de SNMP v3 noAuthNoPriv</b></p>
<p># snmpget -Oqn -v3 -u noAuthUser -n "" -l noAuthNoPriv 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de SNMP v3 com AuthNoPriv</b></p>
<p># snmpget -Oqn -v3 -u initial -n "" -l authNoPriv -a MD5 -A 'setup_passphrase' 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de SNMP v3 com authPriv</b></p>
<p># snmpget -Oqn -v3 -u initial -n "" -x DES -X 'setup_passkey' -l authPriv -a MD5 -A 'setup_passphrase' 192.0.2.1 sysObjectID.0</p>
