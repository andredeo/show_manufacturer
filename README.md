<h1>show_manufacturer.sh</h1>

<h3>Script em Shell para descobrir qual é o fabricante do equipamento via consulta SNMP, de acordo com o objeto sysObjectID.0</h3>

<p>
Você pode utilizar os mesmos comandos que executa para coletar dados de seus equipamentos com as respectivas comunidades (SNMP v1/v2c) ou usuario/senha (SNMP v3). Quando transportar os comandos para o Script siga essa sequencia: a comunidade/usuario, o IP, o tipo de hash (MD5|SHA), a senha do hash (autenticação), o tipo de criptografia (AES|DES) e a senha da chave (criptografia).
</p>

<p><b>Exemplo de consulta SNMP v1:</b></p>
<p># snmpget -Oqn -v1 -c public 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v1:</b></p>
<p># ./show_manufacturer.sh snmp_01 public 192.0.2.1</p>
<br>
<p><b>Exemplo de consulta SNMP v2c:</b></p>
<p># snmpget -Oqn -v2c -c public 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v2c:</b></p>
<p># ./show_manufacturer.sh snmp_02 public 192.0.2.1</p>
<br>
<p><b>Exemplo de consulta SNMP v3 noAuthNoPriv</b></p>
<p># snmpget -Oqn -v3 -u noAuthUser -n "" -l noAuthNoPriv 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v3 noAuthNoPriv</b></p>
<p># ./show_manufacturer.sh snmp_03 noAuthUser 192.0.2.1</p>
<br>
<p><b>Exemplo de consulta SNMP v3 com AuthNoPriv</b></p>
<p># snmpget -Oqn -v3 -u initial -n "" -l authNoPriv -a MD5 -A 'setup_passphrase' 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v3 com AuthNoPriv</b></p>
<p># ./show_manufacturer.sh snmp_04 initial 192.0.2.1 MD5 'setup_passphrase'</p>
<br>
<p><b>Exemplo de consulta SNMP v3 com authPriv</b></p>
<p># snmpget -Oqn -v3 -u initial -n "" -x DES -X 'setup_passkey' -l authPriv -a MD5 -A 'setup_passphrase' 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v3 com AuthPriv</b></p>
<p># ./show_manufacturer.sh snmp_05 initial 192.0.2.1 MD5 'setup_passphrase' DES 'setup_passkey'</p>
