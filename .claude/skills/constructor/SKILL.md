---
name: constructor
description: Convenção para estrutura de constructor em Web Components. Use ao criar Web Components personalizados, ao implementar constructors de Custom Element, ou ao revisar código que viola sequência de inicialização do constructor.
model: sonnet
allowed-tools: Read, Write, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Constructor

Convenção para estrutura de constructor em Web Components.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Criação ou modificação de qualquer Web Component (`extends HTMLElement`); implementação do constructor de um Custom Element |
| **Prerequisites** | Entendimento do ciclo de vida de Custom Elements (`constructor` → `connectedCallback` → `attributeChangedCallback`); skill `anatomy` para posicionamento correto do constructor na classe |
| **Constraints** | Proibido acessar atributos, DOM externo ou fazer chamadas de API no constructor; constructor deve ser sempre síncrono; componentes headless não devem ter constructor definido |
| **Scope** | Sequência de inicialização (`super()` → Shadow DOM → operações síncronas mínimas); configuração de `delegatesFocus`; categorias de componente (visual, headless, interativo) |

---

## Quando Usar

Use ao criar ou modificar constructors de componentes personalizados.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Inicialização | Constructor configura apenas estrutura básica do componente |
| Simplicidade | Lógica mínima no constructor, apenas setup essencial |

## Regras Básicas

| Regra | Descrição |
|-------|-----------|
| Super first | Sempre chamar super() como primeira linha |
| Shadow DOM | Criar Shadow DOM se componente tem visualização |
| Sem lógica complexa | Evitar cálculos ou operações pesadas |
| Sem acesso ao DOM | Não acessar atributos ou DOM externo |
| Síncrono | Constructor deve sempre ser síncrono |

## Tipos de Constructor

### Componente Visual

| Aspecto | Configuração |
|---------|--------------|
| Super | Chamada obrigatória |
| Shadow DOM | Criar com attachShadow |
| Mode | Sempre open |
| DelegatesFocus | true para componentes interativos |

### Componente Headless

| Aspecto | Configuração |
|---------|--------------|
| Constructor | Não definir (omitir) |
| Mixin | Usar Headless |
| Shadow DOM | Não criar |
| Propósito | Componentes de comportamento/lógica |

## DelegatesFocus

| Usar true | Usar false/omitir |
|-----------|-------------------|
| Componentes com elementos focáveis | Componentes apenas visuais |
| Botões e links | Ícones e imagens |
| Inputs e formulários | Containers passivos |
| Labels e texto interativo | Decorações |
| Containers interativos | Separadores |

## Sequência de Execução

| Ordem | Ação | Obrigatória |
|-------|------|-------------|
| 1 | Chamar super() | Sim |
| 2 | Criar Shadow DOM | Se visual |
| 3 | Operações síncronas mínimas | Opcional |

## Exemplos

```typescript
// ❌ Bad — inicialização fora de ordem
class MyButton extends HTMLElement {
  constructor() {
    this.attachShadow({ mode: 'open' })  // erro: super() não chamado
    super()
    this.render()
  }
}

// ✅ Good — sequência correta
class MyButton extends HTMLElement {
  constructor() {
    super()
    this.attachShadow({ mode: 'open' })
    this.render()
  }
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Acessar atributos no constructor | Atributos ainda não processados pelo attributeChanged |
| Modificar DOM externo | Componente ainda não conectado ao DOM |
| Operações assíncronas | Constructor deve ser síncrono (rule 022) |
| Adicionar event listeners | Usar connected callback para garantir que componente está no DOM |
| Lógica de negócio | Pertence a métodos, constructor apenas inicializa estrutura (rule 010) |
| Chamadas de API | Usar connected callback ou métodos específicos |
| Constructor com mais de 15 linhas | Viola rule 007, simplificar inicialização |

## Opções de Shadow DOM

| Opção | Valores | Uso |
|-------|---------|-----|
| mode | open | Sempre usar open para acessibilidade |
| delegatesFocus | true/false | true para componentes interativos |

## Categorias de Componente

| Categoria | Shadow DOM | DelegatesFocus | Exemplo |
|-----------|------------|----------------|---------|
| Interativo | Sim | Sim | Button, Link, Label |
| Container | Sim | Sim | Card, Container |
| Visual | Sim | Não | Icon |
| Comportamental | Não | N/A | On, Redirect |

## API Internals

Componentes que precisam de Custom Element Internals (estados, associação de formulário) devem usar getter lazy:

```javascript
get internals() {
  return this.#internals ??= this.attachInternals()
}
```

## Justificativa

- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): constructor tem responsabilidade única de inicializar estrutura básica do componente
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): constructor simples e previsível, sem lógica complexa
- [007 - Restrição de Linhas em Classes](../../rules/007_restricao-linhas-classes.md): constructor deve ter máximo de 15 linhas
