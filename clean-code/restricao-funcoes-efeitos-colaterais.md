---
titulo: Restrição de Funções com Efeitos Colaterais
aliases:
  - Side Effects
  - Pure Functions
tipo: rule
id: CC-16
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - comportamental
  - cqs
  - imutabilidade
resolver: Antes do commit
relacionados:
  - "[[009_diga-nao-pergunte]]"
  - "[[qualidade-tratamento-erros-dominio]]"
  - "[[conformidade-principio-inversao-consulta]]"
  - "[[008_proibicao-getters-setters]]"
  - "[[003_liskov-substitution-principle]]"
  - "[[imutabilidade-objetos-freeze]]"
  - "[[006_processos-stateless]]"
criado: 2025-10-08
---

# Restrição de Funções com Efeitos Colaterais (Side Effects)

*Side Effects / Pure Functions*


---

## Definição

Requer que funções ou métodos, exceto aqueles explicitamente designados como **Commands** (que alteram estado), sejam puros e **não alterem o estado** de variáveis de instância, objetos globais ou objetos externos passados por referência.

## Motivação

Efeitos colaterais inesperados introduzem erros graves e dificultam o raciocínio sobre o código, quebrando a **previsibilidade** e o **Princípio da Menor Surpresa**. Código impuro é difícil de testar e depurar.

## Quando Aplicar

- [ ] Funções que são puramente **Queries** não devem modificar variáveis de instância da classe ou objetos globais/externos.
- [ ] Objetos mutáveis passados como parâmetros devem ser clonados antes de qualquer modificação, a menos que a modificação seja a intenção de negócio do método.
- [ ] Funções que alteram estado devem ter nomes começando com verbos de Command (ex.: `update`, `save`, `delete`).

## Quando NÃO Aplicar

- **Commands de Persistência**: Métodos de `Repository` ou `Service` que explicitamente alteram o estado do sistema (ex.: `save`, `delete`).
- **Fluent Interfaces/Builders**: Classes que retornam `this` para modificar o próprio objeto.

## Violação — Exemplo

```javascript
// ❌ Função de consulta com efeito colateral oculto — viola Princípio da Menor Surpresa
function getActiveUsers(users) {
  return users.filter(u => {
    if (!u.active) u.lastChecked = Date.now(); // efeito colateral escondido!
    return u.active;
  });
}
```

## Conformidade — Exemplo

```javascript
// ✅ Query pura — sem efeitos colaterais
function getActiveUsers(users) {
  return users.filter(u => u.active);
}

// ✅ Command explícito — nome revela intenção de mutar
function markInactiveUsers(users) {
  users.filter(u => !u.active).forEach(u => { u.lastChecked = Date.now(); });
}
```

## Anti-Patterns Relacionados

- **Hidden Side Effect** — função que aparentemente consulta, mas silenciosamente altera estado
- **Global State Mutation** — modificar variáveis globais dentro de funções locais

## Como Detectar

### Manual

Buscar métodos que retornam um valor de consulta, mas também chamam um `setter` ou modificam um atributo interno/externo.

### Automático

ESLint: `no-side-effects-in-conditions` e análise de *mutabilidade*.

## Relação com ICP

Reduz **Responsabilidades** (funções puras têm uma única responsabilidade — transformar dados) e **CC_base** (menos ramificações de estado que precisam ser consideradas em cada caminho).

## Relacionados

- [[009_diga-nao-pergunte|Tell, Don't Ask]] — reforça
- [[qualidade-tratamento-erros-dominio]] — reforça
- [[conformidade-principio-inversao-consulta]] — reforça
- [[008_proibicao-getters-setters|Proibição de Getters/Setters]] — complementa
- [[003_liskov-substitution-principle|Princípio da Substituição de Liskov]] — reforça
- [[imutabilidade-objetos-freeze]] — reforça
- [[006_processos-stateless|Processos Stateless]] — complementa
