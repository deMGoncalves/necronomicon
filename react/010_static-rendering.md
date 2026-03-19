# Static Rendering (SSG)

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

Static Rendering (também chamado Static Site Generation ou SSG) é uma abordagem de renderização que "entrega conteúdo HTML pré-renderizado ao cliente que foi gerado quando o site foi construído." Um arquivo HTML estático é criado antecipadamente para cada rota acessível.

## Também Conhecido Como

- Static Site Generation (SSG)
- Pre-rendering
- Build-time Rendering

## Motivação

SSG move o processo de renderização para build time ao invés de request time ou runtime. Páginas HTML são geradas uma vez durante o processo de build e reutilizadas para todas as requisições, eliminando necessidade de processamento do servidor por requisição e permitindo serving extremamente rápido via CDNs.

## Como Funciona

1. Durante build time, o site é completamente renderizado
2. Arquivos HTML estáticos são gerados para cada rota
3. Dados podem ser fetched de databases usando funções como `getStaticProps()` e `getStaticPaths()` (em Next.js)
4. Arquivos estáticos são servidos de servidor ou CDN quando requisitados
5. Páginas são cached para resiliência melhorada e tempos de resposta mais rápidos

## Aplicabilidade

### Quando Usar

SSG é ideal para conteúdo que não requer personalização do usuário:
- Páginas About/Contact
- Páginas de blog
- Páginas de produtos
- Conteúdo de site estático
- Documentação
- Marketing pages

### Quando NÃO Usar

**Não adequado** para conteúdo altamente dinâmico ou personalizado que muda frequentemente:
- Dashboards personalizados
- Feeds real-time
- Conteúdo user-specific
- Aplicações com dados em constante mudança

## Estrutura

```
Build Time
├── Data Fetching (APIs, Database, CMS)
├── React Component Rendering
├── HTML Generation
└── Static Files Output

Runtime
├── CDN/Server
├── Static HTML Files
├── CSS Files
├── JavaScript Bundle (para interatividade)
└── Assets (imagens, etc.)
```

## Participantes

- **Build Process**: Processo que gera HTML estático
- **Data Sources**: APIs, databases, CMS acessados em build time
- **Static HTML Files**: Páginas pré-renderizadas
- **CDN**: Content Delivery Network para distribuição
- **Client Hydration**: JavaScript que adiciona interatividade

## Colaborações

- Build process fetches dados de todas as fontes
- Componentes React são renderizados para HTML
- HTML estático é gerado para cada rota
- Arquivos são deployados para CDN ou servidor estático
- Cliente recebe HTML pré-renderizado instantaneamente
- JavaScript hydrates para adicionar interatividade

## Consequências

### Vantagens

- **Performance Superior**: Processamento mínimo do servidor resulta em TTFB (Time to First Byte), FCP (First Contentful Paint) e TTI (Time to Interactive) rápidos
- **SEO-Friendly**: Conteúdo já está renderizado e facilmente crawlable por web crawlers
- **Carga Reduzida**: Baixos requisitos de bandwidth e execução mínima de JavaScript client-side necessária
- **Benefícios de Caching**: Arquivos estáticos podem ser extensively cached em CDNs para resiliência

### Desvantagens

1. **Desafios de Escala**: Gerenciar grandes números de arquivos HTML torna-se complexo, especialmente com atualizações frequentes de conteúdo
2. **Requisitos de Hosting**: Performance depende fortemente de infraestrutura de CDN de qualidade
3. **Staleness de Conteúdo**: Sites requerem rebuilds e redeployments para atualizações de conteúdo; mudanças não refletem até o próximo build

## Implementação

### Considerações

1. **Build Time**: Pode ser longo para sites com muitas páginas
2. **Data Freshness**: Decidir com que frequência rebuildar
3. **Dynamic Routes**: Gerar paths para todas as rotas dinâmicas
4. **Fallback Handling**: Lidar com páginas que não existem em build time

### Técnicas Next.js

```javascript
// getStaticProps - fetch data em build time
export async function getStaticProps() {
  const data = await fetchData();
  return {
    props: { data }
  };
}

// getStaticPaths - gerar paths para rotas dinâmicas
export async function getStaticPaths() {
  const paths = await fetchAllPaths();
  return {
    paths,
    fallback: false
  };
}
```

### Técnicas

- Use Incremental Static Regeneration para atualizações
- Implemente fallback pages para rotas desconhecidas
- Optimize build time com caching e paralelização
- Use CDN para distribuição global
- Considere partial rebuilds quando possível

## Uso Conhecido

- **Gatsby**: Framework focado em SSG
- **Next.js**: Suporta SSG via getStaticProps
- **Hugo**: Static site generator rápido
- **Jekyll**: SSG popular para GitHub Pages
- **Eleventy**: SSG simples e flexível

## Métricas de Performance

- **TTFB (Time to First Byte)**: Extremamente rápido
- **FCP (First Contentful Paint)**: Instantâneo
- **TTI (Time to Interactive)**: Rápido após JavaScript load
- **SEO Score**: Excelente, conteúdo totalmente crawlable
- **Build Time**: Pode ser longo para sites grandes

## Padrões Relacionados

- [**Incremental Static Generation**](011_incremental-static-generation.md): Evolução de SSG
- [**Server-side Rendering**](009_server-side-rendering.md): Alternativa para conteúdo dinâmico
- [**Client-side Rendering**](008_client-side-rendering.md): Para partes interativas
- [**React Stack Patterns**](007_react-stack-patterns.md): Contexto arquitetural

### Relação com Rules

- [040 - Base de Código Única](../../twelve-factor/001_base-codigo-unica.md): single codebase para static generation
- [044 - Separação Build, Release, Run](../../twelve-factor/005_separacao-build-release-run.md): build-time generation
- [049 - Paridade Dev/Prod](../../twelve-factor/010_paridade-dev-prod.md): consistência de ambiente

## Frameworks e Ferramentas

### Next.js
```javascript
export default function Page({ data }) {
  return <div>{data.title}</div>;
}

export async function getStaticProps() {
  const res = await fetch('https://api.example.com/data');
  const data = await res.json();

  return {
    props: { data },
    revalidate: 60 // ISR: revalidar a cada 60 segundos
  };
}
```

### Gatsby
```javascript
export const query = graphql`
  query {
    allMarkdownRemark {
      edges {
        node {
          frontmatter {
            title
          }
        }
      }
    }
  }
`;
```

## Melhores Práticas

- Usar para conteúdo que muda infrequentemente
- Combinar com ISR para atualizações periódicas
- Implementar caching strategies agressivas
- Otimizar images e assets para fast loading
- Use CDN para distribuição global
- Considerar hybrid approaches (SSG + CSR para partes dinâmicas)

---

**Criada em**: 2026-03-17
**Versão**: 1.0
