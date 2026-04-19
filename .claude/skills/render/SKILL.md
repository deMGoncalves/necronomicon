---
name: render
description: Convenção para renderização e re-renderização de componentes — ao implementar renderização de componentes, otimizar re-renders ou revisar código que atualiza o DOM de forma ineficiente
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Render

Convenção para renderização e re-renderização de componentes focada em performance e otimização.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar componentes visuais que precisam renderizar HTML e CSS; ao otimizar re-renders; ao revisar código que atualiza o DOM de forma ineficiente |
| **Prerequisites** | Skill `anatomy` (estrutura de Web Component); skill `constructor`; conhecimento de Shadow DOM e Custom Elements API |
| **Constraints** | Não usar `repaint` quando `retouch` é suficiente (apenas CSS muda); não re-renderizar no constructor (componente ainda não conectado); funções `component` e `style` devem ser puras (rule 036) |
| **Scope** | Decorators `paint`, `repaint` e `retouch`; ciclo de vida de renderização (willPaint, htmlCallback, cssCallback, didPaint); otimização de performance e batching |

---

## Quando Usar

Use ao criar componentes visuais que precisam renderizar HTML e CSS, ou ao precisar re-renderizar componentes após mudanças de estado.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Performance | Minimizar operações no DOM escolhendo estratégia adequada |
| Reatividade | Re-renderizar apenas quando necessário e de forma otimizada |

## Decoradores de Renderização

| Decorator | Escopo | O que renderiza | Performance | Uso |
|-----------|--------|-----------------|-------------|-----|
| paint | Classe | HTML + CSS inicial | N/A | Renderização inicial no connected |
| repaint | Setter/Método | HTML + CSS completo | Caro | Mudanças que afetam template HTML |
| retouch | Setter/Método | CSS apenas | Otimizado | Mudanças que afetam apenas estilos |

## Paint (Renderização Inicial)

| Aspecto | Descrição |
|---------|-----------|
| Aplicação | Decorator de classe |
| Parâmetros | função component e função style |
| Execução | Quando componente é conectado ao DOM |
| Frequência | Uma vez no ciclo de vida |
| Lifecycle | Executa no callback connected |

## Repaint (Re-renderização Completa)

| Aspecto | Descrição |
|---------|-----------|
| Aplicação | Decorator de setter ou método |
| O que faz | Re-renderiza HTML e CSS |
| Callbacks | willPaint → html + css → didPaint |
| Async | Usa setImmediate para não bloquear |
| Guard | Verifica isPainted antes de executar |
| Custo | Alto - reprocessa template e estilos |

## Retouch (Re-renderização Parcial)

| Aspecto | Descrição |
|---------|-----------|
| Aplicação | Decorator de setter ou método |
| O que faz | Re-renderiza CSS apenas |
| Callbacks | Apenas cssCallback |
| Async | Usa setImmediate para não bloquear |
| Guard | Verifica isPainted antes de executar |
| Custo | Baixo - apenas recalcula estilos |

## Quando Usar Cada Decorator

| Situação | Decorator | Justificativa |
|----------|-----------|---------------|
| Mudança de src, use, fallback | repaint | Conteúdo HTML muda |
| Mudança de color, size, variant | retouch | Apenas estilos mudam |
| Mudança de texto interno | repaint | Template HTML muda |
| Mudança de classe CSS | retouch | Apenas estilos mudam |
| Mudança de visibilidade | retouch | Apenas display/opacity muda |
| Adicionar/remover elementos | repaint | Estrutura DOM muda |
| Método que limpa formulário | repaint | Inputs precisam ser re-renderizados |
| Método que muda tema | retouch | Apenas variáveis CSS mudam |

## Otimização de Performance

| Estratégia | Descrição |
|------------|-----------|
| Preferir retouch | Use retouch sempre que mudança for apenas de estilo |
| Evitar repaint desnecessário | Não use repaint quando retouch basta |
| Batching automático | setImmediate agrupa múltiplas atualizações |
| Guard de estado | isPainted previne renderização antes do connected |
| Async | Não bloqueia thread principal |

## Ciclo de Vida de Renderização

| Fase | Callback | Função |
|------|----------|--------|
| Antes | willPaintCallback | Preparação antes de renderizar |
| HTML | htmlCallback | Re-renderiza template HTML |
| CSS | cssCallback | Re-renderiza estilos CSS |
| Depois | didPaintCallback | Finalização após renderizar |

## Uso em Setters

| Padrão | Descrição |
|--------|-----------|
| Ordem de decorators | attributeChanged primeiro, depois repaint ou retouch |
| Setter com repaint | Quando valor afeta template HTML |
| Setter com retouch | Quando valor afeta apenas estilos |
| Múltiplos decorators | Permitido empilhar decorators |

## Uso em Métodos

| Padrão | Descrição |
|--------|-----------|
| Métodos públicos | Podem ter repaint ou retouch |
| Métodos com Symbol | Métodos privados podem ter decorators de render |
| Event handlers | Podem acionar re-renderização |
| Métodos async | Compatíveis com repaint e retouch |

## Component e Style

| Função | Retorno | Parâmetro | Descrição |
|--------|---------|-----------|-----------|
| component | html Template | Instância do componente | Retorna estrutura HTML do componente |
| style | css Template | Instância do componente | Retorna estilos CSS do componente |

## Reatividade

| Aspecto | Descrição |
|---------|-----------|
| Valores dinâmicos | Component e style acessam propriedades da instância |
| Condicional | Renderização pode usar lógica condicional simples |
| Interpolação | Valores interpolados são recalculados a cada render |
| Closure | Funções capturam contexto da instância |

## Exemplos

```typescript
// ❌ Ruim — re-render completo desnecessário
render() {
  this.shadowRoot.innerHTML = `<div>${this.data}</div>`
  // limpa e reconstrói tudo
}

// ✅ Bom — atualização cirúrgica do DOM
render() {
  const el = this.shadowRoot.querySelector('.data')
  if (el) el.textContent = this.data
  // atualiza apenas o que mudou
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Usar repaint quando retouch basta | Desperdício de performance |
| Re-renderizar no constructor | Componente ainda não conectado |
| Lógica complexa em component/style | Manter funções simples (rule 010) |
| Efeitos colaterais em component/style | Funções devem ser puras |
| Renderização síncrona bloqueante | Usar decorators async |
| Múltiplos repaints em sequência | Deixar batching automático agrupar |

## Boas Práticas

| Prática | Descrição |
|---------|-----------|
| Análise de impacto | Avaliar se mudança afeta HTML ou apenas CSS |
| Preferir retouch | Default para retouch, usar repaint só se necessário |
| Funções puras | component e style devem ser funções puras |
| Lógica mínima | Manter lógica de renderização simples |
| Responsabilidade única | Cada render tem propósito único |
| Renderização lazy | Componente renderiza apenas quando conectado |

## Casos Especiais

| Caso | Tratamento |
|------|------------|
| Componente headless | Não usar paint (sem renderização visual) |
| Apenas lógica | Componentes comportamentais não precisam de render |
| Renderização lazy | Componente renderiza apenas quando conectado |
| Renderização condicional | Usar lógica condicional em component |

## Justificativa

- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada render tem responsabilidade específica e clara, paint para inicial, repaint para HTML+CSS, retouch apenas para CSS
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): escolher decorator adequado (paint/repaint/retouch) torna intenção clara e mantém performance
- [069 - Proibição de Otimização Prematura](../../rules/069_proibicao-otimizacao-prematura.md): otimizar escolhendo retouch vs repaint baseado em necessidade real, não prematuramente
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): funções component e style devem ter máximo 15 linhas
