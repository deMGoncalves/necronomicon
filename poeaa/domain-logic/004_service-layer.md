# Service Layer

**Classificação**: Padrão de Lógica de Domínio

---

## Intenção e Objetivo

Definir o limite da aplicação com uma camada de serviço que estabelece um conjunto de operações disponíveis e coordena a resposta da aplicação em cada operação. Encapsula a lógica da aplicação e controla as transações.

## Também Conhecido Como

- Application Service Layer
- Use Case Layer
- Application Facade

## Motivação

Aplicações corporativas tipicamente expõem funcionalidades por meio de múltiplas interfaces — aplicação web, API REST, interface mobile, processos em lote. Cada interface precisa das mesmas operações de negócio, mas em contextos diferentes. Sem a Service Layer, a lógica de negócio é duplicada ou espalhada pelas camadas de apresentação.

A Service Layer define o limite da aplicação estabelecendo um conjunto de operações disponíveis e coordenando a resposta em cada operação. Quando um cliente solicita a criação de um pedido, a Service Layer inicia a transação, valida os dados, coordena os objetos de domínio necessários (Customer, Product, Order), persiste as mudanças e confirma a transação. O cliente não precisa conhecer a complexidade interna.

Essa abordagem cria um único ponto de entrada para a lógica da aplicação, facilitando o controle de transações, segurança, autorização e auditoria. A Service Layer pode ser fina (delegando apenas ao Domain Model) ou mais espessa (contendo lógica de coordenação significativa), dependendo da complexidade.

## Aplicabilidade

Use Service Layer quando:

- A aplicação tiver múltiplos tipos de clientes (web, mobile, API, lote)
- A lógica de negócio precisar ser reutilizada entre diferentes interfaces
- O gerenciamento de transações precisar ser centralizado e consistente
- Um limite claro de aplicação facilitar os testes e a manutenção
- Segurança e autorização precisarem ser aplicadas de forma uniforme
- A integração com sistemas externos exigir uma interface bem definida

## Estrutura

```
Clientes (múltiplos tipos)
├── Web UI
├── Mobile App
├── REST API
└── Batch Jobs
    └── Todos chamam: Service Layer

Service Layer
├── OrderService
│   ├── createOrder(orderData)
│   ├── cancelOrder(orderId)
│   └── shipOrder(orderId)
├── CustomerService
│   ├── registerCustomer(customerData)
│   └── updateProfile(customerId, data)
└── ProductService
    ├── addProduct(productData)
    └── updateInventory(productId, quantity)

    └── Cada serviço:
        ├── Inicia transação
        ├── Coordena Objetos de Domínio
        ├── Aplica regras de negócio
        └── Confirma/reverte transação

Camada de Domínio
├── Domain Model (Entities, Value Objects)
└── Domain Services

Camada de Fonte de Dados
└── Repositories, Data Mappers
```

## Participantes

- **Interface da Service Layer**: Define os contratos das operações disponíveis na aplicação
- **Application Service**: Implementa as operações da aplicação; coordena o trabalho
- **Domain Objects**: Entities e Value Objects que executam a lógica de domínio
- **Domain Services**: Operações de domínio que não pertencem às entidades
- **Repositories**: Fornecem acesso aos aggregates persistidos
- **Transaction Manager**: Gerencia os limites transacionais
- **Clientes**: Camada de apresentação, APIs, outros sistemas que invocam os serviços

## Colaborações

- O cliente invoca uma operação no Application Service por meio da interface
- O serviço inicia a transação e obtém os objetos de domínio necessários via Repository
- O serviço coordena as interações entre os Objetos de Domínio para executar a operação
- Os Objetos de Domínio executam a lógica de negócio conforme coordenado pelo Serviço
- O serviço persiste as mudanças por meio do Repository ou Unit of Work
- O serviço confirma a transação se a operação for bem-sucedida ou a reverte em caso de erro
- O serviço retorna o resultado (DTO ou objeto de domínio) ao Cliente

