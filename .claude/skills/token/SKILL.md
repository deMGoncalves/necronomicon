---
name: token
description: Convenção para uso de Design Tokens em estilos CSS — ao criar ou modificar estilos CSS, revisar código que usa valores hardcoded para cor, espaçamento ou tipografia ao invés de tokens do Design System
model: sonnet
allowed-tools: Read, Write, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Token

Convenção para uso de Design Tokens CSS ao estilizar componentes, substituindo valores hardcoded por tokens do Design System de `packages/pixel/tokens/`.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar ou modificar estilos CSS; ao revisar código com valores hardcoded de cor, espaçamento ou tipografia; ao garantir suporte automático a dark mode via `light-dark()` |
| **Prerequisites** | Tokens do Design System disponíveis em `packages/pixel/tokens/`; CSS Custom Properties (`var(--token)`); skill `render` (onde os estilos são aplicados via função `style`) |
| **Constraints** | `--spacing_inset-*` apenas em `padding` (interno); `--spacing-*` em `margin` e `gap` (externo); tokens de cor `*-dark` proibidos em `background`; tokens de cor `*-light` proibidos em `color` de texto |
| **Scope** | Mapeamento completo de propriedades CSS → categoria de tokens; escala de cores (5 tons por paleta); 9 paletas semânticas; escala de espaçamento interno vs externo |

---

## Quando Usar

| Situação | Ação |
|----------|------|
| Criando estilos para novo componente | Consultar mapeamento abaixo para cada propriedade |
| Modificando estilos existentes com valores hardcoded | Substituir por token correspondente |
| Escolhendo cor, tamanho ou espaçamento | Selecionar token por contexto semântico |

## Princípio

| Aspecto | Detalhes |
|---------|----------|
| Consistência | Tokens garantem que todos os componentes compartilhem a mesma escala visual |
| Manutenibilidade | Mudanças centralizadas nos tokens atualizam todo o sistema |
| Dark mode | Cores usam `light-dark()` internamente — usar token já garante suporte automático |

## Mapeamento: Propriedade → Categoria de Token

| Propriedade CSS | Categoria de Token | Exemplo Correto |
|-----------------|--------------------|-----------------|
| `color` | `--color-*` | `color: var(--color-master-dark)` |
| `background`, `background-color` | `--color-*` | `background: var(--color-master-lightest)` |
| `border-color` | `--color-*` | `border-color: var(--color-master-light)` |
| `border-width` | `--border-width-*` | `border-width: var(--border-width-thin)` |
| `border-radius` | `--border-radius-*` | `border-radius: var(--border-radius-sm)` |
| `padding`, `padding-*` | `--spacing_inset-*` | `padding: var(--spacing_inset-xs)` |
| `margin`, `margin-*` | `--spacing-*` | `margin-bottom: var(--spacing-nano)` |
| `gap`, `row-gap`, `column-gap` | `--spacing-*` | `gap: var(--spacing-nano)` |
| `font-size` | `--font-size-*` | `font-size: var(--font-size-xs)` |
| `font-family` | `--font-family-*` | `font-family: var(--font-family-base)` |
| `font-weight` | `--font-weight-*` | `font-weight: var(--font-weight-regular)` |
| `line-height` | `--line-height-*` | `line-height: var(--line-height-md)` |
| `opacity` | `--opacity-level-*` | `opacity: var(--opacity-level-medium)` |
| `box-shadow` | `--shadow-level-*` | `box-shadow: var(--shadow-level-1)` |
| `fill`, `stroke` (SVG) | `--color-*` | `fill: var(--color-primary)` |

## Regras de Escala

### Cores — Escala de Tom

Cada paleta de cores tem 5 níveis de intensidade. A intensidade define **onde** usar:

| Tom | Uso | Exemplo |
|-----|-----|---------|
| `*-darker` | Títulos e texto fortemente destacado | `color: var(--color-primary-darker)` |
| `*-dark` | Texto principal e interativo | `color: var(--color-primary-dark)` |
| `*` (base) | Botões e elementos interativos | `background: var(--color-primary)` |
| `*-light` | Ícones e destaques sutis | `color: var(--color-primary-light)` |
| `*-lighter` | Fundos de componentes | `background: var(--color-primary-lighter)` |

**Regra crítica:** nunca usar tom dark em `background` nem tom light em `color` de texto.

### Paletas Disponíveis

| Paleta | Uso Semântico |
|--------|---------------|
| `master` | Escala de cinza — texto neutro, bordas e fundos |
| `primary` | Identidade da marca — ações principais |
| `complete` | Progresso e conclusão |
| `success` | Feedback positivo |
| `warning` | Avisos |
| `danger` | Erros |
| `info` | Informativo neutro |
| `menu` | Navegação em contextos dark |
| `pure-white` / `pure-black` | Contraste absoluto apenas |

