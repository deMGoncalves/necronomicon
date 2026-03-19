# React Server Components (RSC)

**Classificação**: Padrão de Renderização React

---

## Intenção e Objetivo

React Server Components habilitam **UX moderna com modelo mental server-driven**, permitindo que componentes renderizem no servidor sem enviar JavaScript associado ao cliente. Estão agora production-ready em Next.js 13+ com App Router.

## Também Conhecido Como

- RSC
- Server Components
- Zero-Bundle Components

## Motivação

Componentes tradicionais de React enviam todo seu código JavaScript para o cliente, mesmo quando apenas renderizam conteúdo estático ou fazem data fetching. React Server Components resolvem isso permitindo que componentes executem exclusivamente no servidor, reduzindo drasticamente bundle sizes e melhorando performance enquanto mantêm interatividade onde necessário.

## Como Funciona

Server Components operam através de formato de abstração intermediário ao invés de renderização HTML direta. O processo envolve:

1. Renderizar componentes no servidor ahead of time
2. Fazer streaming de resultados para cliente sem bundling do código do componente
3. Mesclar server-tree com client-side tree preservando estado
4. Code-split automaticamente tratando imports em Client components como pontos de split

### Estrutura de Arquivo

```javascript
// app/page.js (Server Component por padrão)
async function Page() {
  const data = await fetchData(); // Acesso direto a database/API
  return <div>{data}</div>;
}

// app/client-button.js (Client Component)
'use client';
export function ClientButton() {
  return <button onClick={() => alert('Clicked!')}>Click me</button>;
}
```

## Aplicabilidade

### Quando Usar

- Otimizar bundle size para lógica de data-fetching
- Fazer fetching de dados sensíveis server-side
- Usar bibliotecas grandes (markdown parsers, sanitizers)
- Renderizar maioria da estrutura da página
- Componentes que não requerem interatividade
- Data fetching em qualquer nível da árvore de componentes

### Quando NÃO Usar

- Componentes requerendo event handlers (onClick, onChange)
- Componentes usando React hooks (useState, useEffect)
- Componentes usando browser-only APIs
- Partes altamente interativas da UI

## Estrutura

```
Server Components
├── Executam no Servidor
├── Podem acessar databases diretamente
├── Podem usar bibliotecas Node.js
├── Não enviam JavaScript ao cliente
└── Podem importar Client Components

Client Components
├── Executam no Cliente
├── Requerem diretiva 'use client'
├── Podem usar hooks e event handlers
├── Código é enviado ao cliente
└── Não podem importar Server Components diretamente
```

## Participantes

- **Server Component**: Componente que renderiza no servidor
- **Client Component**: Componente marcado com 'use client'
- **Server Data**: Dados fetched diretamente no servidor
- **RSC Payload**: Formato intermediário streamed ao cliente
- **Client Reconciler**: Mescla server output com client tree

## Colaborações

- Server Components renderizam no servidor com acesso completo a backend
- Podem fazer data fetching usando async/await diretamente no corpo do componente
- Output é serializado em formato especial (RSC payload)
- Cliente recebe payload e reconstrói árvore de componentes
- Client Components são hydrated com JavaScript
- Estado de Client Components é preservado durante re-fetching de Server Components

## Consequências

### Vantagens

**Redução de Bundle Size**: "Economia de código de mais de 240K (não-comprimido)" eliminando bibliotecas dos bundles. Relatórios iniciais mostram reduções de 20%+ em JavaScript client-side.

**Acesso ao Backend**: Server components habilitam "acesso ao back-end de qualquer lugar na árvore," diferente de SSR tradicional onde apenas `getServerSideProps` em nível de página é possível.

**Preservação de Estado**: Componentes podem ser re-fetched enquanto mantêm estado client-side, já que mecanismo de transporte é mais rico que HTML sozinho.

**Code-Splitting Automático**: Imports normais são tratados como potenciais pontos de code-split, eliminando configuração manual de `React.lazy()`.

### Desvantagens

- **Curva de Aprendizado**: Novo modelo mental para desenvolvedores
- **Limitações de Interatividade**: Server Components não podem usar hooks ou event handlers
- **Complexidade de Debugging**: Depurar interações server-client pode ser desafiador
- **Requer Framework**: Melhor suporte em frameworks como Next.js

## Implementação

### Considerações

