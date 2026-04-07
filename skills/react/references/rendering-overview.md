# Rendering Strategies Overview

Decision guide for choosing between CSR, SSR, SSG, ISR, and RSC in React (2026).

---

## Decision Matrix

| Strategy | SEO | TTI | Bundle | Infrastructure | When to Use |
|----------|-----|-----|--------|----------------|-------------|
| **CSR** | ❌ | Slow | Large | Simple | Dashboards, internal apps |
| **SSR** | ✅ | Medium | Large | Complex | Dynamic content + SEO |
| **SSG** | ✅ | Fast | Medium | Simple | Blogs, docs, marketing |
| **ISR** | ✅ | Fast | Medium | Medium | SSG + frequent updates |
| **RSC** | ✅ | Very fast | Small | Complex | Reduce bundle, server-side data fetching |

---

## Client-Side Rendering (CSR)

**How it works:** JavaScript renders everything in the browser.

**When to use:**
- Administrative dashboards
- Internal tools
- Highly interactive apps without SEO
- Controlled environments

**When NOT to use:**
- Public pages with SEO
- Content-rich sites
- Critical Time-to-Interactive

**Example (Vite + React):**
```tsx
// main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')!).render(<App />);
```

---

## Server-Side Rendering (SSR)

**How it works:** HTML rendered on server at each request.

**When to use:**
- Dynamic content + critical SEO
- User personalization
- Important initial performance

**When NOT to use:**
- Static content (use SSG)
- High server load without cache

**Example (Next.js App Router):**
```tsx
// app/page.tsx
export default async function Page() {
  const data = await fetch('https://api.example.com/data');
  return <div>{/* render data */}</div>;
}
```

---

## Static Site Generation (SSG)

**How it works:** HTML generated at build time.

**When to use:**
- Blogs, docs, marketing pages
- Content that changes rarely
- Critical SEO + maximum performance

**When NOT to use:**
- User-personalized content
- Frequently changing data (use ISR)

**Example (Next.js):**
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

**How it works:** SSG + incremental revalidation (regenerates pages in background).

**When to use:**
- Semi-static content (daily/weekly updates)
- E-commerce (product pages)
- News

**When NOT to use:**
- Real-time data (use SSR or CSR)
- Completely static content (use pure SSG)

**Example (Next.js):**
```tsx
// app/products/[id]/page.tsx
export const revalidate = 3600; // revalidate every 1 hour

export default async function ProductPage({ params }: { params: { id: string } }) {
  const product = await getProduct(params.id);
  return <div>{/* render product */}</div>;
}
```

---

## React Server Components (RSC)

**How it works:** Components render on server without sending JavaScript to client.

**When to use:**
- Drastically reduce bundle size
- Direct data fetching in component
- Server-side database/API access
- Large libraries (markdown parsers, etc.)

**When NOT to use:**
- Components with interactivity (event handlers)
- Components using React hooks
- Browser-only APIs

**Example (Next.js 13+ App Router):**
```tsx
// app/page.tsx (Server Component by default)
async function Page() {
  const data = await db.query('SELECT * FROM users'); // direct DB access
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

## Hybrid Approach (Recommended for 2026)

**Next.js 13+ App Router:** SSR + RSC + Streaming + Selective Hydration

```tsx
// app/layout.tsx (Server Component)
export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <Header /> {/* Server Component */}
        <Suspense fallback={<Loading />}>
          {children} {/* Can be Server or Client Component */}
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
      <ClientChart data={data} /> {/* Client Component with interactivity */}
    </div>
  );
}
```

---

## Decision Checklist

```
1. Need SEO?
   ├─ No → CSR
   └─ Yes → continue

2. Is content static or dynamic?
   ├─ Static → SSG or ISR
   └─ Dynamic → continue

3. Need to drastically reduce bundle?
   ├─ Yes → RSC
   └─ No → SSR

4. How often does content change?
   ├─ Rarely (< 1x/day) → SSG
   ├─ Periodically (1x/hour) → ISR
   └─ Constantly (real-time) → SSR or CSR with polling

5. Framework available?
   ├─ Next.js → use App Router (RSC + SSR + ISR)
   ├─ Remix → native SSR
   └─ Vite → CSR or manual SSR
```

---

## Performance Metrics (typical)

| Metric | CSR | SSR | SSG | ISR | RSC |
|--------|-----|-----|-----|-----|-----|
| **TTFB** | Fast | Medium | Fast | Fast | Medium |
| **FCP** | Slow | Medium | Fast | Fast | Medium |
| **TTI** | Slow | Medium | Fast | Fast | Fast |
| **Bundle** | 200KB+ | 200KB+ | 150KB | 150KB | 50KB |

---

**Source:** [patterns.dev/react](https://www.patterns.dev/react), Next.js Docs, React Docs
**Updated on**: 2026-04-01
**Version**: 1.0
