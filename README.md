<h1>show_manufacturer.sh</h1>

<h3>Script em Shell para descobrir qual é o fabricante do equipamento via consulta SNMP, de acordo com o objeto sysObjectID.0</h3>

<p>
Você pode utilizar os mesmos comandos que executa para coletar dados de seus equipamentos com as respectivas comunidades (SNMP v1/v2c) ou usuario/senha (SNMP v3). Quando transportar os comandos para o Script siga essa sequencia: a comunidade/usuario, o IP, o tipo de hash (MD5|SHA), a senha do hash (autenticação), o tipo de criptografia (AES|DES) e a senha da chave (criptografia).
</p>
<br>
<p><b>Exemplo de consulta SNMP v1:</b></p>
<p># snmpget -Oqn -v1 -c public 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v1:</b></p>
<p># ./show_manufacturer.sh snmp_01 public 192.0.2.1</p>
<p><b>Exemplo de consulta SNMP v2c:</b></p>
<p># snmpget -Oqn -v2c -c public 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v2c:</b></p>
<p># ./show_manufacturer.sh snmp_02 public 192.0.2.1</p>
<p><b>Exemplo de consulta SNMP v3 noAuthNoPriv</b></p>
<p># snmpget -Oqn -v3 -u noAuthUser -n "" -l noAuthNoPriv 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v3 noAuthNoPriv</b></p>
<p># ./show_manufacturer.sh snmp_03 noAuthUser 192.0.2.1</p>
<p><b>Exemplo de consulta SNMP v3 com AuthNoPriv</b></p>
<p># snmpget -Oqn -v3 -u initial -n "" -l authNoPriv -a MD5 -A 'setup_passphrase' 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v3 com AuthNoPriv</b></p>
<p># ./show_manufacturer.sh snmp_04 initial 192.0.2.1 MD5 'setup_passphrase'</p>
<p><b>Exemplo de consulta SNMP v3 com authPriv</b></p>
<p># snmpget -Oqn -v3 -u initial -n "" -x DES -X 'setup_passkey' -l authPriv -a MD5 -A 'setup_passphrase' 192.0.2.1 sysObjectID.0</p>
<p><b>Exemplo de consulta com show_manufacturer SNMP v3 com AuthPriv</b></p>
<p># ./show_manufacturer.sh snmp_05 initial 192.0.2.1 MD5 'setup_passphrase' DES 'setup_passkey'</p>
<br>
<h1>Uso no Zabbix</h1>
<p>
O script foi concebido com o objetivo de utilizá-lo no Zabbix, por isso todas as parametrizações se dão por meio de passagem de parâmetros, mas alguns detalhes precisam ser observados. Esses detalhes são tratados nas próximas seções.
</p>
<h3>Uso de Nomes de Comunidades (SNMP v2c) e Nomes/Senhas de Usuários (SNMP v3)</h3>
<p>O Zabbix não aceita os seguintes caracteres especiais nas chaves:</p>
<p><b>\, ', ", `, *, ?, [, ], {, }, ~, $, !, &, ;, (, ), <, >, |, #, @, 0x0a</b></p>
<p>Logo nenhum deles pode estar presentes no nome da sua comunidade ou no nome/senha dos seus usuários. Isso pode ser resolvido de algumas maneiras:</p>
<ul>
	<li>Não utilizando esses caracteres;</li>
	<li>Agendando o script para ser executado via crontab;</li>
	<li>Alterando o script e deixando o nome da comunidade ou o nome/senha dos seus usuários "hard coded".</li>
</ul> 
<h3>Uso de Macros</h3>
<p>Como dito acima o Zabbix não aceita caracteres especiais nas chaves, logo não podemos usar macros nas chaves.</p>
<h3>Uso do Script em Ativos de Rede</h3>
<p>É óvio que não podemos executar um Shell Script em um ativo de rede como um Switch, No-Break, etc. A solução nesse caso é criar o item no Zabbix Server ou agendar a execução do script via crontab.</p>
<h3>Criar o item no Zabbix Server</h3>
<p>A idéia é criar um item no Zabbix Server com horário agendado (Zabbix 3.x) que vai executar o script e alimentar o item do ativo. Na realidade criaremos um item para atualizar diariamente a lista de fabricantes e outro que vai alimentar o item no ativo.</p>
<p>Primeiramente vamos criar o UserParameter no zabbix_agentd.conf:</p>
<p><i># tail -1 /usr/local/etc/zabbix_agentd.conf
UserParameter=show_manufacturer[*],/usr/local/etc/zabbix/externalscripts/show_manufacturer.sh $1 $2 $3 $4 $5 $6 $7 $8 $9
</i></p>
</p>
<h4>Item para atualizar a lista de fabricantes</h4>
<p>Item criado no <b>Zabbix Server</b>, observe o detalhe do agendamento do horário.</p>
<img src="https://raw.githubusercontent.com/andredeo/show_manufacturer/master/show_manufacturer_01.png" border="0" height="200" width="296">
<h4>Item para executar o script e enviar o dado para o ativo</h4>
<p>Item criado no <b>Zabbix Server</b>, observe o detalhe do agendamento do horário.</p>
<img src="https://raw.githubusercontent.com/andredeo/show_manufacturer/master/show_manufacturer_02.png" border="0" height="200" width="296">
<p>Nestes dois itens eu não preciso atualizar a informação e nem armazená-la.</p>
<h4>Item para receber o dado enviado</h4>
<p>Item criado no <b>ativo</b>, observe que o meu ativo não possui uma interface do tipo Agente Zabbix, e mesmo assim eu posso criar um item do tipo <b>Zabbix trapper</b>.</p>
<img src="https://raw.githubusercontent.com/andredeo/show_manufacturer/master/show_manufacturer_03.png" border="0" height="200" width="296">
<h4>Dados recebidos</h4>
<p>Podemos observar que o ativo recebeu os dados.</p>
<img src="https://raw.githubusercontent.com/andredeo/show_manufacturer/master/show_manufacturer_04.png" border="0" height="200" width="296">
