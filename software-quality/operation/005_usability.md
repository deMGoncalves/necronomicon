# Usability (Usabilidade)

**Dimensão**: Operação
**Severidade Default**: 🟡 Suggestion

---

## Pergunta Chave

**Ele é fácil de usar?**

## Definição

O esforço necessário para aprender, operar, preparar entradas e interpretar saídas do software. Usabilidade abrange a clareza da interface, mensagens de erro compreensíveis, feedback ao usuário e acessibilidade.

## Critérios de Verificação

- [ ] Mensagens de erro são claras e acionáveis
- [ ] Feedback visual para operações longas (loading states)
- [ ] Nomenclatura consistente na interface
- [ ] Acessibilidade básica (ARIA labels, contraste)
- [ ] Fluxos de usuário são intuitivos
- [ ] Documentação/help disponível

## Indicadores de Problema

### Exemplo 1: Mensagem de Erro Genérica

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

### Exemplo 2: Operação Sem Feedback

```javascript
// ❌ Não usável - sem feedback de loading
async function handleSubmit() {
  await api.createOrder(formData);
  navigate('/success');
}

// ✅ Usável - com feedback visual
async function handleSubmit() {
  setIsLoading(true);
  try {
    await api.createOrder(formData);
    showSuccess('Pedido criado com sucesso!');
    navigate('/success');
  } finally {
    setIsLoading(false);
  }
}
```

### Exemplo 3: Validação Tardia

```javascript
// ❌ Não usável - valida apenas no submit
function handleSubmit() {
  const errors = validateForm(formData);
  if (errors.length > 0) {
    showErrors(errors); // Usuário só descobre erros ao final
  }
}

// ✅ Usável - validação em tempo real
function handleFieldChange(field, value) {
  const error = validateField(field, value);
  setFieldError(field, error); // Feedback imediato
}
```

### Exemplo 4: Nomenclatura Inconsistente

```javascript
// ❌ Não usável - termos inconsistentes
<Button>Salvar</Button>     // Em um lugar
<Button>Gravar</Button>     // Em outro
<Button>Confirmar</Button>  // Em outro

// ✅ Usável - terminologia consistente
<Button>Salvar</Button>     // Sempre o mesmo termo
<Button>Salvar</Button>
<Button>Salvar</Button>
```

## Sinais de Alerta em Code Review

1. **Mensagens de erro** usando `error.message` diretamente para o usuário
2. **Operações assíncronas** sem indicador de loading
3. **Formulários** sem validação em tempo real
4. **Botões** sem estado disabled durante processamento
5. **Ações destrutivas** sem confirmação
6. **Links/Botões** sem texto descritivo (apenas ícones)

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Erros genéricos | Usuário não sabe como resolver |
| Sem loading | Usuário clica múltiplas vezes |
| Validação tardia | Frustração e abandono |
| Interface confusa | Tickets de suporte |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Ação destrutiva sem confirmação | 🟠 Important |
| Mensagem de erro técnica exposta | 🟠 Important |
| Falta de loading em operação longa | 🟡 Suggestion |
| Inconsistência visual menor | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// UX: Adicionar feedback visual durante o carregamento
// UX: Mensagem de erro deve ser mais específica

// TODO: Implementar validação em tempo real
// TODO: Adicionar confirmação antes de deletar
```

## Exemplo de Comentário em Review

```
El mensaje de error muestra `error.message` directo al usuario:

showError(error.message); // ❌ Puede mostrar "ECONNREFUSED"

Mejor usar mensajes amigables:

showError('No pudimos procesar tu solicitud. Intenta de nuevo.');

🟡 Mejora de UX sugerida
```

## Rules Relacionadas

- [object-calisthenics/006 - No Abbreviations](../../object-calisthenics/006_proibicao-nomes-abreviados.md)
- [clean-code/014 - Naming](../../clean-code/014_nomes-classes-metodos-consistentes.md)

## Patterns Relacionados

- [gof/behavioral/002 - Command](../../gof/behavioral/002_command.md): para undo/redo
- [gof/behavioral/006 - Memento](../../gof/behavioral/006_memento.md): para estados anteriores

---

**Criada em**: 2026-03-18
**Versão**: 1.0
