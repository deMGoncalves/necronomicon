# Domain Model

**Classificação**: Padrão de Lógica de Domínio

---

## Intenção e Objetivo

Criar um modelo de objetos do domínio que incorpore tanto comportamento quanto dados. Uma rede interconectada de objetos onde cada objeto representa alguma entidade significativa no domínio do problema, seja algo tão grande quanto uma corporação ou tão pequeno quanto uma linha de pedido.

## Também Conhecido Como

- Rich Domain Model
- Object Model
- Domain Object Model

## Motivação

Quando a lógica de negócio se torna complexa, o uso de Transaction Script resulta em código duplicado e dificulta a manutenção. O Domain Model ataca esse problema movendo a lógica para objetos de domínio, onde cada objeto representa um conceito de negócio e contém dados e comportamento relacionados.

Em um sistema de pedidos, em vez de um procedimento que calcula o total do pedido, você tem um objeto Order que conhece seus itens e pode calcular o total perguntando a cada item pelo seu valor. Cada item conhece seu produto e quantidade e pode calcular seu próprio subtotal. A lógica é distribuída entre os objetos que possuem as informações necessárias.

À medida que o domínio cresce em complexidade, o Domain Model se torna mais valioso. Ele captura regras de negócio complexas, validações e invariantes de domínio de uma forma fácil de entender e modificar. Herança e polimorfismo permitem expressar variações de comportamento de forma elegante.

## Aplicabilidade

Use Domain Model quando:

- A lógica de domínio for complexa, com muitas regras e interações
- Houver comportamento significativo associado aos dados
- Existirem múltiplas estratégias ou variações de comportamento
- O sistema tiver uma vida longa e precisar evoluir
- A equipe tiver experiência com design orientado a objetos
- Os benefícios de uma modelagem rica superarem a complexidade adicional

## Estrutura

```
Cliente (Aplicação/UI)
└── Usa: Objetos de Domínio

Objetos de Domínio
├── Entity (com identidade)
│   ├── Order
│   │   ├── calculateTotal()
│   │   ├── addItem()
│   │   └── validate()
│   ├── Customer
│   │   ├── placeOrder()
│   │   └── creditCheck()
│   └── Product
│       └── isAvailable()
│
└── Value Object (sem identidade)
    ├── Money
    ├── DateRange
    └── Address

Data Mappers
└── Traduzem entre: Objetos de Domínio ↔ Banco de Dados
```

## Participantes

- **Entity**: Objetos com identidade que persiste ao longo do tempo; contêm dados e comportamento
- [**Value Object**](../base/006_value-object.md): Objetos sem identidade conceitual; definidos por atributos; imutáveis
- **Aggregate**: Agrupamento de objetos tratados como unidade para alterações de dados
- **Domain Service**: Operação que não pertence naturalmente a uma Entity ou Value Object
- [**Repository**](../object-relational/016_repository.md): Mecanismo para obter referências a Aggregates
- **Factory**: Encapsula a criação complexa de Objetos de Domínio

## Colaborações

- O cliente interage com os Objetos de Domínio por meio de interfaces de comportamento ricas
- As Entities colaboram entre si por meio de associações para implementar a lógica de negócio
- Os Value Objects são passados como parâmetros e retornados de métodos
- Os Domain Services orquestram interações complexas entre múltiplos objetos
- O Repository abstrai o acesso a dados e retorna objetos completamente formados
- Os Data Mappers movem dados entre objetos e banco de dados sem que os objetos conheçam o banco

## Consequências

### Vantagens

- **Gerencia a complexidade**: Lida bem com lógica de negócio rica e complexa
- **Extensibilidade**: Fácil de adicionar novas regras e comportamentos
- **Manutenibilidade**: Lógica coesa nos objetos apropriados; menos duplicação
- **Testabilidade**: Objetos de domínio podem ser testados isoladamente
- **Expressividade**: O modelo expressa os conceitos de negócio com clareza
- **Reuso**: Objetos de domínio podem ser reutilizados em diferentes contextos

### Desvantagens

- **Complexidade inicial**: Exige mais esforço de design e desenvolvimento no início
- **Curva de aprendizado**: Requer conhecimento de OO e design orientado a domínio
- **Impedância objeto-relacional**: O mapeamento entre objetos e banco de dados pode ser complexo
- **Sobrecarga de desempenho**: Pode ter overhead em comparação com abordagens procedurais
- **Overengineering**: Fácil criar um modelo mais complexo do que o necessário

## Implementação

### Considerações

1. **Identificar Entities vs Value Objects**: Entities têm identidade; Value Objects são imutáveis e intercambiáveis
2. **Definir Aggregates**: Agrupe objetos que precisam ser consistentes juntos
3. **Encapsular invariantes**: Garantir as regras de negócio por meio de encapsulamento
4. **Evitar anemia**: Os objetos devem ter comportamento significativo, não apenas getters/setters
5. **Gerenciar associações**: Manter as associações bidirecionais consistentes
6. **Separar persistência**: Os Objetos de Domínio devem ser ignorantes de como são persistidos

### Técnicas

- **Ubiquitous Language**: Use a mesma terminologia no código e com os especialistas do domínio
- **Strategic Design**: Identifique Bounded Contexts e Context Maps
- **Padrões Táticos**: Aplique padrões como Aggregate, Repository, Factory
- **Lazy Loading**: Carregue associações sob demanda para desempenho
- **Gerenciamento de Identidade**: Use chaves para a identidade de Entities
- **Imutabilidade**: Torne os Value Objects imutáveis

## Usos Conhecidos

- **E-commerce**: Sistemas de pedidos com lógica complexa de preços, promoções, estoque
- **Bancário**: Sistemas bancários com contas, transações, regras de negócio complexas
- **Seguros**: Sistemas de seguros com apólices, sinistros, regras de subscrição
- **Saúde**: Sistemas médicos com pacientes, tratamentos, protocolos clínicos
- **Sistemas ERP**: Planejamento de Recursos Empresariais com domínios ricos e interconectados
- **Logística**: Sistemas de gestão de remessas e armazéns

## Padrões Relacionados

- [**Transaction Script**](001_transaction-script.md): Alternativa mais simples; Domain Model para lógica complexa
- [**Table Module**](003_table-module.md): Meio-termo entre Transaction Script e Domain Model
- [**Service Layer**](004_service-layer.md): Define a interface da aplicação sobre o Domain Model
- [**Data Mapper**](../data-source/004_data-mapper.md): Mapeia Objetos de Domínio para o banco de dados
- [**Repository**](../object-relational/016_repository.md): Abstrai o acesso a Aggregates
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Gerencia transações sobre Objetos de Domínio
- [**Identity Map**](../object-relational/002_identity-map.md): Garante que o objeto seja carregado apenas uma vez

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada objeto, uma responsabilidade
- [008 - Prohibition of Getters/Setters](../../object-calisthenics/008_proibicao-getters-setters.md): Domain Model rico, não anêmico
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): objetos com comportamento
- [003 - Encapsulation of Primitives](../../object-calisthenics/003_encapsulamento-primitivos.md): Value Objects
- [029 - Object Immutability](../../clean-code/imutabilidade-objetos-freeze.md): Value Objects imutáveis

---

**Criado em**: 2025-01-11
**Versão**: 1.0
