# Proxy

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Fornecer um substituto ou representante para outro objeto a fim de controlar o acesso a ele. Cria um objeto representante que controla o acesso ao objeto original, permitindo realizar algo antes ou depois da requisição chegar ao objeto original.

## Também Conhecido Como

- Surrogate

## Motivação

Uma razão para controlar o acesso a um objeto é adiar o custo total de sua criação e inicialização até que realmente precisemos usá-lo. Considere um editor de documentos que pode incorporar objetos gráficos. Alguns objetos gráficos (imagens raster grandes) são caros de criar. Mas abrir um documento deve ser rápido; não devemos criar todos os objetos caros de uma vez.

A solução é usar outro objeto, um proxy de imagem, no lugar da imagem real. O proxy age como a imagem e cuida de instanciá-la quando o documento precisar. O proxy encaminha requisições subsequentes diretamente para a imagem.

## Aplicabilidade

O Proxy é aplicável sempre que há necessidade de uma referência mais versátil ou sofisticada do que um simples ponteiro. Situações comuns:

- **Remote Proxy**: Representante local para um objeto em um espaço de endereços diferente
- **Virtual Proxy**: Cria objetos caros sob demanda (inicialização preguiçosa)
- **Protection Proxy**: Controla o acesso ao objeto original (verificação de direitos)
- **Smart Reference**: Substituto de um ponteiro que realiza ações adicionais quando o objeto é acessado (contagem de referências, carregamento de objeto persistente, bloqueio)
- **Cache Proxy**: Mantém cache de resultados caros
- **Logging Proxy**: Registra chamadas ao objeto real

## Estrutura

```
Client
└── Uses: Subject (Interface)
    └── request()

Subject (Interface)
└── request()

RealSubject implements Subject
└── request() → real implementation

Proxy implements Subject
├── Composes: RealSubject
└── request()
    ├── Access control / lazy init
    ├── realSubject.request()
    └── Post-processing
```

## Participantes

- **Subject**: Define interface comum para RealSubject e Proxy para que o Proxy possa ser usado em qualquer lugar onde RealSubject for esperado
- **RealSubject**: Define o objeto real que o proxy representa
- [**Proxy**](007_proxy.md): Mantém uma referência que permite acessar o RealSubject; fornece interface idêntica ao Subject; controla o acesso ao RealSubject e pode ser responsável por criá-lo e excluí-lo

## Colaborações

- O Proxy encaminha requisições ao RealSubject quando apropriado, dependendo do tipo de proxy

## Consequências

### Vantagens

- **Controle transparente**: Introduz um nível de indireção ao acessar um objeto; tipos específicos exploram isso
- **Remote Proxy**: Oculta que o objeto reside em um espaço de endereços diferente
- **Virtual Proxy**: Otimizações como criar o objeto sob demanda
- **Protection/Smart Proxies**: Permitem tarefas adicionais ao acessar o objeto
- **Copy-on-write**: Otimização de proxy virtual; adia a cópia até a modificação

### Desvantagens

- **Overhead**: Introduz uma camada de indireção que pode desacelerar operações
- **Complexidade**: Aumenta a complexidade do sistema

## Implementação

### Considerações

1. **Sobrecarga de operadores**: Em linguagens que permitem, pode-se sobrecarregar o operador de acesso (C++ `->`); em linguagens como Java, não é possível

2. **O proxy não precisa conhecer o tipo concreto**: Se o proxy apenas encaminha requisições, pode trabalhar com qualquer RealSubject

3. **Inicialização preguiçosa do RealSubject**: O proxy virtual pode adiar a criação

4. **Protection Proxy**: Verificar permissões antes de encaminhar

### Técnicas

- **Inicialização Preguiçosa**: Crie o RealSubject apenas quando necessário
- **Contagem de Referências**: Conte referências e exclua o RealSubject quando não utilizado
- **Caching**: Armazene em cache resultados de operações caras
- **Controle de Acesso**: Verifique credenciais antes de permitir acesso

## Usos Conhecidos

- **RMI/RPC**: Java RMI, gRPC usam proxies remotos
- **Frameworks ORM**: Lazy loading do Hibernate usa proxies virtuais
- **Spring AOP**: Proxies para aspectos (transações, segurança)
- **ES6 Proxy**: API Proxy do JavaScript para interceptar operações
- **Carregamento de Imagens**: Proxies virtuais para carregar imagens sob demanda
- **Proxies de Segurança**: Verificação de autenticação/autorização

## Padrões Relacionados

- [**Adapter**](001_adapter.md): Fornece interface diferente ao objeto; Proxy fornece a mesma interface
- [**Decorator**](004_decorator.md): Adiciona responsabilidades; Proxy controla acesso; Decorator pode ter a mesma implementação que Proxy, mas intenção diferente
- [**Facade**](005_facade.md): Fornece interface simplificada; Proxy fornece a mesma interface que o sujeito
- [**Singleton**](../creational/005_singleton.md): Proxy pode controlar o acesso ao singleton

### Relação com Rules

- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): Proxy substitui o RealSubject
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): cliente depende do Subject
- [036 - Function Side Effects Restriction](../../clean-code/restricao-funcoes-efeitos-colaterais.md): proxy pode adicionar efeitos

---

**Criado em**: 2025-01-11
**Versão**: 1.0
