# Transaction Script

**Classificação**: Padrão de Lógica de Domínio

---

## Intenção e Objetivo

Organizar a lógica de negócio por meio de procedimentos onde cada procedimento lida com uma única requisição da camada de apresentação.

## Também Conhecido Como

- Lógica de Negócio Procedural
- Método de Serviço

## Motivação

A maneira mais simples de estruturar a lógica de negócio é usar procedimentos que implementam cada requisição do sistema como um script separado. Se você recebe uma requisição para calcular o reconhecimento de receita, escreve um procedimento que realiza o cálculo.

Cada transação tem seu próprio Transaction Script que interage diretamente com o banco de dados ou por meio de um wrapper fino de acesso a dados. A beleza do Transaction Script está em sua simplicidade: não exige frameworks sofisticados nem conhecimento de padrões avançados.

Para aplicações simples com lógica de negócio relativamente direta, o Transaction Script funciona muito bem. É especialmente adequado quando há pouca ou nenhuma duplicação de código entre as transações.

## Aplicabilidade

Use Transaction Script quando:

- A lógica de negócio for relativamente simples
- Houver pouca ou nenhuma duplicação de código entre as transações
- A aplicação não tiver complexidade de domínio significativa
- A equipe tiver experiência com programação procedural
- O desempenho for crítico e a sobrecarga de OO não for desejável
- A prototipagem rápida for necessária

## Estrutura

```
Camada de Apresentação
└── Chama: TransactionScript

TransactionScript
├── validateInput()
├── performBusinessLogic()
├── accessDatabase()
└── returnResult()

Banco de Dados
└── Acessado: diretamente ou via wrapper fino
```

## Participantes

- [**Transaction Script**](001_transaction-script.md): Procedimento que implementa uma transação de negócio completa
- **Camada de Apresentação**: Interface que invoca os Transaction Scripts
- **Banco de Dados**: Armazenamento de dados acessado pelos scripts
- **Data Gateway** (opcional): Wrapper fino sobre o acesso ao banco de dados

## Colaborações

- A camada de apresentação recebe a requisição do usuário e chama o Transaction Script apropriado
- O Transaction Script executa validação, lógica de negócio e acesso a dados em sequência
- O script pode usar um Data Gateway para separar o SQL do código de negócio
- O script retorna o resultado para a camada de apresentação

## Consequências

### Vantagens

- **Simplicidade**: Fácil de entender e implementar pelos desenvolvedores
- **Procedural**: Familiar a programadores acostumados com programação procedural
- **Desempenho**: Sobrecarga mínima, execução direta sem camadas extras
- **Adequado para lógica simples**: Perfeito quando o domínio é simples e direto
- **Testabilidade**: Scripts individuais são fáceis de testar isoladamente

### Desvantagens

- **Duplicação de código**: A lógica compartilhada tende a ser duplicada entre os scripts
- **Dificuldade com complexidade**: Não escala bem para domínios complexos
- **Manutenibilidade**: Torna-se desorganizado à medida que a aplicação cresce
- **Sem modelo de domínio rico**: Não captura a complexidade nem regras de domínio sofisticadas
- **Acoplamento**: Os scripts frequentemente ficam acoplados à estrutura do banco de dados

## Implementação

### Considerações

1. **Organização dos scripts**: Agrupe scripts relacionados em classes de serviço ou módulos
2. **Acesso a dados**: Considere usar Data Gateway para separar o SQL da lógica de negócio
3. **Reuso**: Extraia lógica comum em funções auxiliares compartilhadas
4. **Transações**: Gerencie as transações de banco de dados explicitamente
5. **Validação**: Centralize a validação de entrada para evitar duplicação

### Técnicas

- [**Service Layer**](004_service-layer.md): Agrupe Transaction Scripts relacionados em uma Service Layer
- **Funções Comuns**: Extraia código duplicado em funções utilitárias
- **Camada de Acesso a Dados**: Separe o acesso a dados em uma camada dedicada
- **Tratamento de Erros**: Tratamento consistente de erros em todos os scripts

## Usos Conhecidos

- **Stored Procedures**: Lógica de negócio implementada em stored procedures do banco de dados
- **Servlets**: Servlets Java com lógica procedural para processar requisições
- **Scripts CGI**: Scripts CGI clássicos em Perl, Python ou Ruby
- **Funções Serverless**: AWS Lambda, Azure Functions com lógica simples
- **Batch Jobs**: Trabalhos em lote com processamento sequencial
- **APIs REST simples**: Endpoints REST com lógica CRUD direta

## Padrões Relacionados

- [**Domain Model**](002_domain-model.md): Alternativa OO para lógica complexa; Transaction Script é mais simples
- [**Table Module**](003_table-module.md): Meio-termo entre Transaction Script e Domain Model
- [**Service Layer**](004_service-layer.md): Transaction Scripts podem formar uma Service Layer
- [**Table Data Gateway**](../data-source/001_table-data-gateway.md): Separa o acesso a dados da lógica de negócio
- [**Row Data Gateway**](../data-source/002_row-data-gateway.md): Alternativa para acesso a dados orientado a linhas
- [**GoF Command**](../../gof/behavioral/002_command.md): Transaction Script é uma implementação simples do padrão Command

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada script, uma transação
- [021 - Prohibition of Logic Duplication](../../clean-code/proibicao-duplicacao-logica.md): desafio do Transaction Script
- [022 - Prioritization of Simplicity](../../clean-code/priorizacao-simplicidade-clareza.md): Transaction Script é o mais simples

---

**Criado em**: 2025-01-11
**Versão**: 1.0
