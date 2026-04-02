# Rendering Strategies Overview

Guia de decisão para escolher entre CSR, SSR, SSG, ISR e RSC no React (2026).

---

## Decision Matrix

| Strategy | SEO | TTI | Bundle | Infraestrutura | Quando Usar |
|----------|-----|-----|--------|----------------|-------------|
| **CSR** | ❌ | Lento | Grande | Simples | Dashboards, apps internos |
| **SSR** | ✅ | Médio | Grande | Complexa | Conteúdo dinâmico + SEO |
| **SSG** | ✅ | Rápido | Médio | Simples | Blogs, docs, marketing |
| **ISR** | ✅ | Rápido | Médio | Médio | SSG + atualizações frequentes |
| **RSC** | ✅ | Muito rápido | Pequeno | Complexa | Reduzir bundle, data fetching server-side |

---

## Client-Side Rendering (CSR)

**Como funciona:** JavaScript renderiza tudo no navegador.

**Quando usar:**
- Dashboards administrativos
- Tools internos
- Apps altamente interativos sem SEO
- Ambientes controlados

**Quando NÃO usar:**
- Páginas públicas com SEO
- Sites content-rich
- Time-to-Interactive crítico

**Exemplo (Vite + React):**
```tsx
// main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')!).render(<App />);
```

---

## Server-Side Rendering (SSR)

**Como funciona:** HTML renderizado no servidor a cada request.

**Quando usar:**
- Conteúdo dinâmico + SEO crítico
- Personalização por usuário
- Performance inicial importante

**Quando NÃO usar:**
- Conteúdo estático (usar SSG)
- Carga alta no servidor sem cache

**Exemplo (Next.js App Router):**
```tsx
// app/page.tsx
export default async function Page() {
  const data = await fetch('https://api.example.com/data');
  return <div>{/* render data */}</div>;
}
```

---

## Static Site Generation (SSG)

**Como funciona:** HTML gerado em build time.

**Quando usar:**
- Blogs, docs, marketing pages
- Conteúdo que muda raramente
- SEO crítico + performance máxima

**Quando NÃO usar:**
- Conteúdo dinâmico por usuário
- Dados que mudam frequentemente (usar ISR)

**Exemplo (Next.js):**
```tsx
// app/blog/[slug]/page.tsx
export async function generateStaticParams() {
  const posts = await getPosts();
  return posts.map(post => ({ slug: post.slug }));
}

export default function BlogPost({ params }: { params: { slug: string } }) {
  return <article>{/* render post */}</article>;
}
```

---

## Incremental Static Regeneration (ISR)

**Como funciona:** SSG + revalidação incremental (regenera páginas em background).

**Quando usar:**
- Conteúdo semi-estático (updates diários/semanais)
- E-commerce (product pages)
- Notícias

**Quando NÃO usar:**
- Real-time data (usar SSR ou CSR)
- Conteúdo completamente estático (usar SSG puro)

**Exemplo (Next.js):**
```tsx
// app/products/[id]/page.tsx
export const revalidate = 3600; // revalidar a cada 1 hora

export default async function ProductPage({ params }: { params: { id: string } }) {
  const product = await getProduct(params.id);
  return <div>{/* render product */}</div>;
}
```

---

## React Server Components (RSC)

**Como funciona:** Componentes renderizam no servidor sem enviar JavaScript ao cliente.

**Quando usar:**
- Reduzir bundle size drasticamente
- Data fetching direto no componente
- Acesso a databases/APIs server-side
- Bibliotecas grandes (markdown parsers, etc.)

**Quando NÃO usar:**
- Componentes com interatividade (event handlers)
- Componentes usando React hooks
- Browser-only APIs

**Exemplo (Next.js 13+ App Router):**
```tsx
// app/page.tsx (Server Component por padrão)
async function Page() {
  const data = await db.query('SELECT * FROM users'); // acesso direto a DB
  return (
    <div>
      {data.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
      <LikeButton /> {/* Client Component */}
    </div>
  );
}

// components/LikeButton.tsx (Client Component)
'use client';
import { useState } from 'react';

export function LikeButton() {
  const [liked, setLiked] = useState(false);
  return <button onClick={() => setLiked(!liked)}>Like</button>;
}
```

---

## Hybrid Approach (Recomendado para 2026)

**Next.js 13+ App Router:** SSR + RSC + Streaming + Selective Hydration

```tsx
// app/layout.tsx (Server Component)
export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <Header /> {/* Server Component */}
        <Suspense fallback={<Loading />}>
          {children} {/* Pode ser Server ou Client Component */}
        </Suspense>
        <Footer /> {/* Server Component */}
      </body>
    </html>
  );
}

// app/dashboard/page.tsx (Server Component)
import { ClientChart } from './ClientChart';

export default async function Dashboard() {
  const data = await fetchDashboardData(); // server-side

  return (
    <div>
      <h1>Dashboard</h1>
      <ServerStats data={data} /> {/* Server Component */}
      <ClientChart data={data} /> {/* Client Component com interatividade */}
    </div>
  );
}
```

---

## Checklist de Decisão

```
1. Precisa de SEO?
   ├─ Não → CSR
   └─ Sim → continuar

2. Conteúdo é estático ou dinâmico?
   ├─ Estático → SSG ou ISR
   └─ Dinâmico → continuar

3. Precisa reduzir bundle drasticamente?
   ├─ Sim → RSC
   └─ Não → SSR

4. Conteúdo muda com que frequência?
   ├─ Raramente (< 1x/dia) → SSG
   ├─ Periodicamente (1x/hora) → ISR
   └─ Constantemente (real-time) → SSR ou CSR com polling

5. Framework disponível?
   ├─ Next.js → usar App Router (RSC + SSR + ISR)
   ├─ Remix → SSR nativo
   └─ Vite → CSR ou SSR manual
```

---

## Performance Metrics (típicas)

| Metric | CSR | SSR | SSG | ISR | RSC |
|--------|-----|-----|-----|-----|-----|
| **TTFB** | Rápido | Médio | Rápido | Rápido | Médio |
| **FCP** | Lento | Médio | Rápido | Rápido | Médio |
| **TTI** | Lento | Médio | Rápido | Rápido | Rápido |
| **Bundle** | 200KB+ | 200KB+ | 150KB | 150KB | 50KB |

---

**Fonte:** [patterns.dev/react](https://www.patterns.dev/react), Next.js Docs, React Docs
**Atualizada em**: 2026-04-01
**Versão**: 1.0
