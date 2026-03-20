# HOC Pattern (Higher-Order Components)

**Classificação**: Padrão de Design React

---

## Intenção e Objetivo

Fornecer uma função que recebe um componente e retorna uma versão aprimorada desse componente com lógica ou comportamento adicional aplicado. Um HOC é uma função que aceita um componente como parâmetro e aplica lógica específica que queremos reutilizar.

## Também Conhecido Como

- Componente de Ordem Superior
- Wrapper Component Pattern
- Component Enhancer

## Motivação

O padrão HOC resolve o problema de reutilização de código entre múltiplos componentes. Ao invés de duplicar lógica em diferentes implementações de componentes, desenvolvedores podem encapsular funcionalidade compartilhada em um único HOC e aplicá-la a qualquer componente compatível.

## Aplicabilidade

Use o padrão HOC quando:

- O mesmo comportamento não-customizado é necessário em toda a aplicação
- O componente funciona independentemente da lógica adicional
- Múltiplos componentes requerem padrões de comportamento idênticos

**Quando NÃO usar (preferir Hooks):**

- O comportamento requer customização por componente
- A lógica aparece em apenas um ou dois componentes
- O aprimoramento adiciona numerosas propriedades ao componente

## Estrutura

```javascript
function withEnhancement(Component) {
  return (props) => {
    // lógica aqui
    return <Component {...props} />;
  };
}
```

O padrão tipicamente:
1. Aceita um componente como argumento
2. Implementa lógica customizada (gerenciamento de estado, busca de dados, manipulação de eventos)
3. Passa dados/props relevantes para o componente encapsulado
4. Retorna o componente aprimorado

## Participantes

- **HOC Function**: Função que aceita um componente e retorna versão aprimorada
- **WrappedComponent**: Componente original que será aprimorado
- **EnhancedComponent**: Componente resultante com funcionalidade adicional
- **Props**: Propriedades passadas através da cadeia de componentes

## Colaborações

- Normalmente um HOC encapsula um único componente e adiciona comportamento específico
- O HOC delega renderização ao componente original, passando props necessárias
- Componentes cliente permanecem independentes da implementação do HOC

## Consequências

### Vantagens

- **Reutilização de Código**: A lógica permanece em um único lugar, reduzindo duplicação
- **Separação de Responsabilidades**: Diferentes comportamentos permanecem isolados e focados
- **Princípio DRY**: Elimina bugs de propagação causados por duplicação de código

### Desvantagens

- **Colisões de Nomes de Props**: O nome da prop que um HOC pode passar pode causar colisões de nomenclatura
- **Debugging Difícil**: Múltiplos HOCs compostos tornam difícil identificar qual HOC é responsável por qual prop
- **Aninhamento Profundo**: Composição excessiva cria "wrapper hell" com estruturas profundamente aninhadas
- **Poluição do DevTools**: Camadas de wrapper obscurecem a visibilidade da hierarquia de componentes

## Implementação

### Considerações

1. **Nomeação**: Prefixar HOCs com `with` (ex: `withLoader`, `withAuth`)
2. **Props Forwarding**: Sempre passar props do componente original usando spread operator
3. **Display Name**: Definir displayName para melhor debugging
4. **Composição**: HOCs podem ser compostos para combinar comportamentos

### Técnicas

- Use HOCs para compartilhar comportamento entre componentes sem state
- Implemente lógica de data fetching, autenticação, ou analytics em HOCs
- Compose múltiplos HOCs usando bibliotecas como `compose` do Redux

## Uso Conhecido

- **React Redux**: `connect()` HOC para conectar componentes ao store
- **React Router**: `withRouter()` para acesso a props de roteamento
- **Material-UI**: `withStyles()` para aplicar estilos temáticos
- **Apollo Client**: `graphql()` HOC (agora deprecado em favor de hooks)

## Padrões Relacionados

- [**Hooks Pattern**](002_hooks-pattern.md): Substituto moderno para muitos casos de uso de HOC
- [**Render Props Pattern**](005_render-props-pattern.md): Alternativa para compartilhar lógica entre componentes
- [**Compound Pattern**](003_compound-pattern.md): Padrão complementar para componentes relacionados

### Relação com Rules

- [010 - Princípio da Responsabilidade Única](../../solid/001_single-responsibility-principle.md): reforça
- [021 - Proibição da Duplicação de Lógica](../../clean-code/proibicao-duplicacao-logica.md): implementa
- [022 - Priorização da Simplicidade e Clareza](../../clean-code/priorizacao-simplicidade-clareza.md): pode violar se usado excessivamente

## Contexto Moderno

A documentação oficial do React agora indica: "Modern React strongly prefers Hooks or other composition patterns to reuse logic with less nesting." Embora HOCs permaneçam válidos, muitas bibliotecas (como Apollo Client) agora fornecem alternativas baseadas em Hooks que reduzem boilerplate e complexidade de aninhamento.

---

**Criada em**: 2026-03-17
**Versão**: 1.0
