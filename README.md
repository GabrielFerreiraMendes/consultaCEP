# Consulta CEP

 O Consulta CEP é uma aplicação criada em Delphi apenas com componentes nativos da linguagem. Essa aplicação tem como objetivo demonstrar a criação de componentes, testes unitários, assim como serialização e desserialização de arquivos JSON e XML e, para isso, o  Consulta CEP realiza o cadastro e edição de endereços.

 Uma vez que o endereço existe na base, o usuário tem a possibilidade de atualiza-lo. Mas quando o mesmo ainda não tiver sido cadastrado, a aplicação irá consumir o webservice da ViaCEP para localizar o CEP ou endereço, conforme explicações de uso em sua página. Aqui são permitidas duas maneiras de consulta:
 - CEP
 - Endereço

 Por CEP basta informar o CEP sem as máscara (exp: '91420270'), já endereço é necessário concatenar as informações de UF/CIDADE/LOGRADOURO (exp: 'ws/RS/Porto Alegre/Domingos'). Para ambos o cenários é necessário especificar também o tipo de retorno que se espera (JSON ou XML) existe um campo em tela onde o usuário pode escolher, porém essa seleção não interfere no resultado final.


## Banco de dados
- MYSQL

## Padrão arquitetural
- Multicamada (4-tier)

## Padrão de projeto
- MVCS (Model, view, controller, service)

## Passos para execução do projeto
### Preparação da base de dados
- Realizar a instalação do MySQL e o SGBD de sua preferência
- Realizar a configuração do banco
- SUGESTÃO: Criar Schema "consultaCEP"
- Executar a criação da tablea endereços (script na pasta scripts)
- Preencher informações de conxão no arquivo INI (pasta Win32)

### Componente
#### Instalação do componente viaCEP
- Abrir (via IDE) o projeto na pasta component.
- Executar o Compile, Build e Install do componente.
- Adicionar a pasta src no Libary Path da IDE.

#### Funcionamento

O componente foi criado para realizar requisições ao webservice ViaCEP (https://viacep.com.br/), ele conta com 4 propriedades:
- CEP
- UF
- Cidade
- Logradouro

E as funções:
- getJSONByCEP
- getJSONByEndereco
- getXMLByCEP
- getXMLByEndereco
 
O componente foi criado para facilitar e trazer dinamicidade na execução das consultas ao web service, simplificando a configuração dos componentes de requisição REST nativos da IDE.

  