### Espaçamento — Externo vs Interno

| Contexto | Token | Proibição |
|----------|-------|-----------|
| `padding` | `--spacing_inset-*` | Nunca usar `--spacing-*` em padding |
| `margin` | `--spacing-*` | Nunca usar `--spacing_inset-*` em margin |
| `gap` | `--spacing-*` | Nunca usar `--spacing_inset-*` em gap |

## Contexto Semântico

O tipo de componente determina quais tokens são obrigatórios:

| Componente | Propriedade | Token Obrigatório |
|------------|-------------|-------------------|
| Botão interativo | `background` | `--color-primary` |
| Botão interativo | `border-radius` | `--border-radius-sm` |
| Input | `border-width` | `--border-width-thin` |
| Input | `border-radius` | `--border-radius-xs` |
| Texto de erro | `color` | `--color-danger-*` |
| Texto de sucesso | `color` | `--color-success-*` |
| Borda neutra | `border-color` | `--color-master-light` |
| Fundo principal | `background` | `--color-master-lightest` |
| Título / header | `font-family` | `--font-family-highlight` |
| Título / header | `font-weight` | `--font-weight-bold` |
| Texto regular | `font-family` | `--font-family-base` |
| Parágrafo | `line-height` | `--line-height-md` |

## Exceções

Propriedades abaixo **não têm token** e podem usar valores diretos:

| Propriedade | Valores Permitidos |
|-------------|-------------------|
| `display`, `position`, `visibility`, `overflow` | Qualquer valor válido |
| `flex`, `flex-grow`, `flex-shrink`, `order` | Valores numéricos |
| `z-index` | Valores numéricos |
| `width`, `height` | `100%`, `auto`, `min-content`, `max-content` |
| `min-width`, `max-width` | `0`, `none`, `100%` |
| `top`, `left`, `right`, `bottom` | `0` |
| `border-style` | `solid`, `dashed`, `dotted` |
| `transition`, `animation` | Duração e timing |
| `transform` | Qualquer função de transformação |
| `cursor` | `pointer`, `default`, `not-allowed` |
| `pointer-events`, `user-select` | Qualquer valor válido |

## Exemplos

```css
/* ❌ Ruim — valores hardcoded */
.button {
  background: #3B82F6;
  padding: 8px 16px;
  font-size: 14px;
}

/* ✅ Bom — Design Tokens */
.button {
  background: var(--color-action-default);
  padding: var(--spacing-sm) var(--spacing-md);
  font-size: var(--font-size-body);
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| `color: #000` ou `color: black` | Usar `--color-master-darkest` ou paleta semântica (rule 024) |
| `background: #fff` ou `background: white` | Usar `--color-master-lightest` ou `--color-pure-white` (rule 024) |
| `border: 1px solid #ccc` (shorthand com valores fixos) | Separar em `border-width`, `border-style` e `border-color` usando tokens |
| `padding: 16px` | Usar `--spacing_inset-xs` — padding é espaçamento interno (rule 024) |
| `margin: 8px` | Usar `--spacing-nano` — margin é espaçamento externo (rule 024) |
| `gap: 24px` | Usar `--spacing-xxs` — gap é espaçamento externo (rule 024) |
| `font-size: 16px` | Usar `--font-size-xs` — tipografia deve usar tokens (rule 024) |
| `font-weight: 700` | Usar `--font-weight-bold` — peso tipográfico deve usar tokens (rule 024) |
| `opacity: 0.5` | Usar `--opacity-level-*` mais próximo |
| `--spacing-*` em `padding` | Padding é interno, usar `--spacing_inset-*` |
| `--spacing_inset-*` em `margin` ou `gap` | Margin e gap são externos, usar `--spacing-*` |
| Token de cor dark em `background` | Usar variação `*-lighter` ou `*-lightest` |
| Token de cor light em `color` de texto | Usar variação `*-darker` ou `*-dark` |

## Justificativa

- [024 - Proibição de Constantes Mágicas](../../rules/024_proibicao-constantes-magicas.md): valores literais em CSS são constantes mágicas, devem ser substituídos por tokens nomeados para rastreabilidade e manutenção
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): tokens reduzem complexidade cognitiva ao dar semântica explícita aos valores de estilo
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): tokens centralizam responsabilidade de definição visual, evitando que componentes individuais tomem decisões de design
- [016 - Princípio do Fechamento Comum](../../rules/016_principio-fechamento-comum.md): mudanças de tema ou escala visual são localizadas nos tokens, sem alterar componentes
