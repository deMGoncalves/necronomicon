---
titulo: Proibição de Funcionalidade Especulativa (Princípio YAGNI)
aliases:
  - YAGNI — You Aren't Gonna Need It
  - You Aren't Gonna Need It
tipo: rule
id: CC-03
severidade: 🟡 Médio
origem: clean-code
tags:
  - clean-code
  - comportamental
  - yagni
resolver: Próxima iteração
relacionados:
  - "[[007_maximum-lines-per-class]]"
  - "[[priorizacao-simplicidade-clareza]]"
criado: 2025-10-08
---

# Proibição de Funcionalidade Especulativa (Princípio YAGNI)

*YAGNI — You Aren't Gonna Need It*


---

## Definição

Requer que o código seja implementado apenas quando a funcionalidade é **necessária** (e não *talvez necessária* no futuro), evitando a inclusão de código ou abstrações desnecessários.

## Motivação

A funcionalidade especulativa aumenta a complexidade e o código morto, desperdiçando tempo de desenvolvimento. Aumenta a superfície de ataque e reduz a agilidade para responder a mudanças reais.

## Quando Aplicar

- [ ] É proibida a criação de classes ou métodos *vazios* que visam ser *placeholders* para funcionalidades futuras.
- [ ] É proibida a adição de parâmetros ou opções de configuração que não sejam imediatamente utilizados por pelo menos **um** cliente.
- [ ] O código não deve conter mais de **5%** de linhas marcadas como desabilitadas ou com comentários indicando "TODO: implementação futura".

## Quando NÃO Aplicar

- **Requisitos de Interface**: Métodos de interface exigidos por um contrato externo (ex.: `Disposable` ou `Closable`) que são implementados de forma trivial.

## Violação — Exemplo

```javascript
// ❌ Parâmetros e métodos "por precaução" — ninguém usa ainda
class UserService {
  createUser(data, options = {}, context = null, metadata = {}) { // parâmetros não usados
    // ...
  }

  exportToCsv() { /* TODO: implementar depois */ } // placeholder especulativo
  exportToXml() { /* TODO: implementar depois */ }
}
```

## Conformidade — Exemplo

```javascript
// ✅ Apenas o que é necessário agora
class UserService {
  createUser(data) {
    // implementação real e completa
  }
}
```

## Anti-Patterns Relacionados

- **Gold Plating** — adicionar funcionalidades não solicitadas "de presente"
- **Premature Abstraction** — criar abstrações antes de ter dois casos de uso reais

## Como Detectar

### Manual

Buscar métodos vazios, parâmetros não utilizados ou código que nunca é chamado (código morto).

### Automático

SonarQube/ESLint: `no-unused-vars`, `no-empty-function`.

## Relação com ICP

Reduz **Responsabilidades** (funcionalidades especulativas adicionam responsabilidades extras sem necessidade) e **Acoplamento** (menos dependências desnecessárias importadas para suportar features não existentes).

## Relacionados

- [[007_maximum-lines-per-class|Limite Máximo de Linhas por Classe]] — reforça
- [[priorizacao-simplicidade-clareza]] — complementa
