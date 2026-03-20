---
titulo: Overengineering (Complexidade Desnecessária)
aliases:
  - Overengineering
  - Gold Plating
  - Complexidade Acidental
tipo: anti-pattern
id: AP-08
severidade: 🟠 Alto
origem: clean-code
tags: [anti-pattern, arquitetura, complexidade, yagni]
criado: 2026-03-20
relacionados:
  - "[[clever-code]]"
  - "[[speculative-generality]]"
  - "[[proibicao-funcionalidade-especulativa]]"
  - "[[priorizacao-simplicidade-clareza]]"
---

# Overengineering (Complexidade Desnecessária)

*Overengineering / Gold Plating*

---

## Definição

Projetar ou implementar uma solução muito mais complexa do que o problema exige. Adicionar abstrações, camadas, padrões de design, sistemas de plugin ou configurabilidade antes de haver evidência de necessidade real.

## Sintomas

- Interfaces com um único implementador "para facilitar testes futuros"
- Sistemas de configuração para algo que nunca vai mudar
- Abstrações de 5 camadas para uma operação CRUD
- Design Patterns aplicados onde código direto funcionaria
- "Eu fiz genérico para poder reusar depois"

## Causas Raiz

- Medo do futuro: "e se precisarmos suportar X?"
- Viés de engenharia: prazer em resolver problemas complexos mesmo que desnecessário
- Cargo cult: aplicar padrões de empresas grandes em problemas pequenos
- Cultura de revisão que valoriza complexidade como sinal de competência

## Consequências

- Tempo de desenvolvimento maior sem valor proporcional entregue
- Codebase difícil de entender e manter
- Onboarding mais lento: mais conceitos para aprender antes de contribuir
- Flexibilidade imaginária: o código aceita mudanças que nunca acontecem

## Solução / Refatoração

Aplicar YAGNI e KISS como filtros de design. Começar sempre com a solução mais simples que resolve o problema atual. Adicionar complexidade apenas quando a necessidade for demonstrada por um caso real — não antecipada.

## Exemplo — Problemático

```javascript
// ❌ Sistema de plugin para salvar um usuário no banco
class UserRepository {
  constructor(storageStrategy) { this.strategy = storageStrategy; }
  save(user) { return this.strategy.persist(user); }
}

class DatabaseStorageStrategy {
  constructor(adapterFactory) { this.adapter = adapterFactory.create(); }
  persist(user) { return this.adapter.execute('INSERT', user); }
}

// Nunca houve outro storage. Nunca haverá.
```

## Exemplo — Refatorado

```javascript
// ✅ Direto ao ponto — refatora quando a necessidade for real
async function saveUser(user) {
  return db.users.create(user);
}
```

## Rules que Previnem

- [[proibicao-funcionalidade-especulativa]] — YAGNI: não construa o que não é necessário
- [[priorizacao-simplicidade-clareza]] — KISS: prefira a solução mais simples

## Relacionados

- [[clever-code]] — Overengineering frequentemente usa Clever Code para justificar a complexidade
- [[speculative-generality]] — code smell que descreve o mesmo problema no nível de classe
- [[golden-hammer]] — Golden Hammer leva a Overengineering ao aplicar soluções pesadas
