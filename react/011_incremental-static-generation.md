# Incremental Static Generation (ISR)

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

iSSG é uma evolução de Static Site Generation (SSG) que possibilita atualizações de conteúdo dinâmico. Ele "permite atualizar páginas existentes e adicionar novas ao pré-renderizar um subconjunto de páginas em background" sem requerer rebuilds completos do site.

## Também Conhecido Como

- Incremental Static Regeneration (ISR)
- On-demand Static Generation
- Stale-While-Revalidate Pattern

## Motivação

SSG tradicional requer rebuilds completos para atualizar conteúdo, o que é impraticável para sites grandes com atualizações frequentes. ISR resolve isso permitindo que páginas individuais sejam regeneradas em background após serem servidas, combinando benefícios de SSG (performance) com flexibilidade de conteúdo dinâmico.

## Como Funciona

iSSG opera através de dois mecanismos:

### 1. Adicionando Novas Páginas

Usa lazy loading para gerar novas páginas na primeira requisição. Uma página fallback ou indicador de loading é exibido enquanto geração ocorre em background.

```javascript
export async function getStaticPaths() {
  return {
    paths: ['/post/1', '/post/2'], // páginas pré-geradas
    fallback: 'blocking' // gerar outras páginas on-demand
  };
}
```

### 2. Atualizando Páginas Existentes

Define timeouts de revalidação (tão baixo quanto 1 segundo) para atualizar páginas periodicamente. Usa estratégia stale-while-revalidate — "o usuário recebe a versão cached ou stale enquanto a revalidação ocorre."

```javascript
export async function getStaticProps() {
  const data = await fetchData();

  return {
    props: { data },
    revalidate: 60 // revalidar a cada 60 segundos
  };
}
```

## Aplicabilidade

### Quando Usar

Melhor para sites crescentes com conteúdo majoritariamente estático que requer atualizações ocasionais:
- Blogs com múltiplos posts
- E-commerce com mudanças periódicas de inventário
- Portfólios com projetos adicionados periodicamente
- Sites de notícias com atualizações regulares
- Documentação com updates frequentes

### Quando NÃO Usar

- Conteúdo que deve estar sempre atualizado instantaneamente
- Dados altamente personalizados por usuário
- Dashboards real-time
- Aplicações com mudanças de dados extremamente frequentes

## Estrutura

```
Build Time
├── Páginas Principais Pré-geradas
└── Paths para geração on-demand

Runtime
├── Request de Página
│   ├── Existe? → Serve página cached
│   │   └── Tempo de revalidação passou?
│   │       ├── Sim → Regenera em background
│   │       └── Não → Serve cached
│   └── Não existe? → Gera on-demand (fallback)
```

## Participantes

- **Static Pages**: Páginas pré-geradas em build time
- **Revalidation Timer**: Controla quando páginas são regeneradas
- **Background Regeneration**: Processo que atualiza páginas stale
- **Fallback Handler**: Gerencia requisições para páginas não-geradas
- **Cache Layer**: Armazena versões de páginas

## Colaborações

- Cliente requisita página
- Se página existe e não está stale, serve imediatamente
- Se página está stale, serve versão cached e dispara regeneração
- Regeneração ocorre em background
- Próxima requisição recebe versão atualizada
- Se página não existe, gera on-demand

## Consequências

### Vantagens

- **Suporte a Dados Dinâmicos**: Manipula conteúdo frequentemente mudando sem rebuilds
- **Velocidade**: Pré-renderização ocorre em background com processamento mínimo
- **Disponibilidade**: Versões recentes de páginas sempre acessíveis; versões antigas persistem se regeneração falha
- **Consistência**: Regeneração gradual server-side mantém carga baixa de database
- **Distribuição**: Compatível com CDN como SSG padrão

### Desvantagens

Limitações não explicitamente listadas no material fonte, embora incluam:
- Atualizações atrasadas durante períodos de revalidação
- Complexidade gerenciando timeouts
- Possibilidade de servir conteúdo stale
- Configuração mais complexa que SSG puro

## Implementação

### Considerações

1. **Revalidation Time**: Balancear freshness vs. carga do servidor
2. **Fallback Strategy**: Decidir entre blocking, true, ou false
3. **Error Handling**: Lidar com falhas de regeneração
4. **Cache Strategy**: Configurar caching apropriado em CDN

### Implementação Next.js

```javascript
// pages/posts/[id].js
export async function getStaticProps({ params }) {
  const post = await getPost(params.id);

  return {
    props: { post },
    revalidate: 60 // revalidar a cada 60 segundos
  };
}

export async function getStaticPaths() {
  const posts = await getPopularPosts();

  return {
    paths: posts.map(post => ({
      params: { id: post.id }
    })),
    fallback: 'blocking' // ou true/false
  };
}
```

### Fallback Strategies

- **`fallback: false`**: Apenas paths retornados de getStaticPaths são válidos (404 para outros)
- **`fallback: true`**: Mostra fallback UI enquanto página gera
- **`fallback: 'blocking'`**: Espera página gerar antes de mostrar (como SSR)

### Técnicas

- Use revalidação on-demand via API routes
- Implemente fallback pages user-friendly
- Configure CDN para respeitar cache headers
- Monitor regeneration failures e implemente fallbacks
- Use revalidation times apropriados para tipo de conteúdo

## Uso Conhecido

- **Next.js**: Suporte first-class para ISR
- **Vercel**: Infraestrutura otimizada para ISR
- **Large E-commerce Sites**: Páginas de produtos com ISR
- **News Websites**: Artigos com atualizações periódicas
- **Documentation Sites**: Docs com updates frequentes

## Métricas de Performance

- **TTFB**: Rápido (serving cached pages)
- **FCP**: Instantâneo para páginas cached
- **TTI**: Rápido após JavaScript load
- **Content Freshness**: Balanceado com revalidation time
- **Build Time**: Significativamente reduzido vs. SSG completo

## Padrões Relacionados

- [**Static Rendering**](010_static-rendering.md): Base para ISR
- [**Server-side Rendering**](009_server-side-rendering.md): Alternativa para conteúdo sempre fresh
- [**Client-side Rendering**](008_client-side-rendering.md): Para partes completamente dinâmicas
- [**React Stack Patterns**](007_react-stack-patterns.md): Contexto arquitetural moderno

### Relação com Rules

- [043 - Serviços de Apoio como Recursos](../../twelve-factor/004_servicos-apoio-recursos.md): data sources anexáveis
- [044 - Separação Build, Release, Run](../../twelve-factor/005_separacao-build-release-run.md): build vs. runtime regeneration
- [045 - Processos Stateless](../../twelve-factor/006_processos-stateless.md): regeneração stateless

## On-Demand Revalidation

Next.js permite revalidação manual via API routes:

```javascript
// pages/api/revalidate.js
export default async function handler(req, res) {
  // Verificar token secreto
  if (req.query.secret !== process.env.REVALIDATE_SECRET) {
    return res.status(401).json({ message: 'Invalid token' });
  }

  try {
    await res.revalidate('/path-to-revalidate');
    return res.json({ revalidated: true });
  } catch (err) {
    return res.status(500).send('Error revalidating');
  }
}
```

## Melhores Práticas

- Escolher revalidation times baseados em frequência de mudança de conteúdo
- Implementar on-demand revalidation para atualizações críticas
- Usar fallback: 'blocking' para páginas importantes
- Monitor build e revalidation times
- Implementar error handling robusto
- Combinar com CSR para seções altamente dinâmicas

---

**Criada em**: 2026-03-17
**Versão**: 1.0
