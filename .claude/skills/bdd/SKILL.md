---
name: bdd
description: Template BDD com Gherkin em pt-BR para especificação comportamental. Use quando @architect precisa criar features Gherkin em docs/bdd/, quando @tester precisa entender os cenários de teste ou ao definir critérios de aceite em linguagem de negócio.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# BDD (Behavior-Driven Development)

Template Gherkin em português brasileiro para especificar comportamento esperado do sistema.

---

## Quando Usar

- Fase 2 (Spec): @architect cria .feature files em docs/bdd/ para cada comportamento
- Fase 3 (Code): @tester usa os .feature files como referência para criar testes
- Ao especificar regras de negócio complexas de forma executável

## Template de Feature

→ Consulte [`references/feature-template.md`](references/feature-template.md) para o template completo.

## Convenções do Projeto

- **Idioma:** pt-BR obrigatório (`# language: pt`)
- **Verbos:** Sempre no presente ("usuário vê", "sistema envia")
- **Personas:** Use nomes reais (João, Maria) em vez de abstrações (user1, user2)
- **Nome do arquivo:** `NNN_nome-kebab-case.feature`
- **Um arquivo por comportamento/regra de negócio**
- **Cenário feliz sempre primeiro**, cenários de erro depois
- **Manter README.md** em docs/bdd/ com índice das features

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

## Relação BDD com Testes

- Cada Cenário → 1 teste unitário/integração
- Esquema do Cenário → testes parametrizados
- @tester implementa testes seguindo exatamente a estrutura Dado/Quando/Então

## Exemplos

```gherkin
# ❌ Ruim — cenário técnico, sem linguagem de negócio
Scenario: POST /users retorna 201
  Given a request with body { "name": "Alice", "email": "alice@example.com" }
  When POST /users is called
  Then response status is 201
  And response body contains user id

// Problemas:
// - Foca em HTTP/API (implementação) em vez de comportamento de negócio
// - Não descreve o "por quê" — qual valor isso entrega ao usuário?
// - Não é legível por não-técnicos (PO, negócio)

---

# ✅ Bom — cenário em linguagem de negócio (pt-BR)
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

// Benefícios:
// ✅ Linguagem de negócio: PO e stakeholders entendem sem conhecer código
// ✅ Foca no "o quê" e "por quê", não no "como" técnico
// ✅ Esquema do Cenário parametriza validações sem duplicar estrutura
```

```gherkin
# ❌ Ruim — cenário misturando níveis de abstração
Scenario: Transferência entre contas
  Given que a conta 123 tem saldo de 1000
  And que a conta 456 existe no banco de dados
  When faço POST /transfer com { from: 123, to: 456, amount: 500 }
  Then o saldo da conta 123 deve ser 500
  And o saldo da conta 456 deve ser 500
  And a tabela transactions deve ter novo registro

// Problemas:
// - Mistura "conta 123" (abstrato) com "POST /transfer" (implementação)
// - Menciona "tabela transactions" (detalhe de persistência)
// - Não descreve o comportamento esperado do ponto de vista do usuário

---

# ✅ Bom — cenário focado no comportamento de negócio
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

// Benefícios:
// ✅ Abstração correta: "João", "Maria" (personas) em vez de IDs
// ✅ Foco no comportamento: "transferência concluída" em vez de detalhes de API
// ✅ Comprovante de transação = expectativa do usuário (não detalhe de persistência)
```

## Proibições

- ❌ Features em inglês — obrigatório pt-BR
- ❌ Cenários técnicos (HTTP status, SQL, IDs numéricos)
- ❌ Abstrações genéricas ("user1", "account A") — use personas (João, Maria)
- ❌ Misturar níveis de abstração (negócio + implementação)
- ❌ Cenários sem "Como/Quero/Para" no cabeçalho da Funcionalidade

## Fundamentação

- [032 - Cobertura Mínima de Teste](../../rules/032_cobertura-teste-minima-qualidade.md): BDD features definem os cenários que @tester deve cobrir
- Fonte: Dan North - Introducing BDD (2006)
