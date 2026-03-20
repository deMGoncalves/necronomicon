# Prototype

**Classificação**: Padrão Criacional

---

## Intenção e Objetivo

Especificar os tipos de objetos a serem criados usando uma instância prototípica e criar novos objetos copiando esse protótipo. Permite adicionar e remover objetos em tempo de execução, especificando novos objetos pela variação de valores e estruturas.

## Também Conhecido Como

- Clone

## Motivação

Você poderia construir um editor gráfico que permite aos usuários adicionar novas ferramentas e objetos. O editor define classes abstratas para ferramentas gráficas e uma paleta de ferramentas disponíveis. Mas como o editor pode permitir que usuários adicionem novas ferramentas sem recompilar o sistema?

A solução é fazer com que as ferramentas criem novos objetos gráficos copiando ou "clonando" uma instância prototípica. Os usuários podem adicionar novas ferramentas simplesmente registrando novos protótipos na paleta. O editor então clona o protótipo adequado quando precisa criar um novo objeto.

## Aplicabilidade

Use o padrão Prototype quando:

- As classes a serem instanciadas são especificadas em tempo de execução
- Evitar construir uma hierarquia de fábricas paralela à hierarquia de produtos
- Instâncias de uma classe podem ter apenas algumas combinações diferentes de estado
- Criar objetos é custoso, e clonar é mais eficiente
- Você deseja ocultar a complexidade da criação do cliente
- Objetos precisam ser criados dinamicamente a partir de um banco de dados ou configuração

## Estrutura

```
Client
└── Usa: Prototype (interface)
    └── clone(): Prototype

Prototype (Interface)
└── clone(): Prototype

ConcretePrototype1 implements Prototype
├── Mantém estado interno
└── clone() → retorna cópia de si mesmo

ConcretePrototype2 implements Prototype
├── Mantém estado interno
└── clone() → retorna cópia de si mesmo

PrototypeRegistry (opcional)
├── Mantém: Map<String, Prototype>
├── register(name, prototype)
└── create(name) → return prototypes[name].clone()
```

## Participantes

- [**Prototype**](004_prototype.md): Declara a interface para clonar a si mesmo
- **ConcretePrototype**: Implementa a operação para clonar a si mesmo
- **Client**: Cria um novo objeto pedindo a um protótipo que clone a si mesmo
- **PrototypeRegistry** (opcional): Mantém registro de protótipos disponíveis

## Colaborações

- Client pede a um protótipo que clone a si mesmo, em vez de pedir a uma fábrica que crie um novo objeto

## Consequências

### Vantagens

- **Oculta classes concretas**: Reduz o número de classes que o cliente precisa conhecer
- **Adicionar/remover produtos em tempo de execução**: Registrar nova instância de protótipo equivale a adicionar nova classe
- **Especificar novos objetos variando valores**: Definir novos comportamentos por meio de composição de objetos
- **Reduzir herança**: Factory Method requer hierarquia de criadores; Prototype não
- **Configuração dinâmica**: As classes podem ser determinadas dinamicamente

### Desvantagens

- **Implementar clone pode ser difícil**: Especialmente se os objetos têm referências circulares ou estruturas complexas
- **Cópia superficial vs profunda**: A decisão sobre a profundidade da cópia pode ser complexa

## Implementação

### Considerações

1. **Usar gerenciador de protótipos**: PrototypeRegistry mantém e fornece protótipos

2. **Implementar operação clone**: Principal dificuldade quando estruturas internas incluem objetos sem suporte a cópia

3. **Cópia superficial vs profunda**:
   - Superficial: Copia apenas referências (objetos internos são compartilhados)
   - Profunda: Copia recursivamente toda a estrutura (objetos independentes)

4. **Inicializar clones**: Pode ser necessário método `initialize()` após o clone para configurar o estado interno

5. **Proteger protótipos**: Protótipos não devem ser modificados após a criação (imutabilidade)

### Técnicas

- **Copy Constructor**: Construtor que recebe instância do mesmo tipo
- **Serialização**: Usar serialização/desserialização para cópia profunda
- **Registry Pattern**: Manter catálogo de protótipos nomeados
- **Object Pool**: Combinar com Object Pool para reutilização de clones

## Usos Conhecidos

- **JavaScript**: A linguagem é baseada em protótipos (herança baseada em protótipos)
- **Object.create()**: Cria objeto com protótipo especificado
- **Clone em Java**: Interface `Cloneable` e método `clone()`
- **Desenvolvimento de Jogos**: Clonar inimigos, power-ups, terrenos
- **Componentes UI**: Clonar widgets configurados
- **Templates de Documento**: Criar documentos a partir de templates pré-configurados

## Padrões Relacionados

- **Abstract Factory/Factory Method**: Pode armazenar conjunto de protótipos para clonar e retornar produtos
- **Composite/Decorator**: Designs que fazem uso intenso desses padrões frequentemente se beneficiam de Prototype
- [**Singleton**](005_singleton.md): Oposto — Prototype permite múltiplas instâncias, Singleton garante instância única
- [**Memento**](../behavioral/006_memento.md): Prototype pode ser usado para implementar snapshots de estado
- [**Command**](../behavioral/002_command.md): Commands podem ser clonados via Prototype

### Relação com Rules

- [029 - Object Immutability](../../clean-code/imutabilidade-objetos-freeze.md): proteger protótipos
- [036 - Restriction on Functions with Side Effects](../../clean-code/restricao-funcoes-efeitos-colaterais.md): clone deve ser puro
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): permite extensão via registro

---

**Criado em**: 2025-01-11
**Versão**: 1.0
