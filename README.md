# consultaCEP

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

  
