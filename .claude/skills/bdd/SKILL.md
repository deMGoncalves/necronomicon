---
name: bdd
description: Template BDD com Gherkin em pt-BR para especificação comportamental. Use quando @architect precisa criar features em docs/bdd/ ou @tester precisa entender cenários de teste.
model: haiku
allowed-tools: Read, Write, Edit
user-invocable: true
location: managed
---

# BDD (Behavior-Driven Development)

Template Gherkin em português brasileiro para especificar comportamento esperado do sistema.

---

## Quando Usar

- Fase 2 (Spec): @architect cria .feature files em docs/bdd/ para cada comportamento
- Fase 3 (Code): @tester usa os .feature files como referência para criar testes
- Ao especificar regras de negócio complexas de forma executável

## Template de Feature

```gherkin
# language: pt

Funcionalidade: [Nome da Funcionalidade — RN-XX]
  Como [papel/ator]
  Quero [ação ou capacidade]
  Para [objetivo ou benefício]

  Contexto:
    Dado que [estado inicial comum a todos os cenários]

  Cenário: [Nome descritivo do cenário feliz]
    Dado [estado inicial específico]
    Quando [ação executada]
    Então [resultado esperado]
    E [resultado adicional]

  Cenário: [Nome descritivo do cenário de erro]
    Dado [estado que causa erro]
    Quando [ação executada]
    Então [resultado de erro esperado]

  Esquema do Cenário: [Nome quando há variações de dados]
    Dado [estado com <variável>]
    Quando [ação com <outro>]
    Então [resultado com <esperado>]

    Exemplos:
      | variável | outro | esperado |
      | valor1   | val2  | res1     |
      | valor2   | val3  | res2     |
```

## Palavras-Chave em pt-BR

| Palavra | Uso |
|---------|-----|
| Funcionalidade: | Título do arquivo/feature |
| Cenário: | Caso de teste individual |
| Esquema do Cenário: | Cenário parametrizado com múltiplos exemplos |
| Contexto: | Setup compartilhado por todos os cenários |
| Dado | Pré-condição (estado inicial) |
| Quando | Ação executada |
| Então | Resultado esperado (assertion) |
| E | Continuação de Dado/Quando/Então |
| Mas | Negação/exceção em Dado/Quando/Então |
| Exemplos: | Tabela de dados para Esquema do Cenário |

## Convenções do Projeto

- Um arquivo .feature por comportamento/regra de negócio
- Nome do arquivo: `NNN_nome-kebab-case.feature`
- Referenciar RN (Regras de Negócio) no título da Funcionalidade
- Cenário feliz sempre primeiro, cenários de erro depois
- Manter README.md em docs/bdd/ com índice das features

## Relação BDD com Testes

- Cada Cenário → 1 teste unitário/integração
- Esquema do Cenário → testes parametrizados
- @tester implementa testes seguindo exatamente a estrutura Dado/Quando/Então

## Fundamentação

- [032 - Cobertura Mínima de Teste](../../rules/032_cobertura-teste-minima-qualidade.md): BDD features definem os cenários que @tester deve cobrir
- Fonte: Dan North - Introducing BDD (2006)
