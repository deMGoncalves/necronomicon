---
name: anatomy
description: Convenção para organização de membros dentro de uma classe. Use ao criar ou refatorar classes, Web Components ou módulos JavaScript — sempre que a ordem de declaração de membros precisar ser validada ou corrigida.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Anatomy

Convenção para organização de membros dentro de uma classe.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Criação ou refatoração de qualquer classe, Web Component ou módulo JavaScript/TypeScript com múltiplos membros |
| **Prerequisites** | Entendimento da distinção entre membros privados (`#`), getters/setters, constructor, métodos de instância e métodos estáticos |
| **Constraints** | Não aplica a objetos literais ou funções puras; a ordem de 7 grupos é fixa e não pode ser reordenada por preferência |
| **Scope** | Ordem de declaração dos 7 grupos de membros dentro de uma classe: privados → getters/setters → getters/setters estáticos → constructor → métodos → métodos estáticos → bloco static |

---

## Quando Usar

Use ao criar ou refatorar classes para ordenar membros corretamente.

## Estrutura

| Ordem | Membro | Ordenação |
|-------|--------|-----------|
| 1 | Membros privados (`#name`) | Alfabética |
| 2 | Getters e Setters | Alfabética |
| 3 | Getters e Setters estáticos | Alfabética |
| 4 | Constructor | - |
| 5 | Métodos | Alfabética |
| 6 | Métodos estáticos | Alfabética |
| 7 | Bloco `static {}` | - |

## Regras Adicionais

- Getters e setters do mesmo nome ficam juntos (getter primeiro)
- Dentro de cada grupo, ordenar alfabeticamente por nome
- Membros privados usam prefixo `#`

## Exemplos

```typescript
// ❌ Ruim — ordem incorreta
class UserService {
  constructor(private repo: UserRepository) {}

  get name() { return this.#name }

  #name = ''

  findById(id: string) { return this.repo.find(id) }

  static create() { return new UserService(new UserRepository()) }
}

// ✅ Bom — seguindo Anatomy
class UserService {
  // 1. Private
  #name = ''

  // 2. Getters/Setters
  get name() { return this.#name }

  // 3. Constructor
  constructor(private repo: UserRepository) {}

  // 4. Métodos
  findById(id: string) { return this.repo.find(id) }

  // 5. Static
  static create() { return new UserService(new UserRepository()) }
}
```

## Proibições

| O que evitar | Motivo |
|--------------|--------|
| Ordenar métodos por uso ou frequência | Dificulta localização, usar ordem alfabética (rule 022) |
| Misturar membros privados e públicos | Separação clara facilita compreensão (rule 010) |
| Colocar getters e setters em locais diferentes | Par getter/setter deve ficar junto para coesão |
| Classe com mais de 50 linhas | Viola rule 007, extrair responsabilidades |

## Justificativa

- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): código previsível reduz custo cognitivo, estrutura consistente facilita leitura
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): organização facilita identificar responsabilidades de cada membro
- [007 - Restrição de Linhas em Classes](../../rules/007_restricao-linhas-classes.md): classe com máximo de 50 linhas, métodos com máximo de 15 linhas
