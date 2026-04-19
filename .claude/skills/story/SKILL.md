---
name: story
description: Convenção para estrutura de stories no Storybook — ao criar ou atualizar stories no Storybook — ao estruturar stories de componentes com variantes, estados e documentação
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Story

Convenção para estrutura de stories no Storybook.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar ou atualizar stories no Storybook; ao estruturar stories de componentes com variantes, estados e documentação |
| **Prerequisites** | Storybook instalado e configurado no projeto; componente Web Component ou framework implementado; skill `anatomy` |
| **Constraints** | Arquivos de story devem ser JavaScript, não TypeScript; uma única story `Default` por arquivo; sem `play` functions ou testes de interação em stories (regra do projeto) |
| **Scope** | Estrutura de export default (configuração), argTypes (documentação), controles de UI e função `render` para stories de Web Components |

---

## Quando Usar

Use ao criar ou atualizar stories de componentes.

## Estrutura

| Elemento | Propósito |
|----------|-----------|
| Import | Importar componente no topo |
| Export default | Configuração do Storybook |
| Export Default | Story default com args básicos |

## Configuração

| Propriedade | Descrição |
|-------------|-----------|
| title | Caminho no menu de navegação |
| tags | Tags para geração de documentação |
| parameters | Configurações de apresentação |
| argTypes | Definições de controles e documentação |
| render | Função de renderização do componente |

## ArgTypes

| Campo | Propósito |
|-------|-----------|
| control | Tipo de controle de UI |
| options | Opções disponíveis para seleção |
| description | Documentação do atributo |
| table | Metadados e valores default |

## Tipos de Controle

| Tipo | Uso |
|------|-----|
| select | Seleção entre opções predefinidas |
| text | Entrada de texto livre |
| boolean | Toggle true/false |
| number | Entrada numérica |
| color | Seletor de cor |

## Regras

| Regra | Descrição |
|-------|-----------|
| Formato de arquivo | Usar JavaScript, não TypeScript |
| Exports | Uma única story Default por arquivo |
| Testes | Sem play functions ou testes de interação |
| Controles | Desabilitar controles globais |
| Imports | Sempre importar componente no início |
| Renderização | Criar elemento via API DOM |

## Princípios

| Princípio | Aplicação |
|-----------|-----------|
| Simplicidade | Story deve mostrar uso básico do componente |
| Isolamento | Cada story é independente |
| Documentação | ArgTypes documentam comportamento |

## Exemplos

```typescript
// ❌ Ruim — story sem metadados ou variantes
export default { component: Button }
export const Default = {}

// ✅ Bom — story estruturado com metadados e variantes
import type { Meta, StoryObj } from '@storybook/web-components'

const meta: Meta = {
  title: 'Components/Button',
  component: 'app-button',
  tags: ['autodocs'],
}
export default meta

export const Primary: StoryObj = {
  args: { label: 'Click me', variant: 'primary' }
}
export const Disabled: StoryObj = {
  args: { label: 'Disabled', disabled: true }
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Múltiplas stories no mesmo arquivo | Uma única story Default por arquivo (rule 010) |
| Play functions ou testes | Stories são para visualização, não para testes |
| Lógica complexa no render | Manter render simples e direto (rule 022) |
| Controles sem documentação | Todos os argTypes devem ter description |
| Stories sem exemplo real | Mostrar casos de uso reais do componente |

## Justificativa

- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): stories simples focam no essencial, reduzindo complexidade cognitiva
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada story tem responsabilidade única de demonstrar um caso de uso do componente
- [026 - Qualidade de Comentários](../../rules/026_qualidade-comentarios-porque.md): documentação via argTypes é permitida pois explica "o que" o argumento faz, não código
