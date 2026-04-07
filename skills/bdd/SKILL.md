---
name: bdd
description: BDD template with Gherkin in pt-BR for behavioral specification. Use when @architect needs to create Gherkin features in docs/bdd/, when @tester needs to understand test scenarios, or when defining acceptance criteria in business language.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# BDD (Behavior-Driven Development)

Gherkin template in Brazilian Portuguese to specify expected system behavior.

---

## When to Use

- Phase 2 (Spec): @architect creates .feature files in docs/bdd/ for each behavior
- Phase 3 (Code): @tester uses .feature files as reference to create tests
- When specifying complex business rules in executable form

## Feature Template

→ See [`references/feature-template.md`](references/feature-template.md) for the complete template.

## Project Conventions

- **Language:** pt-BR mandatory (`# language: pt`)
- **Verbs:** Always present tense ("user sees", "system sends")
- **Personas:** Use real names (João, Maria) instead of abstractions (user1, user2)
- **File name:** `NNN_kebab-case-name.feature`
- **One file per behavior/business rule**
- **Happy scenario always first**, error scenarios after
- **Maintain README.md** in docs/bdd/ with feature index

## Keywords in pt-BR

| Word | Usage |
|------|-------|
| Funcionalidade: | File/feature title |
| Cenário: | Individual test case |
| Esquema do Cenário: | Parameterized scenario with multiple examples |
| Contexto: | Setup shared by all scenarios |
| Dado | Precondition (initial state) |
| Quando | Action executed |
| Então | Expected result (assertion) |
| E | Continuation of Dado/Quando/Então |
| Mas | Negation/exception in Dado/Quando/Então |
| Exemplos: | Data table for Esquema do Cenário |

## BDD Relation with Tests

- Each Cenário → 1 unit/integration test
- Esquema do Cenário → parameterized tests
- @tester implements tests following exactly the Dado/Quando/Então structure

## Examples

```gherkin
# ❌ Bad — technical scenario, no business language
Scenario: POST /users returns 201
  Given a request with body { "name": "Alice", "email": "alice@example.com" }
  When POST /users is called
  Then response status is 201
  And response body contains user id

// Problems:
// - Focuses on HTTP/API (implementation) instead of business behavior
// - Doesn't describe the "why" — what value does this deliver to the user?
// - Not readable by non-technical people (PO, business)

---

# ✅ Good — scenario in business language (pt-BR)
# language: pt

Funcionalidade: Cadastro de usuário — RN-03

  Como um visitante do site
  Quero me cadastrar na plataforma
  Para poder fazer compras e acompanhar meus pedidos

  Contexto:
    Dado que não estou autenticado no sistema

  Cenário: Usuário se cadastra com dados válidos
    Dado que Alice quer se cadastrar na plataforma
    Quando ela preenche o nome "Alice Silva"
    E preenche o email "alice@example.com"
    E preenche a senha com 8 caracteres ou mais
    Então sua conta é criada com sucesso
    E ela recebe um email de boas-vindas no endereço fornecido
    E ela é automaticamente autenticada no sistema

  Cenário: Usuário tenta se cadastrar com email já existente
    Dado que já existe uma conta com o email "bob@example.com"
    Quando Bob tenta se cadastrar com o mesmo email "bob@example.com"
    Então o cadastro é rejeitado
    E ele vê a mensagem "Email já cadastrado"
    E ele não recebe email de boas-vindas

  Esquema do Cenário: Validações de senha inválida
    Dado que Carol quer se cadastrar
    Quando ela preenche nome e email válidos
    Mas preenche a senha com "<senha>"
    Então o cadastro é rejeitado
    E ela vê a mensagem "<erro>"

    Exemplos:
      | senha  | erro                                      |
      | 123    | Senha deve ter no mínimo 8 caracteres    |
      |        | Senha é obrigatória                       |
      | abc    | Senha deve ter no mínimo 8 caracteres    |

// Benefits:
// ✅ Business language: PO and stakeholders understand without knowing code
// ✅ Focuses on "what" and "why", not technical "how"
// ✅ Esquema do Cenário parameterizes validations without duplicating structure
```

```gherkin
# ❌ Bad — scenario mixing abstraction levels
Scenario: Transferência entre contas
  Given que a conta 123 tem saldo de 1000
  And que a conta 456 existe no banco de dados
  When faço POST /transfer com { from: 123, to: 456, amount: 500 }
  Then o saldo da conta 123 deve ser 500
  And o saldo da conta 456 deve ser 500
  And a tabela transactions deve ter novo registro

// Problems:
// - Mixes "conta 123" (abstract) with "POST /transfer" (implementation)
// - Mentions "tabela transactions" (persistence detail)
// - Doesn't describe expected behavior from user's point of view

---

# ✅ Good — scenario focused on business behavior
# language: pt

Funcionalidade: Transferência entre contas — RN-12

  Como titular de uma conta bancária
  Quero transferir dinheiro para outra conta
  Para pagar débitos ou enviar recursos

  Contexto:
    Dado que João possui uma conta corrente
    E Maria possui uma conta corrente

  Cenário: Transferência com saldo suficiente
    Dado que João tem saldo de R$ 1.000,00
    E Maria tem saldo de R$ 200,00
    Quando João transfere R$ 500,00 para a conta de Maria
    Então a transferência é concluída com sucesso
    E o saldo de João passa a ser R$ 500,00
    E o saldo de Maria passa a ser R$ 700,00
    E ambos recebem comprovante da transação

  Cenário: Tentativa de transferência sem saldo suficiente
    Dado que Pedro tem saldo de R$ 100,00
    Quando Pedro tenta transferir R$ 500,00 para outra conta
    Então a transferência é rejeitada
    E Pedro vê a mensagem "Saldo insuficiente"
    E o saldo de Pedro permanece R$ 100,00

  Esquema do Cenário: Validações de valor da transferência
    Dado que Ana tem saldo de R$ 1.000,00
    Quando Ana tenta transferir "<valor>" para outra conta
    Então a transferência é rejeitada
    E ela vê a mensagem "<erro>"

    Exemplos:
      | valor    | erro                                      |
      | R$ 0,00  | Valor deve ser maior que zero             |
      | R$ -50   | Valor não pode ser negativo               |

// Benefits:
// ✅ Correct abstraction: "João", "Maria" (personas) instead of IDs
// ✅ Focuses on behavior: "transferência concluída" instead of API details
// ✅ Transaction receipt = user expectation (not persistence detail)
```

## Prohibitions

- ❌ Features in English — pt-BR mandatory
- ❌ Technical scenarios (HTTP status, SQL, numeric IDs)
- ❌ Generic abstractions ("user1", "account A") — use personas (João, Maria)
- ❌ Mixing abstraction levels (business + implementation)
- ❌ Scenarios without "Como/Quero/Para" in Funcionalidade header

## Rationale

- [032 - Minimum Test Coverage](../../rules/032_cobertura-teste-minima-qualidade.md): BDD features define scenarios that @tester must cover
- Source: Dan North - Introducing BDD (2006)
