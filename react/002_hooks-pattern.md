# Hooks Pattern

**Classificação**: Padrão de Design React

---

## Intenção e Objetivo

Permitir que desenvolvedores gerenciem estado de componente e métodos de ciclo de vida em componentes funcionais sem convertê-los para componentes de classe. Hooks representam uma mudança de paradigma em como componentes React são estruturados e compostos.

## Também Conhecido Como

- React Hooks
- Function Component Hooks
- State Hooks

## Motivação

Antes dos Hooks, desenvolvedores enfrentavam vários desafios com componentes de classe:

1. **Complexidade de Classes ES2015**: Entender binding, constructors e a palavra-chave `this` criava barreiras de entrada
2. **Refatoração de Código**: Adicionar estado exigia converter componentes funcionais inteiros para componentes de classe
3. **Wrapper Hell**: Compartilhar lógica via HOCs ou Render Props criava hierarquias de componentes profundamente aninhadas
4. **Lógica Emaranhada**: Funcionalidade relacionada espalhada por múltiplos métodos de ciclo de vida tornava-se difícil de manter

## Aplicabilidade

Use o padrão Hooks quando:

- Adicionar gerenciamento de estado a componentes funcionais
- Gerenciar ciclo de vida de componentes sem métodos de classe
- Extrair e reutilizar lógica stateful entre componentes
- Substituir padrões HOC ou Render Props
- Compartilhar lógica não-visual entre componentes

## Estrutura

### Core Hooks

**useState**: "O Hook useState permite que desenvolvedores atualizem e manipulem estado dentro de componentes funcionais sem precisar convertê-lo para componente de classe."

```javascript
const [value, setValue] = useState(initialValue)
```

**useEffect**: Combina `componentDidMount`, `componentDidUpdate` e `componentWillUnmount`. Gerencia efeitos colaterais e operações de cleanup.

```javascript
useEffect(() => {
  // efeito
  return () => {
    // cleanup
  };
}, [dependencies]);
```

**useContext**: Compartilha dados por toda a aplicação sem prop drilling usando Context API do React.

**useReducer**: "Uma alternativa ao setState, especialmente preferível quando você tem lógica de estado complexa que envolve múltiplos sub-valores."

### Custom Hooks

Desenvolvedores podem criar hooks customizados combinando hooks built-in. Hooks customizados devem seguir convenções de nomenclatura começando com `use`.

## Participantes

- **Hook Function**: Função que usa hooks do React internamente
- **Component**: Componente funcional que chama hooks
- **State**: Estado gerenciado pelos hooks
- **Dependencies**: Array de dependências que controla quando effects executam

## Colaborações

- Hooks são chamados no topo de componentes funcionais
- Múltiplos hooks podem ser compostos para criar lógica complexa
- Hooks customizados encapsulam e compartilham lógica stateful

## Consequências

### Vantagens

- **Volume de Código Reduzido**: "Hooks permitem agrupar código por preocupação e funcionalidade, não por ciclo de vida. Isso torna o código não apenas mais limpo e conciso, mas também mais curto."
- **Componentes Simplificados**: Elimina complexidade de classes e melhora compatibilidade de hot reloading
- **Reutilização de Lógica**: Lógica stateful pode ser extraída como funções JavaScript puras
- **Testes Mais Fáceis**: Funções puras são mais simples de testar do que métodos de classe
- **Fluxo de Dados Mais Claro**: Separa responsabilidades mais efetivamente do que métodos de ciclo de vida

### Desvantagens

- Requer entendimento das regras de Hooks e sua aplicação adequada
- Curva de aprendizado íngreme, particularmente com `useEffect` e `useCallback`
- Risco de uso incorreto causando problemas de performance
- Erros no array de dependências levam a bugs sutis
- Violações de regras difíceis de capturar sem ferramentas de linting

## Implementação

### Considerações

1. **Regras dos Hooks**: Sempre chamar hooks no nível superior, nunca em loops, condições ou funções aninhadas
2. **Apenas em Funções React**: Chamar hooks apenas em componentes funcionais ou hooks customizados
3. **Dependencies**: Sempre declarar todas as dependências no array de dependências do useEffect
4. **Nomenclatura**: Prefixar hooks customizados com `use`

### Técnicas

- Extrair lógica relacionada em hooks customizados
- Use `useMemo` e `useCallback` para otimizações de performance
- Implemente cleanup functions em `useEffect` para prevenir memory leaks
- Combine múltiplos hooks para criar comportamento complexo

## Uso Conhecido

- **React Query**: `useQuery` e `useMutation` para data fetching
- **React Router**: `useNavigate`, `useParams`, `useLocation`
- **Redux Toolkit**: `useSelector`, `useDispatch`
- **Apollo Client**: `useQuery`, `useMutation`, `useSubscription`
- **Form Libraries**: `useForm` (React Hook Form)

## Padrões Relacionados

- [**HOC Pattern**](001_hoc-pattern.md): Substituído por Hooks em muitos casos
- [**Render Props Pattern**](005_render-props-pattern.md): Alternativa que Hooks modernizam
- [**Container/Presentational Pattern**](004_container-presentational-pattern.md): Hooks eliminam necessidade deste padrão

### Relação com Rules

- [010 - Princípio da Responsabilidade Única](../../solid/001_single-responsibility-principle.md): reforça
- [021 - Proibição da Duplicação de Lógica](../../clean-code/proibicao-duplicacao-logica.md): implementa
- [022 - Priorização da Simplicidade e Clareza](../../clean-code/priorizacao-simplicidade-clareza.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](../../clean-code/restricao-funcoes-efeitos-colaterais.md): relaciona-se

## Melhores Práticas Modernas (React 18+)

A orientação moderna aconselha contra o uso excessivo de `useEffect`. Estado derivado deve ser computado diretamente no corpo do componente ao invés de em effects. Eventos do usuário devem ser tratados através de event handlers, reduzindo double renders e bugs relacionados a closures.

React 19 introduz o React Optimizing Compiler, que "lida com memoização para você, eliminando a necessidade de useMemo, useCallback e React.memo manuais" em muitos casos.

---

**Criada em**: 2026-03-17
**Versão**: 1.0
