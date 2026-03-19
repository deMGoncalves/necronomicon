# Server-side Rendering (SSR)

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

"Server-side rendering (SSR) é um dos métodos mais antigos de renderização de conteúdo web. SSR gera o HTML completo para o conteúdo da página a ser renderizado em resposta a uma requisição do usuário."

## Também Conhecido Como

- Traditional SSR
- Dynamic SSR
- Server Rendering

## Motivação

SSR opera executando lógica de renderização no servidor ao invés do cliente. O servidor manipula data fetching, conexões de API e geração de HTML antes de enviar a página completa para o navegador. Cada requisição do usuário dispara processamento independente do servidor, mesmo se requisições consecutivas produzem output similar.

## Como Funciona

1. Usuário requisita uma página
2. Servidor executa lógica de aplicação e faz data fetching
3. Servidor renderiza componentes React para HTML string
4. HTML completo é enviado ao cliente
5. Navegador exibe HTML (First Contentful Paint)
6. JavaScript é baixado e "hydrates" a página (Time to Interactive)

### Implementação Moderna

Implementações modernas como React podem renderizar isomorficamente usando `ReactDOMServer.renderToString()` para gerar HTML strings, que são então hydrated no cliente usando `ReactDOM.hydrate()`.

```javascript
// Servidor
import { renderToString } from 'react-dom/server';
const html = renderToString(<App />);

// Cliente
import { hydrate } from 'react-dom';
hydrate(<App />, document.getElementById('root'));
```

## Aplicabilidade

### Quando Usar

- Sites públicos que necessitam SEO
- Páginas content-heavy
- Aplicações onde First Contentful Paint é crítico
- Contextos onde JavaScript pode estar desabilitado
- Páginas com conteúdo personalizado dinâmico

### Quando NÃO Usar

- Aplicações altamente interativas com atualizações frequentes
- Dashboards real-time
- Aplicações tipo SPA onde SEO não é necessário

## Estrutura

```
Cliente (Navegador)
├── HTML Completo (do servidor)
├── CSS Inline ou Linked
├── JavaScript Bundle
│   └── Código de Hydration
└── Event Handlers (após hydration)

Servidor
├── React App Instance
├── Data Fetching Layer
├── HTML Rendering
└── Response com HTML completo
```

## Participantes

- **Server Renderer**: Executa componentes React e gera HTML
- **Data Layer**: Busca dados necessários antes de renderizar
- **HTML Response**: Página completa enviada ao cliente
- **Hydration Script**: JavaScript que torna página interativa
- **Client Router**: Gerencia navegação após hydration

## Colaborações

- Cliente requisita página do servidor
- Servidor executa data fetching e business logic
- Servidor renderiza componentes React para HTML
- HTML completo é enviado ao cliente
- Cliente exibe conteúdo imediatamente
- JavaScript baixa e hydrates a página para interatividade

## Consequências

### Vantagens

**Benefícios de Performance**
- Reduz JavaScript enviado aos clientes, resultando em "FCP e TTI mais rápidos" comparado a client-side rendering
- Cria "budget adicional para JavaScript client-side" eliminando requisitos de código de renderização
- Habilita otimização para search engines através de conteúdo crawlable

**Experiência do Usuário**
- Conteúdo aparece imediatamente sem esperar execução de JavaScript
- FCP e TTI convergem, eliminando períodos de espera do usuário

### Desvantagens

**Limitações Técnicas**
- "TTFB lento" devido a atrasos de processamento do servidor por cargas concorrentes altas, latência de rede, ou código não otimizado
- "Page reloads completos requeridos para algumas interações" porque funcionalidade client-side é limitada
- Single-page applications tornam-se impráticas

## Implementação

### Considerações

1. **Data Fetching**: Resolver todos os dados antes de renderizar
2. **Performance**: Otimizar queries de banco e lógica de servidor
3. **Caching**: Implementar estratégias de cache apropriadas
4. **Hydration**: Garantir que HTML do servidor corresponda ao client render

### Abordagens Modernas

React 18+ introduz **Streaming SSR com Suspense** usando `renderToPipeableStream()`, que envia HTML chunks progressivamente ao invés de esperar por renders completos.

```javascript
import { renderToPipeableStream } from 'react-dom/server';

const { pipe } = renderToPipeableStream(<App />, {
  onShellReady() {
    response.setHeader('content-type', 'text/html');
    pipe(response);
  }
});
```

**React Server Components (RSC)** permitem server-side rendering sem enviar JavaScript associado aos clientes, reduzindo significativamente tamanhos de bundle.

### Técnicas

- Use streaming SSR para melhor TTFB
- Implemente caching strategies (CDN, Redis)
- Otimize database queries e API calls
- Use React Server Components quando possível
- Considere ISR para conteúdo semi-estático

## Uso Conhecido

- **Next.js**: Framework com SSR first-class
- **Remix**: Framework focado em SSR e web fundamentals
- **WordPress**: CMS tradicional com SSR
- **Ruby on Rails**: Framework MVC com SSR
- **Laravel**: PHP framework com blade templating

## Métricas de Performance

- **TTFB (Time to First Byte)**: Pode ser lento devido a processamento do servidor
- **FCP (First Contentful Paint)**: Rápido, conteúdo visível imediatamente
- **TTI (Time to Interactive)**: Próximo de FCP após hydration
- **SEO Score**: Excelente, conteúdo totalmente crawlable

## Padrões Relacionados

- [**Client-side Rendering**](008_client-side-rendering.md): Abordagem alternativa de renderização
- [**Static Rendering**](010_static-rendering.md): Híbrido para conteúdo estático
- [**Streaming SSR**](013_streaming-ssr.md): Evolução moderna de SSR
- [**React Server Components**](014_react-server-components.md): Complementar a SSR
- [**Selective Hydration**](015_selective-hydration.md): Otimização de hydration

### Relação com Rules

- [043 - Serviços de Apoio como Recursos](../../twelve-factor/004_servicos-apoio-recursos.md): data sources
- [045 - Processos Stateless](../../twelve-factor/006_processos-stateless.md): servidores SSR stateless
- [047 - Concorrência via Processos](../../twelve-factor/008_concorrencia-via-processos.md): escalabilidade
- [048 - Descartabilidade de Processos](../../twelve-factor/009_descartabilidade-processos.md): processos SSR descartáveis

## Considerações de Performance

SSR excele para conteúdo estático mas tem dificuldades com interações dinâmicas e atualizações real-time requerendo comunicação frequente com servidor.

Frameworks modernos como Next.js e Remix otimizam SSR com:
- Streaming de respostas
- Prefetching de dados
- Caching inteligente
- Hydration seletiva
- Server Components

---

**Criada em**: 2026-03-17
**Versão**: 1.0
