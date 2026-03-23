---
titulo: Conformidade com o Princípio de Separação Comando-Consulta (CQS)
aliases:
  - CQS — Command Query Separation
  - Command Query Separation
tipo: rule
id: CC-18
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - comportamental
  - cqs
resolver: Sprint atual
relacionados:
  - "[[restricao-funcoes-efeitos-colaterais]]"
  - "[[001_single-responsibility-principle]]"
  - "[[009_diga-nao-pergunte]]"
  - "[[002_open-closed-principle]]"
criado: 2025-10-08
---

# Conformidade com o Princípio de Separação Comando-Consulta (CQS)

*CQS — Command Query Separation*


---

## Definição

Requer que um método seja ou uma **Query** que retorna dados sem alterar estado, ou um **Command** que altera estado mas não retorna dados (exceto DTOs/Entities).

## Motivação

A violação do CQS introduz **efeitos colaterais inesperados** e dificulta o raciocínio sobre o código, pois o cliente assume que um método de "consulta" é seguro, mas ele silenciosamente altera o estado do sistema. Isso leva a bugs de concorrência e de estado.

## Quando Aplicar

- [ ] Métodos que alteram estado (Commands) devem ter tipo de retorno `void` ou um tipo de entidade (ex.: `User`, `Order`), mas **não** um `boolean` ou código de sucesso.
- [ ] Métodos que retornam um valor (Queries) não devem ter efeitos colaterais perceptíveis (ex.: modificação de variável de instância, chamadas de métodos de escrita).
- [ ] O número de métodos híbridos (que fazem Query e Command ao mesmo tempo) deve ser zero.

## Quando NÃO Aplicar

- **Caches**: Métodos de leitura que possuem o efeito colateral de atualizar um cache interno (*cache-aside*) são aceitos, desde que esse efeito seja uma otimização e não lógica de negócio.

## Violação — Exemplo

```javascript
// ❌ Método híbrido — consulta E altera estado ao mesmo tempo
class UserService {
  getAndActivateUser(id) {         // nome sugere Query, mas tem efeito colateral
    const user = this.db.find(id);
    user.active = true;            // efeito colateral oculto!
    this.db.save(user);
    return user;                   // retorna E muta
  }
}
```

## Conformidade — Exemplo

```javascript
// ✅ Query e Command separados — cada um com responsabilidade única
class UserService {
  // Query: apenas lê, sem efeitos colaterais
  findUser(id) {
    return this.db.find(id);
  }

  // Command: muta estado, retorno void ou entidade
  activateUser(id) {
    const user = this.db.find(id);
    user.active = true;
    this.db.save(user);
  }
}
```

## Anti-Patterns Relacionados

- **Hybrid Method** — método que simultaneamente consulta e comanda
- **Spy Function** — função de leitura que registra ou altera estado como efeito colateral

## Como Detectar

### Manual

Buscar métodos que retornam um valor, mas contêm lógica de persistência (`save()`) ou modificação de estado.

### Automático

Biome: sem regra nativa para CQS; revisar via code review buscando métodos que retornam valor e contêm chamadas de persistência ou mutação de estado.

## Relação com ICP

Reduz **[[componente-responsabilidades|Responsabilidades]]** (Query ≠ Command significa que cada método tem uma responsabilidade) e **[[componente-cc-base|CC_base]]** (métodos focados têm menos ramificações, pois não precisam lidar com dois contextos diferentes).

## Relacionados

- [[restricao-funcoes-efeitos-colaterais]] — reforça
- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[009_diga-nao-pergunte|Tell, Don't Ask]] — reforça
- [[002_open-closed-principle|Princípio Aberto/Fechado]] — reforça
