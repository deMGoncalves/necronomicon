# Chain of Responsibility

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Evitar o acoplamento do remetente de uma solicitação ao seu receptor, dando a mais de um objeto a chance de tratar a solicitação. Encadeia os objetos receptores e passa a solicitação ao longo da cadeia até que um objeto a trate.

## Também Conhecido Como

- Chain of Responsibility

## Motivação

Considere um sistema de ajuda sensível ao contexto. Se um usuário clicar em uma parte da interface, a ajuda adequada deve ser fornecida. Mas a ajuda depende do contexto — pode ser específica a um botão ou mais geral. A solicitação de ajuda é tratada pelo primeiro objeto da cadeia capaz de fornecê-la.

O problema é que o objeto que eventualmente fornece a ajuda não é conhecido pelo objeto que inicia a solicitação. É necessário um mecanismo para desacoplar o botão que inicia a solicitação dos objetos que podem fornecer a informação. O Chain of Responsibility resolve isso dando a múltiplos objetos a chance de tratar a solicitação.

## Aplicabilidade

Use Chain of Responsibility quando:

- Mais de um objeto pode tratar uma solicitação e o tratador não é conhecido a priori; o tratador deve ser determinado automaticamente
- Você deseja emitir uma solicitação para um de vários objetos sem especificar o receptor explicitamente
- O conjunto de objetos que pode tratar uma solicitação deve ser especificado dinamicamente
- Você deseja evitar o acoplamento entre remetente e receptores
- O processamento da solicitação deve seguir uma ordem específica mas flexível

## Estrutura

```
Client
└── Envia solicitação para: Handler

Handler (Interface/Abstrato)
├── Compõe: Handler successor (próximo na cadeia)
├── handleRequest(request)
└── setSuccessor(Handler)

ConcreteHandler1 implements Handler
└── handleRequest(request)
    ├── Se pode tratar
    │   └── Processa a solicitação
    └── Caso contrário
        └── successor.handleRequest(request)

ConcreteHandler2 implements Handler
└── handleRequest(request)
    ├── Se pode tratar
    │   └── Processa a solicitação
    └── Caso contrário
        └── successor.handleRequest(request)
```

## Participantes

- **Handler**: Define a interface para tratar solicitações; (opcionalmente) implementa o vínculo com o sucessor
- **ConcreteHandler**: Trata as solicitações pelas quais é responsável; pode acessar o sucessor; se puder tratar a solicitação, faz isso; caso contrário, encaminha ao sucessor
- **Client**: Inicia a solicitação para um objeto ConcreteHandler da cadeia

## Colaborações

- Quando o cliente emite uma solicitação, ela se propaga pela cadeia até que um ConcreteHandler assuma a responsabilidade de tratá-la

## Consequências

### Vantagens

- **Acoplamento reduzido**: Libera um objeto de precisar saber qual outro objeto trata a solicitação; tanto receptor quanto remetente não têm conhecimento explícito um do outro
- **Flexibilidade adicionada na atribuição de responsabilidades**: Adiciona flexibilidade na distribuição de responsabilidades entre objetos; pode adicionar ou alterar responsabilidades modificando a cadeia em tempo de execução
- **Recebimento não garantido**: A solicitação pode não ter um receptor explícito

### Desvantagens

- **Recebimento não garantido**: Não há garantia de que a solicitação será tratada; ela pode chegar ao fim da cadeia sem ser tratada
- **Características difíceis de observar**: Pode ser difícil observar características em tempo de execução devido às conexões indiretas
- **Depuração**: Pode ser difícil depurar o fluxo ao longo da cadeia

## Implementação

### Considerações

1. **Implementando a cadeia de sucessores**: Duas possibilidades
   - Definir novos vínculos (geralmente na classe Handler; mas pode ser nos ConcreteHandlers)
   - Utilizar vínculos existentes (ex: referência ao pai no Composite)

2. **Conectando sucessores**: Se não existirem referências, Handler deve manter referência ao sucessor; é útil ter uma operação padrão no Handler que encaminha ao sucessor

3. **Representando solicitações**: As opções variam desde operações codificadas diretamente até objetos Request separados

### Técnicas

- **Handler Padrão**: Ter um handler padrão no fim da cadeia para solicitações não tratadas
- **Cadeia Prioritária**: Handlers ordenados por prioridade
- **Broadcasting**: Permitir que múltiplos handlers processem a solicitação
- **Saída Antecipada**: Interromper a propagação após o primeiro handler processar

## Usos Conhecidos

- **Tratamento de Eventos**: Borbulhamento de eventos no DOM (JavaScript)
- **Frameworks de Log**: Loggers com níveis (DEBUG, INFO, WARN, ERROR)
- **Servlet Filters**: Cadeia de filtros em Java Servlets
- **Middleware**: Cadeia de middleware do Express.js
- **Tratamento de Exceções**: Blocos try-catch em múltiplos níveis
- **Autorização**: Verificação de permissões em camadas

## Padrões Relacionados

- [**Composite**](008_composite.md): Frequentemente aplicados juntos; o componente pode ser o sucessor do pai
- [**Command**](002_command.md): Solicitações no Chain of Responsibility são frequentemente Commands
- [**Decorator**](009_decorator.md): Estruturalmente similar, mas com intenções diferentes; Decorator adiciona comportamento, Chain trata ou encaminha

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada handler uma responsabilidade
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar handlers sem modificar os existentes
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): elimina condicionais complexos

---

**Criado em**: 2025-01-11
**Versão**: 1.0
