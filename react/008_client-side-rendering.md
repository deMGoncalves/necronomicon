# Client-Side Rendering (CSR)

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

"Em Client-Side Rendering (CSR) apenas o HTML básico de container para uma página é renderizado pelo servidor. A lógica, data fetching, templating e roteamento necessários para exibir conteúdo na página são tratados por código JavaScript que executa no navegador/cliente."

## Também Conhecido Como

- SPA (Single Page Application)
- Browser Rendering
- JavaScript Rendering

## Motivação

CSR move a responsabilidade de renderização do servidor para o cliente, permitindo aplicações ricas e interativas que se comportam como aplicações desktop. O servidor envia HTML mínimo com um container raiz, e JavaScript executando no navegador manipula todo o templating, recuperação de dados, roteamento e atualizações de UI.

## Como Funciona

1. Servidor envia HTML mínimo com elemento container raiz
2. JavaScript executando no navegador carrega e inicia
3. Aplicação JavaScript manipula todo templating e data fetching
4. Mudanças de conteúdo ocorrem in-place sem round trips ao servidor
5. Navegação acontece sem page refreshes (Single Page Application)

## Aplicabilidade

### Quando Usar

- Ferramentas internas e dashboards administrativos
- Aplicações altamente interativas tipo app
- Contextos onde SEO não é necessário
- Ambientes controlados com boa conectividade

### Quando NÃO Usar

- Páginas públicas críticas para SEO
- Sites content-rich
- Aplicações onde Time-to-Interactive é crítico
- Contextos com conectividade variável

## Estrutura

```
Cliente (Navegador)
├── HTML Mínimo (<div id="root"></div>)
├── Bundle JavaScript
│   ├── Framework React
│   ├── Código da Aplicação
│   ├── Roteamento
│   ├── Data Fetching
│   └── Templating
└── Assets (CSS, Images)

Servidor
└── HTML Shell estático
```

## Participantes

- **HTML Shell**: Container mínimo servido pelo servidor
- **JavaScript Bundle**: Código completo da aplicação incluindo React
- **Router**: Gerenciamento de rotas client-side
- **Data Layer**: Lógica de fetching e gerenciamento de dados
- **UI Components**: Componentes React que renderizam interface

## Colaborações

- Servidor serve HTML shell e assets estáticos
- Navegador baixa e executa bundle JavaScript
- JavaScript framework monta aplicação no container root
- Router gerencia navegação sem page loads
- Componentes fazem fetching de dados conforme necessário

## Consequências

### Vantagens

- **Interatividade Rica**: Fornece experiências responsivas tipo app após carregamento inicial
- **Roteamento Mais Rápido**: Navegação entre páginas geralmente ocorre mais rápido já que dados mínimos são necessários do servidor
- **Separação Clara**: Desenvolvedores alcançam limites distintos entre código cliente e servidor
- **Atualizações Real-Time**: Dados podem ser atualizados continuamente (preços de ações, taxas de câmbio) sem page reloads

### Desvantagens

- **Limitações de SEO**: Web crawlers têm dificuldade com conteúdo pesado em JavaScript; conteúdo significativo pode não renderizar rápido o suficiente para indexação
- **Performance de Carregamento Inicial**: Usuários experienciam lag esperando bundles JavaScript baixarem e executarem antes de ver conteúdo
- **Duplicação de Código**: Lógica de validação e formatação frequentemente repete entre implementações client e server
- **Atrasos de Data Fetching**: Data loading event-driven pode adicionar ao tempo de interação, especialmente com datasets grandes

## Implementação

### Considerações

1. **JavaScript Budget**: Manter bundles sob 100-170KB (minified, gzipped)
2. **Code Splitting**: Dividir aplicação em chunks carregáveis dinamicamente
3. **Data Fetching**: Implementar estratégias eficientes de caching e fetching
4. **SEO**: Considerar pre-rendering ou SSR para páginas públicas

### Estratégias de Otimização de Performance

- Manter JavaScript budgets sob 100-170KB (minified, gzipped)
- Implementar preloading para recursos críticos
- Usar lazy loading para componentes não-essenciais
- Aplicar code splitting para criar bundles dynamically-loaded
- Fazer cache de application shells com service workers para funcionalidade offline

### Técnicas

- Use React.lazy() e Suspense para code splitting
- Implemente prefetching de dados para rotas
- Use service workers para caching e offline support
- Otimize bundle size com tree-shaking
- Considere micro-frontends para aplicações grandes

## Uso Conhecido

- **Gmail**: Interface de email rica e interativa
- **Facebook**: Feed de notícias dinâmico
- **Trello**: Board management application
- **Figma**: Design tool web-based
- **VS Code Web**: Editor de código no navegador

## Métricas de Performance

- **FCP (First Contentful Paint)**: Lento devido a download de JavaScript
- **TTI (Time to Interactive)**: Gap significativo após FCP
- **TTFB (Time to First Byte)**: Rápido (HTML mínimo)
- **Bundle Size**: Crítico para performance

## Padrões Relacionados

- [**Server-side Rendering**](009_server-side-rendering.md): Abordagem alternativa de renderização
- [**Static Rendering**](010_static-rendering.md): Híbrido para conteúdo estático
- [**Progressive Hydration**](012_progressive-hydration.md): Técnica para melhorar CSR
- [**React Stack Patterns**](007_react-stack-patterns.md): Contexto arquitetural moderno

### Relação com Rules

- [045 - Processos Stateless](../../twelve-factor/006_processos-stateless.md): arquitetura client-side stateless
- [046 - Port Binding](../../twelve-factor/007_port-binding.md): servir aplicação via port binding
- [050 - Logs como Fluxo de Eventos](../../twelve-factor/011_logs-fluxo-eventos.md): logging client-side

## Contexto Moderno

Melhores práticas modernas desencorajam CSR puro para páginas content-rich ou públicas. No entanto, CSR permanece adequado para dashboards internos, painéis administrativos e aplicações onde SEO é desnecessário.

React 18+ fornece melhores ferramentas para híbridos, e a recomendação é usar frameworks como Next.js que suportam múltiplas estratégias de renderização ao invés de CSR puro.

---

**Criada em**: 2026-03-17
**Versão**: 1.0
