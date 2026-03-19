# Streaming Server-Side Rendering (SSR)

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

Streaming SSR é uma técnica de renderização que envia conteúdo HTML ao cliente em chunks menores conforme são gerados no servidor, ao invés de esperar pela página completa ser totalmente renderizada. Esta abordagem usa Node streams para entregar markup progressivamente.

## Também Conhecido Como

- Progressive SSR
- Chunked Transfer Encoding
- HTTP Streaming

## Motivação

SSR tradicional espera toda a página ser renderizada antes de enviar resposta, causando atrasos especialmente para páginas complexas. Streaming SSR resolve isso enviando HTML incrementalmente conforme componentes são renderizados, permitindo que o navegador comece a processar e renderizar conteúdo antes da resposta completa chegar.

## Como Funciona

O servidor renderiza componentes React usando `renderToNodeStream()` (ou em React 18+, `renderToPipeableStream()`), que produz readable stream ao invés de string completa. O stream faz pipe de chunks de HTML para o response object conforme são gerados. Cliente começa a parsear e renderizar conteúdo imediatamente ao receber bytes iniciais, enquanto simultaneamente carrega metadata crítica como stylesheets e scripts.

### Implementação

```javascript
// React 18+
import { renderToPipeableStream } from 'react-dom/server';

const { pipe } = renderToPipeableStream(<App />, {
  onShellReady() {
    response.setHeader('content-type', 'text/html');
    pipe(response);
  },
  onError(error) {
    console.error(error);
  }
});
```

## Aplicabilidade

### Quando Usar

Streaming SSR é ideal para:
- Aplicações grandes priorizando Time-to-Interactive
- Sites com árvores complexas de componentes
- Cenários requerendo responsividade do servidor sob carga concorrente pesada
- Páginas com seções independentes que podem render em velocidades diferentes
- Aplicações onde usuários veem conteúdo parcial enquanto resto carrega

### Quando NÃO Usar

- Aplicações pequenas e simples onde overhead não compensa
- Casos onde toda página deve renderizar atomicamente
- Contextos requerendo output como string para composição de template
- Frameworks CSS-in-JS que geram stylesheets durante rendering (desafios)

## Estrutura

```
Servidor (Node.js)
├── Request Handler
├── React Component Tree
├── renderToPipeableStream()
│   ├── Shell (HTML inicial + <head>)
│   ├── Suspense Boundaries
│   └── Component Streams
└── HTTP Response Stream

Cliente (Navegador)
├── Recebe Chunks Progressivamente
├── Parse HTML Incremental
├── Renderiza Conteúdo Conforme Chega
└── Hydration Progressiva
```

## Participantes

- **Stream Renderer**: Função que renderiza React para stream
- **Response Stream**: HTTP response objeto que recebe chunks
- **Shell Content**: HTML inicial enviado imediatamente
- **Suspense Boundaries**: Pontos onde streaming pode ser pausado
- **Client Parser**: Navegador parseando HTML incrementalmente

## Colaborações

- Cliente faz request de página
- Servidor inicia rendering e envia shell imediatamente
- Componentes renderizam e fazem streaming conforme ficam prontos
- Suspense boundaries permitem atrasos de componentes sem bloquear outros
- Cliente recebe e renderiza chunks progressivamente
- Hydration ocorre conforme JavaScript carrega

## Consequências

### Vantagens

1. **Métricas de Performance Mais Rápidas**: "TTFB é reduzido e relativamente constante" e "resulta em FP e FCP rápidos" comparado a SSR tradicional

2. **Eficiência de Rede**: Manipula backpressure efetivamente — se rede está congestionada, streaming pausa até capacidade retornar, reduzindo uso de memória do servidor

3. **Responsividade do Servidor**: Habilita "seu servidor Node.js a renderizar múltiplas requests ao mesmo tempo e previne requests mais pesadas de bloquear requests mais leves"

4. **Suporte SEO**: Respostas streamed permanecem crawlable por search engines

### Desvantagens

