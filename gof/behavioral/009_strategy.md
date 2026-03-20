# Strategy

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Definir uma família de algoritmos, encapsular cada um e torná-los intercambiáveis. Strategy permite que o algoritmo varie independentemente dos clientes que o utilizam. Promove composição em vez de herança para variar comportamento.

## Também Conhecido Como

- Policy

## Motivação

Existem muitos algoritmos para quebrar um fluxo de texto em linhas. Codificar todos esses algoritmos diretamente nas classes que os requerem não é desejável por várias razões: os clientes que precisam de quebra de linha ficam mais complexos se incluírem o código de quebra de linha, tornando-os maiores e mais difíceis de manter; algoritmos diferentes serão adequados em momentos diferentes; é difícil adicionar novos algoritmos e variar os existentes quando a quebra de linha é parte integral de um cliente.

Podemos evitar esses problemas definindo classes que encapsulam diferentes algoritmos de quebra de linha. Um algoritmo encapsulado desta forma é chamado de strategy. A composição permite que a classe Composition mantenha uma referência a um objeto Strategy e delegue a ele. Trocar por uma Strategy diferente muda como o texto é quebrado.

## Aplicabilidade

Use o padrão Strategy quando:

- Muitas classes relacionadas diferem apenas em seu comportamento; Strategies fornecem uma forma de configurar uma classe com um de muitos comportamentos
- Você precisa de variantes diferentes de um algoritmo
- Um algoritmo usa dados que os clientes não devem conhecer; use Strategy para evitar expor estruturas de dados complexas
- Uma classe define muitos comportamentos, e estes aparecem como múltiplas instruções condicionais; mova cada ramo condicional para sua própria classe Strategy
- Você deseja evitar acoplamento rígido entre o algoritmo e o código que o usa
- Você deseja tornar o algoritmo intercambiável em tempo de execução

## Estrutura

```
Context
├── Compõe: Strategy
├── contextInterface()
│   └── Delega para: strategy.algorithmInterface()
└── setStrategy(Strategy)
    └── Permite trocar de strategy

Strategy (Interface)
└── algorithmInterface(data)

ConcreteStrategyA implements Strategy
└── algorithmInterface(data)
    └── Implementação específica do Algoritmo A

ConcreteStrategyB implements Strategy
└── algorithmInterface(data)
    └── Implementação específica do Algoritmo B

ConcreteStrategyC implements Strategy
└── algorithmInterface(data)
    └── Implementação específica do Algoritmo C
```

## Participantes

- [**Strategy**](009_strategy.md): Declara uma interface comum para todos os algoritmos suportados; Context usa essa interface para chamar o algoritmo definido por um ConcreteStrategy
- **ConcreteStrategy**: Implementa o algoritmo usando a interface Strategy
- **Context**: Configurado com um objeto ConcreteStrategy; mantém uma referência a um objeto Strategy; pode definir uma interface que permite ao Strategy acessar seus dados

## Colaborações

- Strategy e Context interagem para implementar o algoritmo escolhido; um Context pode passar todos os dados necessários ao algoritmo para a Strategy quando o algoritmo é chamado; alternativamente, Context pode passar a si mesmo como argumento, permitindo que a Strategy faça callback no Context se necessário
- Um Context encaminha solicitações de seus clientes para sua Strategy; Clientes geralmente criam e passam um objeto ConcreteStrategy para o Context; depois disso, os clientes interagem com o Context exclusivamente

## Consequências

### Vantagens

- **Famílias de algoritmos relacionados**: Hierarquias de classes Strategy definem uma família de algoritmos ou comportamentos para contextos reutilizarem
- **Uma alternativa à herança**: A herança oferece outra forma de suportar uma variedade de algoritmos; mas a herança mistura a implementação do algoritmo no Context; mistura o algoritmo com o Context, tornando-o mais difícil de entender, manter e estender
- **Elimina instruções condicionais**: Quando comportamentos diferentes são agrupados em instruções condicionais, Strategy elimina os condicionais movendo o comportamento para classes Strategy
- **Escolha de implementações**: Strategies podem fornecer diferentes implementações do mesmo comportamento; o cliente pode escolher entre strategies com diferentes compensações de tempo e espaço
- **Open/Closed Principle**: Adicionar novas strategies sem modificar o context

### Desvantagens

- **Clientes devem conhecer as diferentes Strategies**: Os clientes precisam entender como as Strategies diferem antes de selecionar a adequada
- **Sobrecarga de comunicação**: A interface Strategy é compartilhada por todos os ConcreteStrategies; alguns podem não usar todos os dados passados por essa interface
- **Número aumentado de objetos**: Strategies aumentam o número de objetos em uma aplicação; pode-se reduzir isso usando Strategies como objetos sem estado que os contextos podem compartilhar

## Implementação

### Considerações

1. **Definindo interfaces de Strategy e Context**: Strategy e Context interagem para implementar o algoritmo escolhido
   - Context passa dados para Strategy (pode passar Context como parâmetro)
   - Context pode passar a si mesmo como argumento permitindo que Strategy faça callback

2. **Strategies como parâmetros de template**: Em C++, pode-se usar templates para configurar uma classe com uma Strategy; funciona apenas se a Strategy puder ser selecionada em tempo de compilação

3. **Tornando objetos Strategy opcionais**: Context verifica se tem uma Strategy; se não, executa comportamento padrão; benefício: clientes não precisam lidar com objetos Strategy a menos que não gostem do comportamento padrão

4. **Strategy como função**: Em linguagens com funções de primeira classe, pode-se passar função em vez de objeto Strategy

### Técnicas

- **Strategies Sem Estado**: Strategies sem estado podem ser Flyweights compartilhados
- **Strategy Factory**: Factory para criar strategies adequadas
- **Strategy Padrão**: Strategy padrão se nenhuma for fornecida
- **Função como Strategy**: Em linguagens funcionais, usar funções de ordem superior

## Usos Conhecidos

- **Algoritmos de Ordenação**: Diferentes algoritmos de ordenação (quicksort, mergesort, heapsort)
- **Compressão**: Diferentes algoritmos de compressão (ZIP, RAR, GZIP)
- **Validação**: Diferentes strategies de validação de dados
- **Métodos de Pagamento**: Diferentes métodos de pagamento (cartão de crédito, PayPal, cripto)
- **Planejamento de Rotas**: Diferentes algoritmos de roteamento (mais curto, mais rápido, panorâmico)
- **Gerenciadores de Layout**: Diferentes strategies de layout em GUIs

## Padrões Relacionados

- [**Flyweight**](011_flyweight.md): Objetos Strategy frequentemente fazem bons flyweights
- [**State**](008_state.md): State pode ser considerado uma extensão de Strategy; ambos baseados em composição; mas State permite que o objeto de estado mude o estado do Context; Strategy apenas varia o algoritmo
- [**Template Method**](010_template-method.md): Define o esqueleto do algoritmo; Strategy define família completa de algoritmos
- [**Command**](002_command.md): Strategy pode usar Command para parametrizar objetos com ação
- [**Decorator**](009_decorator.md): Muda a aparência do objeto; Strategy muda suas entranhas

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar strategies sem modificar o context
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): elimina condicionais de algoritmo
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada strategy uma responsabilidade
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): context depende da interface
- [037 - Prohibition of Flag Arguments](../../clean-code/proibicao-argumentos-sinalizadores.md): substitui flags booleanas

---

**Criado em**: 2025-01-11
**Versão**: 1.0
