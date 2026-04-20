# Usability — Usabilidade

**Dimensão:** Operação
**Severidade Default:** 🟡 Sugestão
**Pergunta Chave:** Ele é fácil de usar?

## O que é

O esforço necessário para aprender, operar, preparar entradas e interpretar saídas do software. Usabilidade abrange a clareza da interface, mensagens de erro compreensíveis, feedback ao usuário e acessibilidade.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Ação destrutiva sem confirmação | 🟠 Important |
| Mensagem de erro técnica exposta | 🟠 Important |
| Falta de loading em operação longa | 🟡 Suggestion |
| Inconsistência visual menor | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não usável - mensagem genérica
try {
  await saveUser(data);
} catch (error) {
  showError('Ocorreu um erro'); // O que aconteceu? O que fazer?
}

// ✅ Usável - mensagem específica e acionável
try {
  await saveUser(data);
} catch (error) {
  if (error.code === 'EMAIL_TAKEN') {
    showError('Este email já está em uso. Tente outro ou faça login.');
  } else if (error.code === 'NETWORK_ERROR') {
    showError('Sem conexão. Verifique sua internet e tente novamente.');
  } else {
    showError('Não foi possível salvar. Tente novamente em alguns minutos.');
  }
}
```

## Codetags Sugeridos

```javascript
// UX(034): Mensagem de erro deve ser mais específica
// UX: Adicionar feedback visual durante o carregamento
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Ação destrutiva sem confirmação | 🟠 Important |
| Mensagem de erro técnica exposta | 🟠 Important |
| Falta de loading em operação longa | 🟡 Suggestion |
| Inconsistência visual menor | 🟡 Suggestion |

## Rules Relacionadas

- 006 - Proibição de Nomes Abreviados
- 034 - Nomes de Classes e Métodos Consistentes
- 026 - Qualidade de Comentários
