# Container/Presentational Pattern

**Classificação**: Padrão de Design React

---

## Intenção e Objetivo

Separar componentes React em dois papéis distintos: **componentes de apresentação** (preocupados com como os dados aparecem) e **componentes container** (preocupados com quais dados são mostrados). Isso impõe "separação de responsabilidades ao separar a view da lógica de aplicação."

## Também Conhecido Como

- Smart/Dumb Components
- Stateful/Stateless Components
- Fat/Skinny Components

## Motivação

O padrão aborda a necessidade de dividir claramente lógica de negócio da renderização de UI. No exemplo fornecido, buscar imagens de cachorros de uma API (lógica de aplicação) é tratado separadamente de exibir essas imagens (lógica de view).

## Aplicabilidade

Use o padrão Container/Presentational quando:

- Separar lógica de negócio de renderização de UI
- Reutilizar componentes de apresentação em diferentes contextos
- Facilitar testes de componentes visuais
- Permitir que designers modifiquem UI sem entender lógica de aplicação

**Nota**: React Hooks modernos em grande parte eliminam a necessidade deste padrão.

## Estrutura

```
Container Component
├── Gerencia estado e data fetching
├── Contém lógica de negócio
├── Mínimo ou nenhum styling
└── Passa dados para Presentational Components

Presentational Component
├── Recebe dados via props
├── Foca em display
├── Stateless (exceto UI state)
└── São tipicamente funções puras
```

## Participantes

- **Container Component**: Gerencia data fetching e estado, passa dados para componentes de apresentação
- **Presentational Component**: Recebe dados exclusivamente através de props, foca em renderização
- **Data Source**: API ou fonte de dados acessada pelo container
- **Props**: Mecanismo de comunicação entre container e presentational

## Colaborações

- Container components fazem fetching de dados e gerenciam estado
- Presentational components recebem dados e renderizam UI
- Container passa dados via props para presentational
- Presentational notifica container de eventos do usuário via callbacks

## Consequências

### Vantagens

- **Reutilização**: Encoraja reutilização de componentes de apresentação
- **Separação de Responsabilidades**: Designers podem modificar UI sem entender lógica de aplicação
- **Testabilidade**: Simplifica testes através de funções puras previsíveis
- **Clareza**: Separação clara permite responsabilidade focada por componente

### Desvantagens & Considerações Modernas

"Hooks tornam possível alcançar o mesmo resultado sem ter que usar o padrão Container/Presentational." Hooks customizados podem lidar com data fetching enquanto permanecem integrados com componentes de apresentação, reduzindo boilerplate e evitando camadas de wrapper desnecessárias.

**Recomendação React 18+**: React moderno "favorece fortemente Hooks sobre componentes container" para separação de lógica mais limpa.

## Implementação

### Considerações

1. **Identificar Responsabilidades**: Separar claramente data fetching de renderização
2. **Props Interface**: Definir interface de props clara para componentes de apresentação
3. **Estado Mínimo**: Containers devem ter estado mínimo necessário
4. **Composição**: Containers podem compor múltiplos presentational components

### Técnicas

- Use custom hooks para lógica de data fetching (abordagem moderna)
- Implemente componentes de apresentação como funções puras quando possível
- Mantenha containers focados em orquestração de dados
- Extraia lógica de negócio para hooks reutilizáveis

## Uso Conhecido

- **Redux**: Padrão Container/Presentational era comum com `connect()` HOC
- **Apollo Client**: Componentes container usavam `graphql()` HOC
- **React Router**: Container components gerenciavam routing logic
- **Form Libraries**: Containers gerenciavam form state, presentational renderizava fields

## Padrões Relacionados

- [**Hooks Pattern**](002_hooks-pattern.md): Substitui este padrão na maioria dos casos
- [**HOC Pattern**](001_hoc-pattern.md): Era usado para implementar containers
- [**Render Props Pattern**](005_render-props-pattern.md): Alternativa para separação de lógica

### Relação com Rules

- [010 - Princípio da Responsabilidade Única](../../solid/001_single-responsibility-principle.md): implementa
- [020 - Separação de Command-Query](../../package-principles/006_separacao-command-query-cqrs.md): relaciona-se
- [022 - Priorização da Simplicidade e Clareza](../../clean-code/priorizacao-simplicidade-clareza.md): reforça

## Exemplo de Implementação

### Container Component (Abordagem Clássica)
```javascript
function DogImagesContainer() {
  const [dogs, setDogs] = useState([]);

  useEffect(() => {
    fetch('https://dog.ceo/api/breed/labrador/images/random/6')
      .then(res => res.json())
      .then(({ message }) => setDogs(message));
  }, []);

  return <DogImages dogs={dogs} />;
}
```

### Presentational Component
```javascript
function DogImages({ dogs }) {
  return (
    <div>
      {dogs.map(dog => <img src={dog} key={dog} alt="dog" />)}
    </div>
  );
}
```

### Abordagem Moderna com Hooks
```javascript
function useDogImages() {
  const [dogs, setDogs] = useState([]);

  useEffect(() => {
    fetch('https://dog.ceo/api/breed/labrador/images/random/6')
      .then(res => res.json())
      .then(({ message }) => setDogs(message));
  }, []);

  return dogs;
}

function DogImages() {
  const dogs = useDogImages();
  return (
    <div>
      {dogs.map(dog => <img src={dog} key={dog} alt="dog" />)}
    </div>
  );
}
```

---

**Criada em**: 2026-03-17
**Versão**: 1.0
