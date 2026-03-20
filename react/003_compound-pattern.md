# Compound Pattern

**Classificação**: Padrão de Design React

---

## Intenção e Objetivo

Criar componentes que trabalham juntos de forma interdependente, compartilhando estado e lógica para realizar uma tarefa unificada. Estes componentes são fortemente acoplados e projetados para funcionar como uma unidade coesa.

## Também Conhecido Como

- Compound Components
- Composable Components
- Parent-Child State Sharing Pattern

## Motivação

Este padrão brilha ao construir bibliotecas de componentes com elementos UI relacionados como dropdowns, menus de seleção ou sistemas de menu. É particularmente valioso em frameworks como Semantic UI onde múltiplos sub-componentes precisam de comportamento sincronizado.

## Aplicabilidade

Use o padrão Compound quando:

- Construir bibliotecas de componentes reutilizáveis
- Criar componentes com elementos filhos interdependentes
- Encapsular gerenciamento de estado interno
- Evitar prop drilling através de múltiplas camadas de componentes

## Estrutura

### Abordagem 1: Context API

```javascript
const Context = createContext();

function Parent({ children }) {
  const [state, setState] = useState();
  return (
    <Context.Provider value={{ state, setState }}>
      {children}
    </Context.Provider>
  );
}

Parent.Child = function Child() {
  const { state } = useContext(Context);
  return <div>{state}</div>;
};
```

### Abordagem 2: React.Children.map

```javascript
function Parent({ children }) {
  const [state, setState] = useState();
  return (
    <>
      {React.Children.map(children, child =>
        React.cloneElement(child, { state })
      )}
    </>
  );
}
```

## Participantes

- **Parent Component**: Componente principal que gerencia estado compartilhado
- **Context Provider**: Fornecedor de contexto que distribui estado
- **Child Components**: Componentes que consomem estado compartilhado
- **Shared State**: Estado gerenciado pelo componente pai

## Colaborações

- O componente pai cria e gerencia estado interno
- Componentes filhos são anexados como propriedades do componente pai
- Filhos acessam estado através de Context API ou props clonadas
- Estado é compartilhado automaticamente sem prop drilling

## Consequências

### Vantagens

- **Gerenciamento de Estado Interno**: "Componentes compostos gerenciam seu próprio estado interno, que compartilham entre os vários componentes filhos"
- **Imports Simplificados**: Não há necessidade de importar componentes filhos separadamente
- **API Limpa e Declarativa**: Código altamente legível e expressivo
- **Implementação com Hooks Modernos**: Alinha-se com práticas atuais do React
- **Compatibilidade Total**: Funciona com React 18+ e Server Components

### Desvantagens

- **Aninhamento Limitado**: Com `React.Children.map`, apenas filhos diretos acessam as props. Envolver componentes em elementos adicionais quebra funcionalidade
- **Riscos de Shallow Merging**: `React.cloneElement` cria riscos de colisões de nomes de props, onde props existentes são sobrescritas por valores recém-passados

## Implementação

### Considerações

1. **Escolha de Método**: Context API para flexibilidade, Children.map para simplicidade
2. **Nomenclatura**: Anexar componentes filhos como propriedades do pai (ex: `Menu.Item`)
3. **Estado Compartilhado**: Definir claramente qual estado precisa ser compartilhado
4. **Composição**: Permitir composição flexível de componentes filhos

### Técnicas

- Use Context API para maior flexibilidade de aninhamento
- Implemente componentes filhos como propriedades estáticas do pai
- Forneça valores padrão sensatos no contexto
- Documente claramente quais componentes devem ser usados juntos

## Uso Conhecido

- **Semantic UI React**: Menu, Dropdown, Form components
- **Reach UI**: Accordion, Tabs, Menu Button
- **Radix UI**: Select, Dropdown Menu, Navigation Menu
- **React Bootstrap**: Accordion, Card, Nav components
- **Material-UI**: Stepper, List, Menu components

## Padrões Relacionados

- [**Hooks Pattern**](002_hooks-pattern.md): Usado para implementar estado interno
- [**Render Props Pattern**](005_render-props-pattern.md): Alternativa para compartilhar comportamento
- [**HOC Pattern**](001_hoc-pattern.md): Abordagem diferente para reutilização de lógica

### Relação com Rules

- [004 - Coleções de Primeira Classe](../../object-calisthenics/004_colecoes-primeira-classe.md): relaciona-se
- [010 - Princípio da Responsabilidade Única](../../solid/001_single-responsibility-principle.md): reforça
- [022 - Priorização da Simplicidade e Clareza](../../clean-code/priorizacao-simplicidade-clareza.md): reforça

## Exemplo de Uso

```javascript
<FlyOut>
  <FlyOut.Toggle />
  <FlyOut.List>
    <FlyOut.Item>Edit</FlyOut.Item>
    <FlyOut.Item>Delete</FlyOut.Item>
  </FlyOut.List>
</FlyOut>
```

Isso alcança um sistema de menu completo sem gerenciar estado no componente pai.

---

**Criada em**: 2026-03-17
**Versão**: 1.0
