---
titulo: Proibição de Argumentos Sinalizadores
aliases:
  - Flag Arguments
  - Boolean Trap
tipo: rule
id: CC-17
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - comportamental
  - solid
  - srp
resolver: Sprint atual
relacionados:
  - "[[001_single-responsibility-principle]]"
  - "[[002_open-closed-principle]]"
  - "[[limite-parametros-funcao]]"
  - "[[004_interface-segregation-principle]]"
criado: 2025-10-08
---

# Proibição de Argumentos Sinalizadores (Flag Arguments)

*Flag Arguments*


---

## Definição

Proíbe o uso de parâmetros booleanos (*boolean flags*) nas assinaturas de funções ou métodos, pois são um forte indicador de que a função possui mais de uma responsabilidade.

## Motivação

Argumentos sinalizadores (ex.: `process(data, shouldLog: boolean)`) violam o Princípio da Responsabilidade Única (SRP) e o Princípio Aberto/Fechado (OCP), pois a função se ramifica internamente, dificultando o teste e a manutenção.

## Quando Aplicar

- [ ] Funções não devem ter argumentos booleanos que alteram o caminho principal de execução (ex.: `if (flag) { ... } else { ... }`).
- [ ] Funções com *boolean flags* devem ser divididas em métodos separados, com nomes expressando a intenção de cada ramificação (ex.: `processAndLog(data)` e `process(data)`).
- [ ] Limite de **zero** *boolean flags* em métodos públicos de classes de domínio (`Services`, `Entities`).

## Quando NÃO Aplicar

- **Módulos de Controle do Sistema**: Funções de baixo nível que controlam *debugging* ou *mode* (ex.: `isVerbose`).
- **Frameworks/Bibliotecas**: Funções que implementam uma assinatura exigida por um framework de terceiros.

## Violação — Exemplo

```javascript
// ❌ Boolean flag — a função faz duas coisas diferentes dependendo do flag
function renderUser(user, isAdmin) {
  if (isAdmin) {
    return `<div class="admin">${user.name} [ADMIN]</div>`;
  }
  return `<div>${user.name}</div>`;
}
```

## Conformidade — Exemplo

```javascript
// ✅ Duas funções com intenção clara e testáveis independentemente
function renderUser(user) {
  return `<div>${user.name}</div>`;
}

function renderAdminUser(user) {
  return `<div class="admin">${user.name} [ADMIN]</div>`;
}
```

## Anti-Patterns Relacionados

- **Boolean Trap** — múltiplos booleanos em sequência: `render(user, true, false, true)` — ilegível

## Como Detectar

### Manual

Buscar parâmetros de função tipados como `boolean` ou com nomes como `isX`, `shouldY`, `withZ`.

### Automático

Biome: sem regra nativa para flag args; buscar parâmetros do tipo `boolean` via [`useNamingConvention`](https://biomejs.dev/linter/rules/use-naming-convention/) e revisão de code review.

## Relação com ICP

Reduz **[[componente-responsabilidades|Responsabilidades]]** (boolean flags = múltiplas responsabilidades em uma função) e **[[componente-cc-base|CC_base]]** (cada flag adiciona um ponto de decisão ao grafo de controle).

## Relacionados

- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[002_open-closed-principle|Princípio Aberto/Fechado]] — reforça
- [[limite-parametros-funcao]] — reforça
- [[004_interface-segregation-principle|Princípio da Segregação de Interfaces]] — reforça