1. **Complexidade de Implementação**: Código funcionando com `renderToString()` frequentemente requer refatoração significativa para streaming

2. **Desafios CSS-in-JS**: Frameworks que geram stylesheets durante rendering podem ter dificuldades, já que estilos críticos devem aparecer antes de conteúdo streamed

3. **Compatibilidade de String Limitada**: Cenários requerendo output de string para composição de template não funcionarão com streams

## Implementação

### Considerações

1. **Suspense Boundaries**: Definir onde componentes podem aguardar dados
2. **Error Boundaries**: Implementar tratamento robusto de erros
3. **Shell Design**: Decidir o que incluir no shell inicial
4. **Backpressure Handling**: Gerenciar fluxo de dados apropriadamente

### React 18+ com Suspense

```javascript
import { renderToPipeableStream } from 'react-dom/server';
import { Suspense } from 'react';

function App() {
  return (
    <html>
      <body>
        <Header />
        <Suspense fallback={<Spinner />}>
          <SlowComponent />
        </Suspense>
        <Footer />
      </body>
    </html>
  );
}

const { pipe } = renderToPipeableStream(<App />, {
  bootstrapScripts: ['/main.js'],
  onShellReady() {
    response.setHeader('content-type', 'text/html');
    pipe(response);
  }
});
```

### Técnicas

- Wrap componentes lentos em Suspense para streaming independente
- Enviar shell com CSS crítico imediatamente
- Use error boundaries para lidar com falhas gracefully
- Implement progressive hydration para interatividade mais rápida
- Monitor backpressure e ajuste buffering conforme necessário

## Uso Conhecido

- **Next.js 13+**: Suporte built-in para streaming SSR com App Router
- **Remix**: Streaming com defer() loader
- **React 18**: renderToPipeableStream API nativa
- **Hydrogen (Shopify)**: Streaming SSR para e-commerce
- **Large Content Sites**: Sites de notícias e media

## Métricas de Performance

- **TTFB (Time to First Byte)**: Significativamente reduzido
- **FP (First Paint)**: Muito rápido
- **FCP (First Contentful Paint)**: Rápido, conteúdo inicial aparece cedo
- **TTI (Time to Interactive)**: Melhorado com progressive hydration
- **Server Memory**: Reduzido com backpressure handling

## Padrões Relacionados

- [**Server-side Rendering**](009_server-side-rendering.md): Base para streaming SSR
- [**Selective Hydration**](015_selective-hydration.md): Complementar para hydration progressiva
- [**Progressive Hydration**](012_progressive-hydration.md): Padrão relacionado para interatividade
- [**React Server Components**](014_react-server-components.md): Pode ser combinado com streaming

### Relação com Rules

- [028 - Tratamento de Exceção Assíncrona](../../clean-code/008_tratamento-excecao-assincrona.md): crucial para streams
- [045 - Processos Stateless](../../twelve-factor/006_processos-stateless.md): servidores streaming stateless
- [047 - Concorrência via Processos](../../twelve-factor/008_concorrencia-via-processos.md): múltiplas requests simultâneas
- [048 - Descartabilidade de Processos](../../twelve-factor/009_descartabilidade-processos.md): processos podem ser interrompidos

## Integração com Suspense

```javascript
// Servidor
<Suspense fallback={<Spinner />}>
  <Comments />
</Suspense>

// Comentários fazem streaming quando dados chegam
function Comments() {
  const comments = use(fetchComments()); // React 18+ use()
  return comments.map(c => <Comment key={c.id} data={c} />);
}
```

## Melhores Práticas

- Identificar componentes lentos e wrap em Suspense
- Enviar shell com estrutura principal imediatamente
- Priorizar componentes críticos above-the-fold
- Implementar error boundaries para resiliência
- Monitor métricas de performance (TTFB, FCP, TTI)
- Test com connections lentas para validar benefícios
- Considerar progressive hydration junto com streaming
- Use loading states apropriados para feedback visual

---

**Criada em**: 2026-03-17
**Versão**: 1.0
