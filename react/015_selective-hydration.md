# Selective Hydration

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

Selective Hydration é um recurso do React 18 que habilita hydration independente de componentes conforme são streamed para o cliente, ao invés de esperar pelo bundle JavaScript inteiro carregar antes de hydrate qualquer coisa.

## Também Conhecido Como

- Independent Component Hydration
- Concurrent Hydration
- Suspense-based Hydration

## Motivação

Hydration tradicional bloqueia: todo JavaScript deve carregar, então toda a aplicação hydrates de uma vez. Componentes lentos bloqueiam componentes rápidos, e usuários não podem interagir até hydration completa terminar. Selective Hydration resolve isso permitindo que componentes individuais se tornem interativos assim que estiverem prontos.

## Como Funciona

A técnica combina três tecnologias-chave:

### 1. Streaming Server-Side Rendering

Usa `pipeToNodeStream` (ou mais recente `renderToPipeableStream`) ao invés de `renderToString` para fazer stream de HTML conforme componentes ficam prontos.

### 2. Suspense Boundaries

Componentes que podem atrasar rendering são wrapped em Suspense, que renderiza conteúdo fallback imediatamente enquanto data fetches continuam server-side.

```javascript
<Suspense fallback={<Spinner />}>
  <Comments />
</Suspense>
```

### 3. Progressive Hydration

Conforme chunks HTML chegam ao cliente, React anexa event listeners e hydrates componentes independentemente, "sem ter que esperar por todo JavaScript carregar para começar a hydrating."

## Aplicabilidade

### Quando Usar

- Aplicações com seções UI independentes que carregam em velocidades diferentes
- Páginas com componentes de data-fetching pesados
- Qualquer aplicação SSR buscando métricas de performance melhoradas (FCP, TTI)
- Quando elementos interativos críticos devem estar imediatamente disponíveis aos usuários
- Sites com experiência mista de conteúdo estático e componentes dinâmicos

### Quando NÃO Usar

- Aplicações puramente client-side (CSR)
- Páginas completamente estáticas sem interatividade
- Contextos onde toda página deve hydrate atomicamente

## Estrutura

```
Server
├── renderToPipeableStream(<App />)
├── Stream Shell HTML
└── Stream Components progressivamente
    └── Wrap componentes lentos em <Suspense>

Cliente
├── Recebe HTML Shell
├── Exibe Fallbacks para Suspense boundaries
├── Recebe HTML de componentes conforme ficam prontos
├── Hydrate componentes independentemente
└── Prioriza componentes com interações do usuário
```

## Participantes

- **Streaming Server**: Envia HTML em chunks progressivos
- **Suspense Boundary**: Demarca onde hydration pode ser independente
- **Fallback Content**: Placeholder UI mostrado enquanto componente carrega
- **Hydration Scheduler**: Prioriza quais componentes hydrate primeiro
- **Event Replay**: Buffer eventos até componente estar hydrated

## Colaborações

1. Servidor faz stream de shell HTML com Suspense fallbacks
2. Cliente renderiza conteúdo inicial imediatamente
3. Server continua renderizando e streaming de componentes suspensos
4. Cliente recebe chunks HTML e injeta na página
5. JavaScript carrega progressivamente para cada componente
6. React hydrates componentes assim que JavaScript está disponível
7. Se usuário interage com componente antes de hydration, React prioriza aquele componente
8. Eventos são buffered e replayed após hydration

## Consequências

### Vantagens

- **First Paint Mais Rápido**: "Começar streaming de componentes assim que estiverem prontos, sem arriscar FCP e TTI mais lentos"
- **Interatividade Melhorada**: Usuários podem interagir com componentes hydrated antes da aplicação inteira estar pronta
- **Bloqueio Reduzido**: Componentes menores não esperam mais JavaScript de componentes maiores carregar
- **Suporte a Lazy-Loading**: Torna lazy-loading de componentes viável com SSR

## Implementação

### Considerações

1. **Suspense Boundaries**: Identificar onde colocar boundaries para otimizar streaming
2. **Fallback Design**: Criar fallbacks apropriados que não causem layout shift
3. **Priority**: Entender que interações do usuário automaticamente priorizam hydration
4. **Error Boundaries**: Implementar error handling robusto

