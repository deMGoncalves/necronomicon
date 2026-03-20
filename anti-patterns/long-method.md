---
titulo: Long Method (Método Longo)
aliases:
  - Long Method
  - Método Longo
tipo: anti-pattern
id: AP-11
severidade: 🟠 Alto
origem: refactoring
tags: [anti-pattern, estrutural, responsabilidade, complexidade]
criado: 2026-03-20
relacionados:
  - "[[large-class]]"
  - "[[the-blob]]"
  - "[[limite-parametros-funcao]]"
  - "[[priorizacao-simplicidade-clareza]]"
---

# Long Method (Método Longo)

*Long Method*

---

## Definição

Função ou método com linhas demais, realizando múltiplas tarefas em sequência. Fowler: quanto mais longa a função, mais difícil de entender. Funções curtas com bons nomes são auto-documentadas.

## Sintomas

- Funções com mais de 20–30 linhas
- Necessidade de comentários separando "seções" dentro da função
- Múltiplos níveis de abstração misturados: I/O, validação, cálculo, formatação
- Impossível de testar sem setup complexo
- Mais de um ponto de retorno com lógica diferente em cada

## Causas Raiz

- Crescimento incremental: cada nova feature adiciona linhas ao que já existe
- Relutância em criar funções novas: "é só mais um if"
- Falta de refatoração contínua
- Confusão entre "uma função" e "um caso de uso inteiro"

## Consequências

- Difícil de entender à primeira leitura
- Difícil de testar: um test case precisa cobrir múltiplos caminhos
- Alta probabilidade de bugs ocultos em caminhos não testados
- Reuso impossível: lógica valiosa enterrada no meio de uma função longa

## Solução / Refatoração

Aplicar **Extract Function** (Fowler): identificar blocos com um propósito claro, extraí-los em funções com nomes descritivos. Regra: se você sente necessidade de comentar uma seção, extraia-a em uma função com aquele nome.

## Exemplo — Problemático

```javascript
// ❌ Uma função que faz validação, transformação, persistência e notificação
async function registerUser(data) {
  // validação
  if (!data.email) throw new Error('Email obrigatório');
  if (!data.email.includes('@')) throw new Error('Email inválido');
  if (!data.password || data.password.length < 8) throw new Error('Senha fraca');

  // transformação
  const hashedPassword = await bcrypt.hash(data.password, 10);
  const slug = data.name.toLowerCase().replace(/\s+/g, '-');

  // persistência
  const user = await db.users.create({ ...data, password: hashedPassword, slug });

  // notificação
  await emailService.send(user.email, 'Bem-vindo!', welcomeTemplate(user));
  await analyticsService.track('user_registered', { userId: user.id });

  return user;
}
```

## Exemplo — Refatorado

```javascript
// ✅ Cada responsabilidade em sua própria função
async function registerUser(data) {
  validateUserData(data);
  const prepared = await prepareUserData(data);
  const user = await db.users.create(prepared);
  await notifyRegistration(user);
  return user;
}
```

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — CC ≤ 5 por método
- [[001_single-responsibility-principle]] — função faz uma coisa

## Relacionados

- [[large-class]] — Long Methods acumulados formam Large Classes
- [[the-blob]] — Large Classes com Long Methods são The Blob
- [[divergent-change]] — Long Methods com múltiplas responsabilidades sofrem divergent change
