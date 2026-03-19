# Progressive Hydration

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

Progressive hydration é uma técnica de renderização que ativa seletivamente componentes server-rendered ao longo do tempo ao invés de hydrate toda a aplicação simultaneamente. Permite que partes individuais da página tornem-se interativas baseadas em condições específicas, reduzindo JavaScript inicial necessário para interatividade.

## Também Conhecido Como

- Selective Hydration (em React 18+)
- Lazy Hydration
- Partial Hydration

## Motivação

Server rendering gera HTML com CSS e dados JSON, produzindo First Contentful Paint rápido. No entanto, botões aparecem interativos antes de JavaScript anexar event handlers — criando experiência "uncanny valley". Progressive hydration aborda isso:

- Atrasando hydration de componentes menos críticos
- Carregando JavaScript para componentes apenas quando necessário (ex: quando visíveis no viewport)
- Reduzindo gap entre First Contentful Paint e Time To Interactive

O processo envolve code-splitting de componentes individualmente e ativá-los progressivamente conforme usuário navega ou interage com a página.

## Como Funciona

1. Servidor gera HTML completo com CSS inline
2. Cliente recebe e renderiza HTML (FCP rápido)
3. JavaScript é carregado progressivamente
4. Componentes críticos são hydrated primeiro
5. Componentes menos críticos são hydrated baseados em triggers:
   - Visibilidade no viewport (Intersection Observer)
   - Interação do usuário (hover, focus)
   - Idle time do navegador (requestIdleCallback)
   - Prioridade definida pelo desenvolvedor

## Aplicabilidade

### Quando Usar

Ideal para:
- Sites majoritariamente estáticos com elementos interativos seletivos
- Páginas content-heavy com componentes below-the-fold
- Aplicações onde nem todas features requerem ativação imediata
- Landing pages com seções complexas

### Quando NÃO Usar

Progressive hydration funciona mal para "aplicações dinâmicas onde cada elemento na tela está disponível ao usuário e precisa ser tornado interativo no load." Identificar quais componentes priorizar torna-se desafiador quando predição do desenvolvedor sobre comportamento do usuário é incerta.

## Estrutura

```
Initial Load
├── HTML Completo (do servidor)
├── CSS Crítico (inline)
└── JavaScript Mínimo (hydration scheduler)

Progressive Hydration
├── Critical Components → Hydrate imediatamente
├── Above-fold Components → Hydrate em idle time
├── Below-fold Components → Hydrate on viewport
└── Interactive-on-demand → Hydrate on interaction
```

## Participantes

- **Server Renderer**: Gera HTML completo
- **Hydration Scheduler**: Controla ordem e timing de hydration
- **Component Boundaries**: Pontos onde hydration pode ser adiada
- **Trigger Mechanisms**: Eventos que iniciam hydration
- **Priority Queue**: Gerencia ordem de hydration baseada em prioridade

## Colaborações

- Servidor renderiza árvore completa de componentes
- Cliente recebe HTML e CSS
- Scheduler identifica componentes e suas prioridades
- Componentes críticos são hydrated imediatamente
- Componentes não-críticos aguardam triggers apropriados
- Hydration ocorre incrementalmente conforme condições são atendidas

## Consequências

### Vantagens

1. **Promove Code-splitting**: Componentes são divididos em chunks para lazy-loading, reduzindo bundle overhead
2. **Carregamento On-demand**: Componentes estáticos e fora do viewport podem ser hydrated depois baseados em triggers
3. **Bundle Size Menor**: Menos JavaScript executa no load, diminuindo janela FCP-to-TTI

### Desvantagens

- **Complexidade de Implementação**: Requer lógica adicional para gerenciar hydration
- **Não Universal**: Inadequado para aplicações altamente interativas
- **Desafio de Priorização**: Decidir o que hydrate primeiro pode ser difícil
- **Experiência Inconsistente**: Elementos podem não responder imediatamente

## Implementação

### Considerações

1. **Component Boundaries**: Definir claramente onde hydration pode ser adiada
2. **Priority Strategy**: Determinar o que é crítico vs. opcional
3. **Trigger Selection**: Escolher triggers apropriados para cada componente
4. **Fallback Behavior**: Lidar com interações antes de hydration completa

### Técnicas de Implementação

```javascript
// Usando React.lazy e Suspense
const HeavyComponent = React.lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <div>
      <CriticalComponent /> {/* Hydrated imediatamente */}
      <Suspense fallback={<div>Loading...</div>}>
        <HeavyComponent /> {/* Hydrated quando necessário */}
      </Suspense>
    </div>
  );
}
```

### Hydration baseada em Viewport

```javascript
import { useInView } from 'react-intersection-observer';

function LazyComponent() {
  const { ref, inView } = useInView({
    triggerOnce: true,
    threshold: 0.1
  });

  return (
    <div ref={ref}>
      {inView ? <InteractiveComponent /> : <StaticHTML />}
    </div>
  );
}
```

### Hydration on Interaction

```javascript
function HydrateOnHover({ children }) {
  const [shouldHydrate, setShouldHydrate] = useState(false);

  return (
    <div
      onMouseEnter={() => setShouldHydrate(true)}
      onFocus={() => setShouldHydrate(true)}
    >
      {shouldHydrate ? children : <StaticVersion />}
    </div>
  );
}
```

## Uso Conhecido

- **React 18**: Selective Hydration built-in
- **Next.js**: Suporte experimental para partial hydration
- **Astro**: Islands Architecture (hydration seletiva por padrão)
- **Qwik**: Resumability (lazy loading extremo)
- **Google Search**: Progressive hydration para resultados

## Métricas de Performance

- **FCP (First Contentful Paint)**: Muito rápido
- **TTI (Time to Interactive)**: Reduzido significativamente
- **TBT (Total Blocking Time)**: Minimizado
- **JavaScript Bundle**: Drasticamente reduzido no initial load
- **User Interaction Delay**: Possível delay em componentes não-hydrated

## Padrões Relacionados

- [**Streaming SSR**](013_streaming-ssr.md): Complementar para entrega de HTML
- [**Selective Hydration**](015_selective-hydration.md): Implementação moderna em React 18
- [**Server-side Rendering**](009_server-side-rendering.md): Base para progressive hydration
- [**React Server Components**](014_react-server-components.md): Alternativa para componentes não-interativos

### Relação com Rules

- [022 - Priorização da Simplicidade e Clareza](../../clean-code/002_prioritization-simplicity-clarity.md): pode adicionar complexidade
- [032 - Cobertura Mínima de Teste](../../clean-code/012_cobertura-teste-minima-qualidade.md): testar diferentes estados de hydration

## Bibliotecas e Ferramentas

- **react-lazy-hydration**: Biblioteca para lazy hydration
- **react-intersection-observer**: Para hydration baseada em viewport
- **React 18 Suspense**: Suporte nativo para code splitting
- **next/dynamic**: Dynamic imports com SSR no Next.js

## Melhores Práticas

- Identificar componentes críticos para experiência inicial
- Usar Intersection Observer para componentes below-the-fold
- Implementar loading states para feedback visual
- Priorizar componentes above-the-fold
- Medir e monitorar métricas de performance
- Considerar mobile-first ao definir prioridades
- Test em connections lentas para validar estratégia

---

**Criada em**: 2026-03-17
**Versão**: 1.0