### Implementação com React 18

```javascript
// Servidor
import { renderToPipeableStream } from 'react-dom/server';

const { pipe } = renderToPipeableStream(
  <App />,
  {
    bootstrapScripts: ['/main.js'],
    onShellReady() {
      response.setHeader('content-type', 'text/html');
      pipe(response);
    }
  }
);

// Componente
import { Suspense } from 'react';

function Page() {
  return (
    <Layout>
      <NavBar />
      <Suspense fallback={<Spinner />}>
        <Comments />
      </Suspense>
      <Suspense fallback={<Spinner />}>
        <Sidebar />
      </Suspense>
    </Layout>
  );
}
```

### Cliente com hydrateRoot

```javascript
// Cliente
import { hydrateRoot } from 'react-dom/client';

hydrateRoot(document, <App />);
```

### Técnicas

- Wrap seções independentes em Suspense boundaries
- Use code splitting com React.lazy() para componentes
- Implemente loading states apropriados
- Design fallbacks que minimizem Cumulative Layout Shift
- Test com network throttling para validar benefícios
- Monitor métricas de hydration timing

## Uso Conhecido

- **Next.js 13+**: Suporte built-in com App Router
- **React 18**: Recurso core do framework
- **Remix**: Streaming e Suspense support
- **Hydrogen**: Shopify's framework com streaming
- **Large Content Sites**: Implementações em produção

## Priorização de Hydration

React automaticamente prioriza componentes baseado em interação do usuário:

```javascript
// Se usuário clica em Comments antes de hydration completa,
// React prioriza hydration de Comments primeiro
<Suspense fallback={<Spinner />}>
  <Comments /> {/* Priorizará se usuário interagir */}
</Suspense>
```

## Métricas de Performance

- **TTFB**: Rápido com streaming
- **FCP**: Muito rápido, shell aparece imediatamente
- **TTI**: Melhorado significativamente
- **FID (First Input Delay)**: Reduzido com prioritization
- **TBT (Total Blocking Time)**: Minimizado

## Padrões Relacionados

- [**Streaming SSR**](013_streaming-ssr.md): Tecnologia fundamental para Selective Hydration
- [**Progressive Hydration**](012_progressive-hydration.md): Conceito relacionado
- [**React Server Components**](014_react-server-components.md): Complementar para reduzir JavaScript
- [**Server-side Rendering**](009_server-side-rendering.md): Base para SSR patterns

### Relação com Rules

- [022 - Priorização da Simplicidade e Clareza](../../clean-code/002_prioritization-simplicity-clarity.md): manter boundaries claras
- [028 - Tratamento de Exceção Assíncrona](../../clean-code/008_tratamento-excecao-assincrona.md): error boundaries importantes
- [032 - Cobertura Mínima de Teste](../../clean-code/012_cobertura-teste-minima-qualidade.md): testar diferentes estados

## Comparação com Hydration Tradicional

### Hydration Tradicional
1. Servidor renderiza HTML completo
2. Cliente recebe HTML
3. Todo JavaScript carrega
4. Toda aplicação hydrates de uma vez
5. Usuário pode interagir

### Selective Hydration
1. Servidor faz stream de HTML progressivamente
2. Cliente renderiza shell imediatamente
3. JavaScript carrega progressivamente por componente
4. Componentes hydrate independentemente
5. Usuário pode interagir com componentes prontos
6. Interações priorizam hydration de componentes específicos

## Melhores Práticas

- Identificar seções independentes da página para Suspense boundaries
- Criar fallbacks que correspondam ao tamanho do conteúdo real
- Usar skeleton screens ao invés de spinners quando apropriado
- Implementar error boundaries ao redor de Suspense boundaries
- Test comportamento de streaming com network throttling
- Monitor métricas de performance (FCP, TTI, FID)
- Combinar com React Server Components quando possível
- Considerar user interaction patterns ao definir boundaries
- Use prefetching strategies para componentes críticos

## Limitações

- Requer React 18+
- Funciona melhor com frameworks que suportam streaming (Next.js, Remix)
- Error handling pode ser mais complexo
- Debugging pode ser desafiador durante transições

---

**Criada em**: 2026-03-17
**Versão**: 1.0
