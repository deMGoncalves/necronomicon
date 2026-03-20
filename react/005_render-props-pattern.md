# Render Props Pattern

**Classificação**: Padrão de Design React

---

## Intenção e Objetivo

Uma render prop é uma função passada como prop de um componente que retorna elementos JSX. O componente que recebe esta prop delega sua lógica de renderização à função ao invés de implementar renderização por si próprio.

## Também Conhecido Como

- Function as Child Components (FaCC)
- Children as a Function
- Render Callback Pattern

## Motivação

**Problema que resolve**: Componentes precisam compartilhar lógica e dados sem acoplamento forte.

**Cenários comuns**:
- Múltiplos componentes requerendo acesso a dados idênticos
- Compartilhar lógica stateful entre componentes irmãos
- Evitar "prop drilling" através de componentes intermediários

## Aplicabilidade

Use o padrão Render Props quando:

- Compartilhar lógica entre componentes sem tight coupling
- Fornecer dados de um componente pai para componentes filhos flexíveis
- Separar lógica stateful de renderização presentacional
- Criar componentes altamente reutilizáveis e configuráveis

**Nota**: React Hooks modernos em grande parte suplantaram este padrão.

## Estrutura

### Padrão Básico
```javascript
// Pai passa função como prop
<Title render={() => <h1>Content</h1>} />

// Filho invoca a função
const Title = (props) => props.render();
```

### Passagem de Dados
```javascript
function Input(props) {
  const [value, setValue] = useState("");
  return props.render(value);
}

// Pai recebe dados
<Input render={(value) => <Child data={value} />} />
```

### Children como Função
```javascript
<Input>
  {(value) => <Kelvin value={value} />}
</Input>

function Input({ children }) {
  const [value, setValue] = useState("");
  return children(value);
}
```

## Participantes

- **Component with Render Prop**: Componente que aceita função de renderização como prop
- **Render Function**: Função passada que retorna JSX
- **Consuming Component**: Componente que usa dados passados pela render function
- **Shared State**: Estado gerenciado pelo componente com render prop

## Colaborações

- Componente com render prop gerencia estado e lógica
- Render function é invocada com dados relevantes
- Função retorna JSX que será renderizado
- Estado é passado explicitamente através de argumentos da função

## Consequências

### Vantagens

- **Reutilização**: Componentes tornam-se altamente flexíveis e reutilizáveis
- **Evita Colisões de Nomenclatura**: Diferente de HOCs, passagem explícita de props previne conflitos
- **Props Explícitas**: Fontes de dados são visíveis e rastreáveis através de argumentos de função
- **Separação Lógica-Renderização**: Lógica stateful separa-se limpa de componentes de apresentação

### Desvantagens

- **JSX Profundamente Aninhado**: Múltiplas render props criam aninhamento de callbacks (wrapper hell)
- **Sem Suporte a Lifecycle**: Não pode aplicar métodos de ciclo de vida dentro de render props
- **Uso Moderno Limitado**: React Hooks em grande parte suplantaram este padrão

## Implementação

### Considerações

1. **Nomenclatura de Props**: Use nomes descritivos como `render`, `children`, ou específicos do domínio
2. **Performance**: Considere memoização se render function for custosa
3. **Tipo de Dados**: Defina claramente quais dados serão passados para a função
4. **Composição**: Render props podem ser compostas, mas cuidado com aninhamento

### Técnicas

- Use `children` prop para API mais limpa
- Implemente multiple render props para diferentes seções
- Combine com Context API para evitar prop drilling
- Considere usar TypeScript para type safety dos argumentos

## Uso Conhecido

- **React Router v4/v5**: `<Route render={(props) => <Component {...props} />} />`
- **Apollo Client (Legacy)**: `<Query>{({ data, loading }) => ...}</Query>`
- **React Motion**: Animações usando render props
- **Downshift**: Biblioteca de autocomplete/dropdown
- **React Powerplug**: Coleção de componentes render prop

## Padrões Relacionados

- [**Hooks Pattern**](002_hooks-pattern.md): Substituto moderno para render props
- [**HOC Pattern**](001_hoc-pattern.md): Abordagem alternativa para compartilhar lógica
- [**Compound Pattern**](003_compound-pattern.md): Padrão complementar para componentes relacionados

### Relação com Rules

- [010 - Princípio da Responsabilidade Única](../../solid/001_single-responsibility-principle.md): reforça
- [021 - Proibição da Duplicação de Lógica](../../clean-code/proibicao-duplicacao-logica.md): implementa
- [022 - Priorização da Simplicidade e Clareza](../../clean-code/priorizacao-simplicidade-clareza.md): pode violar se usado excessivamente

## Alternativa Moderna: Hooks

Post-React Hooks, bibliotecas como Apollo Client mudaram de render props para abordagens baseadas em Hook. Os hooks `useMutation` e `useQuery` eliminam componentes wrapper, reduzindo complexidade de aninhamento enquanto melhoram clareza do código.

## Status Atual (React 18+)

"O padrão render props agora é em grande parte suplantado por Hooks nas melhores práticas do React." Hooks customizados oferecem acesso direto a dados dentro de componentes, substituindo padrões baseados em wrapper enquanto habilitam melhor análise estática para o React Compiler.

---

**Criada em**: 2026-03-17
**Versão**: 1.0
