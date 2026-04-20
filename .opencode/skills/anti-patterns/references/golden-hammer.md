# Golden Hammer (Solução Universal)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 068

## O que é

Usar uma tecnologia, ferramenta ou padrão familiar para resolver todos os problemas, independente de ser a solução mais adequada. "Se a única ferramenta que você tem é um martelo, tudo parece prego." — Abraham Maslow.

## Sintomas

- Mesma ferramenta/pattern aplicado em 3+ contextos significantemente diferentes
- O mesmo banco de dados, framework ou padrão é aplicado em contextos muito diferentes
- Decisões técnicas baseadas em familiaridade, não em adequação ao problema
- Resistência a avaliar alternativas: "já usamos X em tudo, vamos usar aqui também"
- Uso de microservice pattern em sistemas onde single monolith seria suficiente
- Uso de NoSQL database em sistemas fortemente relacional ou vice versa
- Soluções overpowered para problemas simples (ex: Kafka para 10 mensagens/dia)

## ❌ Exemplo (violação)

```javascript
// ❌ Usando Redis (cache distribuído) para armazenar config que muda 1x por semana
const config = await redis.get('app:config');
// Solução overpowered: um arquivo JSON ou variável de ambiente resolveriam

// ❌ Usando GraphQL para uma API com 2 endpoints simples
// porque "usamos GraphQL em tudo"
```

## ✅ Refatoração

```javascript
// ✅ Solução proporcional ao problema (KISS + Right Tool for the Job)
import config from './config.json'; // ou process.env.CONFIG

// ✅ REST simples para API simples
app.get('/users/:id', getUserHandler);
app.post('/users', createUserHandler);
```

## Codetag sugerida

```typescript
// FIXME: Golden Hammer — Redis para config estática (overkill)
// TODO: Usar config.json ou env vars; reservar Redis para cache real
```
