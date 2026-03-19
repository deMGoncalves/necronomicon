# React Patterns

Esta pasta contém documentação abrangente de padrões de design e renderização para React, baseados em [patterns.dev/react](https://www.patterns.dev/react/).

## Visão Geral

Os padrões estão organizados em duas categorias principais:

### Design Patterns (001-007)

Padrões de design focados em arquitetura de componentes, reutilização de código e organização estrutural de aplicações React.

### Rendering Patterns (008-015)

Padrões de renderização que abordam diferentes estratégias para entregar conteúdo ao cliente, otimizando performance, SEO e experiência do usuário.

## Índice de Padrões

### Design Patterns

1. **[HOC Pattern](001_hoc-pattern.md)** - Higher-Order Components para reutilização de lógica
2. **[Hooks Pattern](002_hooks-pattern.md)** - Gerenciamento de estado e lifecycle em componentes funcionais
3. **[Compound Pattern](003_compound-pattern.md)** - Componentes que trabalham juntos compartilhando estado
4. **[Container/Presentational Pattern](004_container-presentational-pattern.md)** - Separação de lógica de negócio e renderização
5. **[Render Props Pattern](005_render-props-pattern.md)** - Compartilhamento de código através de props funcionais
6. **[AI UI Patterns](006_ai-ui-patterns.md)** - Padrões para interfaces com IA conversacional e LLMs
7. **[React Stack Patterns 2026](007_react-stack-patterns.md)** - Arquitetura e stack moderno para React em 2026

### Rendering Patterns

8. **[Client-side Rendering](008_client-side-rendering.md)** - Renderização completa no navegador
9. **[Server-side Rendering](009_server-side-rendering.md)** - Renderização de HTML no servidor
10. **[Static Rendering](010_static-rendering.md)** - Geração de HTML estático em build time
11. **[Incremental Static Generation](011_incremental-static-generation.md)** - Atualização incremental de páginas estáticas
12. **[Progressive Hydration](012_progressive-hydration.md)** - Hydration seletiva e progressiva de componentes
13. **[Streaming SSR](013_streaming-ssr.md)** - Streaming de HTML do servidor em chunks
14. **[React Server Components](014_react-server-components.md)** - Componentes que executam exclusivamente no servidor
15. **[Selective Hydration](015_selective-hydration.md)** - Hydration independente de componentes (React 18+)

## Estrutura dos Documentos

Cada documento de padrão segue uma estrutura consistente:

- **Classificação**: Categoria do padrão
- **Intenção e Objetivo**: O que o padrão resolve
- **Também Conhecido Como**: Nomes alternativos
- **Motivação**: Por que o padrão existe
- **Aplicabilidade**: Quando usar e quando não usar
- **Estrutura**: Como o padrão é organizado
- **Participantes**: Componentes envolvidos
- **Colaborações**: Como os participantes interagem
- **Consequências**: Vantagens e desvantagens
- **Implementação**: Considerações e técnicas práticas
- **Uso Conhecido**: Exemplos reais de uso
- **Padrões Relacionados**: Links para padrões complementares
- **Relação com Rules**: Links para regras de arquitetura relacionadas

## Como Usar Este Material

### Para Aprendizado

1. Comece pelos **Design Patterns** fundamentais (Hooks, HOC)
2. Avance para padrões de composição (Compound, Render Props)
3. Explore **Rendering Patterns** começando por CSR e SSR
4. Estude padrões avançados (RSC, Streaming, Selective Hydration)
5. Finalize com **React Stack Patterns** para visão arquitetural completa

### Para Referência

Use o índice acima para localizar rapidamente o padrão específico que você precisa consultar. Cada documento é independente e pode ser lido isoladamente.

### Para Decisões Arquiteturais

1. Revise **React Stack Patterns** para orientação arquitetural geral
2. Consulte padrões de renderização específicos baseado em seus requisitos:
   - SEO crítico? → SSR ou SSG
   - Performance crítica? → Streaming SSR + RSC
   - Conteúdo estático? → SSG + ISR
   - Aplicação interativa? → CSR com otimizações

## Evolução dos Padrões

### Padrões Legados (ainda válidos mas menos recomendados)

- **HOC Pattern**: Em grande parte substituído por Hooks
- **Render Props Pattern**: Hooks oferecem alternativa mais limpa
- **Container/Presentational**: Hooks eliminam necessidade

### Padrões Modernos (React 18+)

- **Hooks Pattern**: Base fundamental do React moderno
- **Streaming SSR**: Performance melhorada com Suspense
- **Selective Hydration**: Interatividade progressiva
- **React Server Components**: Redução drástica de bundle size

### Padrões Emergentes (2026)

- **AI UI Patterns**: Crescente com adoção de LLMs
- **React Stack Patterns**: Arquitetura framework-first
- **Hybrid Rendering**: Combinação de múltiplas estratégias

## Recursos Adicionais

- **Documentação Oficial**: [react.dev](https://react.dev)
- **Patterns.dev**: [patterns.dev/react](https://www.patterns.dev/react)
- **Next.js Docs**: [nextjs.org/docs](https://nextjs.org/docs)
- **React 18**: [react.dev/blog/2022/03/29/react-v18](https://react.dev/blog/2022/03/29/react-v18)

## Relação com Regras de Arquitetura

Estes padrões complementam as regras de arquitetura em `../object-calisthenics/, ../solid/, ../clean-code/`, especialmente:

- **Princípios SOLID**: Aplicados em padrões de componentes
- **Regras de Performance**: Relacionadas a rendering patterns
- **Regras de Infraestrutura**: Relevantes para deployment de aplicações React

## Contribuição e Atualização

Estes documentos refletem o estado da arte em 2026. React continua evoluindo, e novos padrões emergem regularmente. Mantenha-se atualizado com:

- Release notes oficiais do React
- Atualizações de frameworks (Next.js, Remix)
- Comunidade e conferências React

---

**Atualizado em**: 2026-03-17
**Versão**: 1.0
**Fonte**: [patterns.dev/react](https://www.patterns.dev/react)
