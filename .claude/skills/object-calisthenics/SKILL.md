---
name: object-calisthenics
description: "9 regras de Object Calisthenics (Jeff Bay) para melhorar código OOP. Use quando @coder implementa rules 001-009, ou @architect verifica conformidade com Object Calisthenics em classes e métodos."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Object Calisthenics

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao implementar classes, métodos e estruturas OOP; ao verificar conformidade com as 9 regras em code reviews; como checklist para identificar code smells em código existente |
| **Prerequisites** | Conceitos fundamentais de OOP (classes, herança, encapsulamento, polimorfismo) |
| **Constraints** | Não aplicar mecanicamente sem entender o problema que cada regra resolve; regra 3 (Wrap Primitives) tem exceções para primitivos genéricos sem domínio |
| **Scope** | As 9 regras de Object Calisthenics (Jeff Bay) mapeadas para rules 001–009 deMGoncalves |

---

## O que é

Object Calisthenics é um conjunto de 9 regras criado por Jeff Bay para treinar desenvolvedores a escrever código orientado a objetos de melhor qualidade. Assim como exercícios calistênicos fortalecem o corpo, essas regras fortalecem o design orientado a objetos.

## Quando Usar

- **@coder implementando features**: Aplicar durante escrita de classes, métodos e estruturas OOP
- **@architect verificando código**: Validar conformidade com as 9 regras em code reviews
- **Refatoração**: Usar como checklist para identificar code smells em código existente
- **Onboarding**: Ensinar novos desenvolvedores sobre princípios OOP

## Regras de Object Calisthenics

| # | Nome | Rule ID | Arquivo |
|---|------|---------|---------|
| 1 | Nível Único de Indentação | 001 | [rule-01-single-indentation.md](references/rule-01-single-indentation.md) |
| 2 | Proibição de ELSE | 002 | [rule-02-no-else.md](references/rule-02-no-else.md) |
| 3 | Encapsulamento de Primitivos | 003 | [rule-03-wrap-primitives.md](references/rule-03-wrap-primitives.md) |
| 4 | Coleções de Primeira Classe | 004 | [rule-04-first-class-collections.md](references/rule-04-first-class-collections.md) |
| 5 | Um Ponto por Linha | 005 | [rule-05-one-dot-per-line.md](references/rule-05-one-dot-per-line.md) |
| 6 | Proibição de Abreviações | 006 | [rule-06-no-abbreviations.md](references/rule-06-no-abbreviations.md) |
| 7 | Classes Pequenas | 007 | [rule-07-small-classes.md](references/rule-07-small-classes.md) |
| 8 | Proibição de Getters/Setters | 008 | [rule-08-no-getters-setters.md](references/rule-08-no-getters-setters.md) |
| 9 | Diga, Não Pergunte | 009 | [rule-09-tell-dont-ask.md](references/rule-09-tell-dont-ask.md) |

## Guia Rápido: Qual Regra Aplicar

```
Método com if dentro de for?                  → Regra 1: Indentação Única
Método com else?                              → Regra 2: Sem Else
Recebe string/number para Email/CPF?          → Regra 3: Encapsular Primitivos
Retorna Array[] de método de domínio?         → Regra 4: Coleções de Primeira Classe
Chama a.getB().getC()?                        → Regra 5: Um Ponto por Linha
Variável chamada "usr" ou "calc"?             → Regra 6: Sem Abreviações
Classe com 100+ linhas?                       → Regra 7: Classes Pequenas
Método chamado getStatus() ou setName()?      → Regra 8: Sem Getters/Setters
Pergunta estado para decidir ação?            → Regra 9: Diga, Não Pergunte
```

## Proibições

Essas combinações violam **múltiplas** regras simultaneamente:

```typescript
// ❌ Viola Regras 1, 2, 5, 8
class UserManager {
  processUser(userId: string) {  // Viola Regra 3
    if (this.db.getUser(userId).getStatus() === 'active') {  // Viola Regras 1, 5, 8
      if (this.config.getFeatureFlag('premium')) {  // Viola Regras 1, 2
        // lógica aninhada...
      } else {
        // mais lógica...
      }
    }
  }
}
```

✅ **Correto**: cada violação deve ser corrigida aplicando a regra correspondente.

## Justificativa

Object Calisthenics reforça princípios SOLID e Clean Code:

- **Regras 001-002**: reduzem Complexidade Ciclomática (KISS)
- **Regras 003-004**: reforçam Encapsulamento (OOP fundamental)
- **Regras 005, 008-009**: aplicam Lei de Demeter (baixo acoplamento)
- **Regra 006**: aumenta legibilidade (Clean Code)
- **Regra 007**: reforça SRP (Princípio da Responsabilidade Única)

### Links para Rules deMGoncalves

- Regra 001: [ESTRUTURAL-001](../../rules/001_nivel-unico-indentacao.md)
- Regra 002: [COMPORTAMENTAL-002](../../rules/002_proibicao-clausula-else.md)
- Regra 003: [CRIACIONAL-003](../../rules/003_encapsulamento-primitivos.md)
- Regra 004: [ESTRUTURAL-004](../../rules/004_colecoes-primeira-classe.md)
- Regra 005: [ESTRUTURAL-005](../../rules/005_maximo-uma-chamada-por-linha.md)
- Regra 006: [ESTRUTURAL-006](../../rules/006_proibicao-nomes-abreviados.md)
- Regra 007: [ESTRUTURAL-007](../../rules/007_limite-maximo-linhas-classe.md)
- Regra 008: [COMPORTAMENTAL-008](../../rules/008_proibicao-getters-setters.md)
- Regra 009: [COMPORTAMENTAL-009](../../rules/009_diga-nao-pergunte.md)

**Skills relacionadas:**
- [`solid`](../solid/SKILL.md) — complementa: ambos formam o núcleo OOP (rules 001-014)
- [`package-principles`](../package-principles/SKILL.md) — complementa: princípios de pacote dependem de OC aplicado
- [`clean-code`](../clean-code/SKILL.md) — reforça: OC é subconjunto das práticas Clean Code

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
