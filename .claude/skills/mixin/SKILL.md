---
name: mixin
description: Convenção para uso de mixins para composição de comportamento em Web Components. Use ao criar ou modificar componentes que precisam de funcionalidades reutilizáveis, compor comportamentos sem herança múltipla, ou revisar código com classes base inchadas.
model: sonnet
allowed-tools: Read, Write, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Mixin

Convenção para uso de mixins para composição de comportamento.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar ou modificar Web Components que precisam de funcionalidades reutilizáveis; ao compor comportamentos sem herança múltipla; ao revisar classes base com responsabilidades inchadas |
| **Prerequisites** | Conhecimento de Web Components (HTMLElement, Shadow DOM); skill `anatomy`; skill `constructor` |
| **Constraints** | Echo deve estar sempre na cadeia de mixins para o sistema de eventos funcionar; ordem de aplicação importa (direita para esquerda); cada mixin deve ter responsabilidade única (rule 010) |
| **Scope** | Catálogo de mixins disponíveis (Align, Color, Disabled, Headless, Height, Hidden, Reaval, Width), regras de composição e combinações comuns |

---

## Quando Usar

Use ao criar ou modificar componentes que precisam de funcionalidades reutilizáveis.

## Princípio

| Princípio | Descrição |
|-----------|-------------|
| Composição | Adicionar comportamentos através de composição, não herança |
| Reuso | Compartilhar funcionalidades entre diferentes componentes |

## Mixins Disponíveis

| Mixin | Propósito | Funcionalidade |
|-------|---------|----------------|
| Align | Alinhamento | Controla alinhamento de conteúdo |
| Color | Coloração | Gerencia esquema de cores do componente |
| Disabled | Desabilitação | Adiciona estado desabilitado |
| Headless | Invisibilidade | Remove visualização do componente |
| Height | Altura | Controla dimensão vertical |
| Hidden | Visibilidade | Gerencia visibilidade do componente |
| Reaval | Revelação | Comportamento de auto-scroll |
| Width | Largura | Controla dimensão horizontal |

## Aplicação

| Aspecto | Descrição |
|--------|-------------|
| Ordem | Aplicados da direita para esquerda |
| Base | Sempre iniciar com classe base (HTMLElement ou Echo) |
| Encadeamento | Encapsular classes em sequência lógica |
| Herança | Mixin recebe classe e retorna classe estendida |

## Categorias de Mixin

| Categoria | Mixins | Uso |
|----------|--------|-----|
| Layout | Width, Height, Align | Dimensionamento e posicionamento |
| Estado | Disabled, Hidden | Controle de estado do componente |
| Aparência | Color | Estilização visual |
| Comportamento | Headless, Reaval | Funcionalidades especiais |

## Seleção de Mixin

| Necessidade | Mixin Recomendado |
|-------------|-------------------|
| Controle responsivo de largura | Width |
| Controle responsivo de altura | Height |
| Desabilitar interação | Disabled |
| Esconder componente | Hidden |
| Remover renderização | Headless |
| Aplicar tema de cor | Color |
| Alinhar conteúdo | Align |
| Auto-scroll ao revelar | Reaval |

## Regras

| Regra | Descrição |
|-------|-------------|
| Echo obrigatório | Echo deve estar na cadeia para eventos funcionarem |
| Ordem importa | Aplicação segue ordem direita-para-esquerda |
| Campos privados | Mixins usam campos privados para estado interno |
| Getters/Setters | Propriedades expostas via getter/setter |
| AttributeChanged | Sincronização com atributos HTML |
| Internals | Mixins podem usar Custom Element internals |

## Combinações Comuns

| Tipo de Componente | Combinação Sugerida |
|--------------------|---------------------|
| Botão interativo | Disabled, Width, Hidden, Echo |
| Texto estilizado | Color, Align, Hidden, Echo |
| Container de layout | Width, Height, Hidden, Echo |
| Componente invisível | Headless, Echo |
| Card responsivo | Width, Hidden, Echo |

## Características de Mixin

| Característica | Descrição |
|----------------|-------------|
| Não-invasivo | Não modifica comportamento existente |
| Componível | Podem ser livremente combinados |
| Isolado | Cada mixin tem responsabilidade única |
| Reativo | Respondem a mudanças de atributos |
| Testável | Podem ser testados isoladamente |

## Exemplos

```typescript
// ❌ Bad — herança para reuso (acoplamento)
class LoggingBase {
  log(msg: string) { console.log(msg) }
}
class ValidationBase extends LoggingBase {
  validate(v: unknown) { /* ... */ }
}
class UserComponent extends ValidationBase { /* herda tudo */ }

// ✅ Good — Mixin para composição sem herança
const WithLogging = (Base: typeof HTMLElement) => class extends Base {
  log(msg: string) { console.log(`[${this.tagName}]`, msg) }
}
const WithValidation = (Base: typeof HTMLElement) => class extends Base {
  validate(v: unknown) { return v !== null && v !== undefined }
}

class UserComponent extends WithValidation(WithLogging(HTMLElement)) {
  // compõe apenas o que precisa
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Mixin sem Echo na cadeia | Echo é necessário para sistema de eventos funcionar |
| Ordem incorreta de aplicação | Ordem importa, lembrar que aplica direita-para-esquerda |
| Mixin com múltiplas responsabilidades | Cada mixin deve ter responsabilidade única (rule 010) |
| Duplicar lógica de mixin | Usar mixins existentes ao invés de recriar comportamento (rule 021) |
| Mixins com acoplamento | Mixins devem ser independentes e componíveis |

## Justificativa

- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada mixin tem responsabilidade única
- [016 - Princípio do Fechamento Comum](../../rules/016_principio-fechamento-comum.md): comportamentos relacionados encapsulados juntos
- [021 - Proibição da Duplicação de Lógica](../../rules/021_proibicao-duplicacao-logica.md): mixins eliminam duplicação de comportamento
