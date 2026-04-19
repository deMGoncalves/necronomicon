---
name: method
description: Convenção para implementação de métodos de classe — ao criar métodos de ação em classes, implementar operações que coordenam comportamentos e devem retornar contexto para encadeamento
model: sonnet
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Method

Convenção para implementação de métodos de classe focados em fluência e responsabilidade única.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar métodos que executam ações, operações ou coordenam comportamentos em classes; ao revisar métodos sem retorno que impedem encadeamento |
| **Prerequisites** | Compreensão de interfaces fluentes (Builder pattern); rules 010 (SRP), 002 (no-else), 033 (max params) |
| **Constraints** | Não aplicar retorno `this` em métodos com valor de retorno específico; não criar métodos com múltiplas responsabilidades; limite de 15 linhas por método (rule 007) |
| **Scope** | Nomenclatura, regras de retorno, decorators associados e padrões de implementação de métodos de classe |

---

## Quando Usar

Use ao criar métodos que executam ações, operações ou coordenam comportamentos em classes.

## Propósito

| Responsabilidade | Descrição |
|------------------|-------------|
| Ação de negócio | Executar operação representando intenção de negócio |
| Coordenação | Orquestrar chamadas a outros métodos ou serviços |
| Evento | Responder a eventos DOM ou de lifecycle |
| Transformação | Aplicar transformação de dados ou estado |

## Regra de Retorno

| Situação | Retorno Recomendado |
|----------|---------------------|
| Método público que modifica estado | `return this` para interface fluente |
| Método com valor de retorno | Tipo específico de valor |
| Método async sem retorno | `return this` |
| Método async com retorno | Tipo específico de valor via Promise |
| Event handlers e callbacks | Opcional (pode ser `void`) |

## Justificativa de Retorno

| Benefício | Descrição |
|-----------|-------------|
| Interface fluente | Permite encadeamento de chamadas de método |
| Consistência | Padrão previsível em toda codebase |
| Composição | Facilita composição de operações |
| Legibilidade | Código mais expressivo e declarativo |

## Padrões de Implementação

| Padrão | Uso |
|--------|-----|
| Método público | Métodos acessíveis externamente |
| Método com Symbol | Métodos privados ou contratos usando bracket notation |
| Método com decorator | Métodos decorados com event handlers ou lifecycle hooks |
| Método async | Métodos que executam operações assíncronas |

## Decorators Associados

| Decorator | Função |
|-----------|---------|
| on.{event} | Vincular método a evento DOM específico |
| connected | Executar método quando componente é conectado ao DOM |
| disconnected | Executar método quando componente é desconectado do DOM |
| didPaint | Executar método após renderização completa |
| before | Executar lógica antes do método principal |
| after | Executar lógica após o método principal |
| around | Executar lógica ao redor do método principal |

## Nomenclatura

| Regra | Descrição |
|-------|-------------|
| Verbo imperativo | Nome deve começar com verbo indicando ação |
| Intenção clara | Nome revela o que o método faz sem necessidade de comentário |
| Específico | Evitar nomes genéricos que não expressam intenção real |
| Conciso | Nome curto mas suficientemente descritivo |

## Exemplos

```typescript
// ❌ Bad — método sem retorno (não encadeia)
class QueryBuilder {
  where(condition: string) {
    this.conditions.push(condition)
    // retorno undefined implícito
  }
}
const q = new QueryBuilder()
q.where('id = 1')
q.where('status = active')  // chamadas separadas

// ✅ Good — método retorna this para encadeamento
class QueryBuilder {
  where(condition: string): this {
    this.conditions.push(condition)
    return this
  }
}
const q = new QueryBuilder()
  .where('id = 1')
  .where('status = active')  // interface fluente
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Múltiplas responsabilidades | Método deve ter responsabilidade única (rule 010) |
| Lógica complexa | Complexidade ciclomática máxima de 5 (rule 022) |
| Efeitos colaterais ocultos | Efeitos colaterais devem ser explícitos no nome |
| Parâmetros excessivos | Máximo 3 parâmetros por método (rule 033) |
| Método muito longo | Máximo 15 linhas por método (rule 007) |
| Usar else | Usar guard clauses ao invés de else (rule 002) |

## Melhores Práticas

| Prática | Descrição |
|---------|-------------|
| Retornar this | Habilitar interface fluente em métodos que modificam estado |
| Usar Symbol | Encapsular métodos privados com bracket notation |
| Nome descritivo | Verbo imperativo revelando intenção clara |
| Guard clauses | Usar retornos antecipados ao invés de else (rule 002) |
| Extrair complexidade | Métodos auxiliares para lógica complexa |

## Justificativa

- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada método tem responsabilidade única, expressa claramente no nome
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): métodos simples e previsíveis com complexidade ciclomática máxima de 5
- [033 - Limite de Parâmetros por Função](../../rules/033_limite-parametros-funcao.md): máximo 3 parâmetros para manter clareza
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): métodos com máximo 15 linhas
- [002 - Proibição de Else](../../rules/002_proibicao-clausula-else.md): usar guard clauses para reduzir aninhamento e complexidade