1. **Component Boundaries**: Decidir o que é Server vs. Client Component
2. **Data Fetching**: Aproveitar data fetching direto em Server Components
3. **Composição**: Server Components podem renderizar Client Components, mas não vice-versa
4. **Serialização**: Dados passados de Server para Client devem ser serializáveis

### Padrões de Implementação

```javascript
// Server Component (padrão)
async function BlogPost({ id }) {
  const post = await db.posts.findUnique({ where: { id } });

  return (
    <article>
      <h1>{post.title}</h1>
      <p>{post.content}</p>
      <LikeButton postId={id} /> {/* Client Component */}
    </article>
  );
}

// Client Component
'use client';
function LikeButton({ postId }) {
  const [liked, setLiked] = useState(false);

  return (
    <button onClick={() => setLiked(!liked)}>
      {liked ? '❤️' : '🤍'}
    </button>
  );
}
```

### Passando Props

```javascript
// ✅ Correto: Passar dados serializáveis
<ClientComponent data={JSON.parse(jsonString)} />

// ❌ Errado: Passar funções ou objetos não-serializáveis
<ClientComponent onClick={serverFunction} />
```

### Técnicas

- Use Server Components por padrão, opt-in para Client Components
- Faça data fetching o mais próximo possível de onde é usado
- Coloque 'use client' o mais baixo possível na árvore
- Use Client Components para interatividade, Server Components para data/layout
- Aproveite parallel data fetching em Server Components

## Uso Conhecido

- **Next.js App Router**: Implementação completa de RSC
- **Vercel**: Infraestrutura otimizada para RSC
- **Shopify Hydrogen**: Framework para e-commerce com RSC
- **Frameworks Experimentais**: Waku, React Server Components Demo

## Diferenças de SSR

| Aspecto | SSR Tradicional | Server Components |
|---------|----------------|-------------------|
| **Entrega de Código** | Código do componente vai para cliente | Código nunca alcança cliente |
| **Padrão de Acesso** | `getServerSideProps` em nível de página | Qualquer nível via Server Components |
| **Gerenciamento de Estado** | Re-rendering perde estado | Re-fetching preserva estado |
| **Impacto em Bundle** | Todo código de componente incluído | Redução significativa possível |

Server Components não são substitutos para SSR mas tecnologias complementares usadas juntas.

## Métricas de Performance

- **Bundle Size**: Redução de 20-40% típica
- **FCP**: Melhorado com menos JavaScript para parse
- **TTI**: Significativamente melhorado
- **Data Fetching**: Mais eficiente sem waterfalls
- **Memory Usage**: Reduzido no cliente

## Padrões Relacionados

- [**Server-side Rendering**](009_server-side-rendering.md): Complementar a RSC
- [**Streaming SSR**](013_streaming-ssr.md): Combina bem com RSC
- [**Selective Hydration**](015_selective-hydration.md): Trabalha junto com RSC
- [**React Stack Patterns**](007_react-stack-patterns.md): Contexto arquitetural moderno

### Relação com Rules

- [010 - Princípio da Responsabilidade Única](../../solid/001_single-responsibility-principle.md): separar server vs. client
- [014 - Princípio de Inversão de Dependência](../../solid/005_dependency-inversion-principle.md): abstrair data sources
- [045 - Processos Stateless](../../twelve-factor/006_processos-stateless.md): Server Components stateless

## Server Actions

React 19 introduz Server Actions para mutations:

```javascript
// app/actions.js
'use server';

export async function createPost(formData) {
  const post = await db.posts.create({
    data: {
      title: formData.get('title'),
      content: formData.get('content')
    }
  });
  revalidatePath('/posts');
  return post;
}

// app/new-post.js
import { createPost } from './actions';

function NewPost() {
  return (
    <form action={createPost}>
      <input name="title" />
      <textarea name="content" />
      <button type="submit">Create</button>
    </form>
  );
}
```

## Melhores Práticas

- Usar Server Components por padrão
- Marcar componentes como 'use client' apenas quando necessário
- Fazer data fetching em Server Components próximo ao uso
- Evitar passar callbacks ou funções de Server para Client
- Aproveitar parallel data fetching
- Usar Server Actions para mutations
- Implementar loading states com Suspense
- Monitor bundle sizes para garantir benefícios
- Test comportamento com network throttling

---

**Criada em**: 2026-03-17
**Versão**: 1.0