## Consequências

### Vantagens

- **Interface clara da aplicação**: Operações bem definidas e documentadas
- **Reusabilidade**: Lógica compartilhada entre múltiplos clientes
- **Gerenciamento de transações**: Transações controladas de forma consistente
- **Separação de responsabilidades**: Apresentação separada da lógica de negócio
- **Testabilidade**: Serviços podem ser testados independentemente da UI
- **Segurança centralizada**: Autorização e autenticação aplicadas de forma uniforme

### Desvantagens

- **Camada adicional**: Aumenta a complexidade arquitetural
- **Risco de anemia**: Pode se tornar um simples repasse sem valor agregado
- **Decisões de granularidade**: Difícil decidir a granularidade correta das operações
- **Overengineering**: Pode ser uma sobrecarga desnecessária para aplicações simples
- **Duplicação**: Risco de duplicar lógica que deveria estar no domínio
- **Acoplamento**: Os clientes ficam acoplados aos contratos de serviço

## Implementação

### Considerações

1. **Granularidade das operações**: Defina operações que representem casos de uso completos, não CRUD genérico
2. **Gerenciamento de transações**: Decida onde as transações começam e terminam (normalmente na Service Layer)
3. **Espessura do serviço**: Decida quanta lógica vai no Serviço vs no Domain Model
4. **DTOs vs Objetos de Domínio**: Defina o que atravessa o limite da Service Layer
5. **Tratamento de erros**: Traduza exceções de domínio para o formato apropriado
6. **Stateless**: Mantenha os Serviços sem estado entre chamadas

### Técnicas

- **Padrão Facade**: Service Layer como Facade sobre um Domain Model complexo
- **Organização de Transaction Scripts**: Agrupe Transaction Scripts em Serviços
- **Coordenação do Domain Model**: Coordene objetos ricos do Domain Model
- **Montagem de DTOs**: Monte DTOs a partir de Objetos de Domínio para retorno
- **Integração com Unit of Work**: Use Unit of Work para gerenciar a persistência
- **Injeção de Dependência**: Injete dependências (Repositories, Domain Services)

## Usos Conhecidos

- **Aplicações Java Corporativas**: EJB Session Beans, Spring Services
- **Aplicações ASP.NET**: Classes de serviço em arquitetura em camadas
- **APIs REST**: Camada de serviço expondo endpoints HTTP
- **Microsserviços**: Cada microsserviço com sua Service Layer
- **Implementações CQRS**: Command Handlers e Query Handlers
- **Clean Architecture**: Use Case Interactors na camada de aplicação

## Padrões Relacionados

- [**Transaction Script**](001_transaction-script.md): A Service Layer pode conter e organizar Scripts
- [**Domain Model**](002_domain-model.md): A Service Layer coordena o Domain Model rico
- [**Table Module**](003_table-module.md): A Service Layer pode usar Table Modules
- [**Remote Facade**](055_remote-facade.md): A Service Layer frequentemente é exposta como Remote Facade
- [**Data Transfer Object**](056_data-transfer-object.md): DTOs cruzam o limite da Service Layer
- [**Unit of Work**](../object-relational/001_unit-of-work.md): A Service Layer gerencia o Unit of Work
- [**Repository**](../object-relational/016_repository.md): A Service Layer usa Repositories para acesso a dados
- [**GoF Facade**](../../gof/structural/005_facade.md): A Service Layer é a Facade da aplicação

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): coordenação como responsabilidade
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): depender de abstrações
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): extensível via novos serviços
- [038 - Conformance with CQS](../../clean-code/conformidade-principio-inversao-consulta.md): separar comandos e consultas
- [032 - Test Coverage](../../clean-code/cobertura-teste-minima-qualidade.md): testabilidade dos serviços

---

**Criado em**: 2025-01-11
**Versão**: 1.0
