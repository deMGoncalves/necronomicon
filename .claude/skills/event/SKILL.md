---
name: event
description: Convenção para uso de eventos DOM e eventos customizados — ao criar event handlers, despachar eventos customizados, ou comunicar entre componentes via eventos DOM
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Event

Convenção para uso de eventos DOM e eventos customizados para interatividade e comunicação entre componentes.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Criação de event handlers em Web Components; despacho de eventos customizados; comunicação de mudanças de estado entre componentes via eventos DOM |
| **Prerequisites** | Skill `constructor` (event listeners proibidos no constructor); skill `bracket` para encapsulamento de handlers via Symbol; skill `enum` para nomes de eventos customizados como constantes |
| **Constraints** | Proibido adicionar listeners no constructor; handler deve ter responsabilidade única; modificadores devem ser funções puras sem efeitos colaterais; `bubbles: true` e `composed: true` obrigatórios em eventos customizados |
| **Scope** | Decorator `@on.{eventType}`, modificadores disponíveis (prevent, stop, value, formData, enter, detail), criação de `CustomEvent`, nomenclatura e boas práticas de dispatch |

---

## Quando Usar

Use ao criar event handlers que respondem a interações do usuário ou quando componentes precisam comunicar mudanças de estado.

## Princípio

| Princípio | Descrição |
|-----------|-------------|
| Comunicação desacoplada | Componentes se comunicam via eventos sem dependência direta |
| Reatividade | Componentes reagem a mudanças através de listeners |

## Decorator de Evento

| Aspecto | Descrição |
|--------|-------------|
| Sintaxe | `@on.{eventType}` |
| Tipos comuns | click, submit, input, keydown, change |
| Seletor | Parâmetro opcional para filtrar elemento alvo |
| Modificadores | Parâmetros adicionais para alterar comportamento do evento |
| Método alvo | Método decorado recebe evento ou dados transformados |

## Estrutura do Decorator

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| Seletor | String | Não | Seletor CSS para filtrar elemento alvo dentro do Shadow DOM |
| Modificadores | Function | Não | Funções que modificam evento antes de passar ao handler |

## Modificadores Disponíveis

| Modificador | Função | Uso |
|-------------|--------|-----|
| prevent | Previne comportamento padrão | Evitar submit de form, navegação de link |
| stop | Para propagação do evento | Prevenir evento de borbulhar pela árvore DOM |
| enter | Filtra apenas tecla Enter | Executar ação ao pressionar Enter |
| formData | Extrai dados de formulário | Transforma FormData em objeto |
| value | Extrai valor do target | Passar apenas valor do elemento |
| detail | Extrai detail de CustomEvent | Acessar dados de evento customizado |

## Ordem de Aplicação

| Ordem | Elemento |
|-------|---------|
| 1 | Tipo de evento |
| 2 | Seletor (opcional) |
| 3 | Modificadores (opcional, múltiplos permitidos) |

## Eventos Customizados

| Aspecto | Descrição |
|--------|-------------|
| Criação | Usar função customEvent do pacote @event |
| Type | String identificando o evento |
| Detail | Dados associados ao evento |
| Bubbles | Sempre true para permitir propagação |
| Cancelable | Sempre true para permitir prevenção |

## Dispatch de Evento

| Aspecto | Descrição |
|--------|-------------|
| Método | `this.dispatchEvent()` |
| Contexto | Chamado no componente que emite o evento |
| Propagação | Evento borbulha pela árvore DOM até ser capturado |
| Timing | Dispatch é síncrono, handlers executam imediatamente |

## Tipos de Evento

| Categoria | Eventos | Uso |
|----------|--------|-----|
| Mouse | click, dblclick, mousedown, mouseup | Interações de mouse |
| Teclado | keydown, keyup, keypress | Interações de teclado |
| Formulário | submit, change, input, reset | Manipulação de formulários |
| Foco | focus, blur, focusin, focusout | Gerenciamento de foco |
| Customizados | Nomes customizados | Comunicação entre componentes |

## Nomenclatura de Eventos Customizados

| Regra | Descrição |
|------|-------------|
| Minúsculas | Usar apenas letras minúsculas |
| Descritivo | Nome deve descrever o que aconteceu |
| Verbos no passado | Indica ação concluída (sent, clicked, changed) |
| Namespace | Usar prefixo para eventos específicos de domínio |

## Event Handlers

| Aspecto | Descrição |
|--------|-------------|
| Retorno | Retornar this para manter interface fluente |
| Async | Pode ser async se necessário |
| Parâmetro | Recebe evento ou dados transformados pelo modificador |
| Nome | Usar Symbol via bracket notation para encapsulamento |

## Exemplos

```typescript
// ❌ Bad — evento ad-hoc sem tipagem ou bubbling
element.dispatchEvent(new Event('change'))

// ✅ Good — evento customizado com detail, bubbles e composed
element.dispatchEvent(new CustomEvent('user:updated', {
  detail: { userId: '123', name: 'Alice' },
  bubbles: true,
  composed: true,
}))
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Event listeners no constructor | Constructor não deve acessar DOM (rule constructor) |
| Manipulação direta de DOM externo | Viola encapsulamento do Shadow DOM |
| Lógica complexa no handler | Extrair para métodos auxiliares (rule 010) |
| Efeitos colaterais não-explícitos | Handler deve ter responsabilidade clara |
| Modificar evento original | Modificadores devem retornar novo valor, não mutar |
| Múltiplas responsabilidades | Um handler por ação (rule 010) |

## Seletores

| Tipo | Descrição |
|------|-------------|
| Tag | Nome do elemento HTML |
| Classe | Seletor de classe CSS |
| ID | Seletor de ID |
| Atributo | Seletor de atributo |
| Wildcard | Asterisco para qualquer elemento |

## Melhores Práticas

| Prática | Descrição |
|---------|-------------|
| Usar Symbol para handlers | Encapsular métodos de evento com bracket notation |
| Combinar decorators | Empilhar múltiplos decorators quando necessário |
| Modificadores primeiro | Aplicar modificadores antes da lógica de negócio |
| Eventos nomeados | Criar constantes/enum para nomes de eventos customizados |
| Detail estruturado | Usar objetos com propriedades nomeadas em detail |

## Justificativa

- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada handler tem responsabilidade única, não misturar múltiplas ações em um handler
- [013 - Princípio de Segregação de Interface](../../rules/013_principio-segregacao-interface.md): eventos permitem comunicação sem acoplamento direto, componentes interagem via contratos de eventos
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): handlers simples e modificadores componíveis mantêm código previsível
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): event handlers devem ter máximo 15 linhas
