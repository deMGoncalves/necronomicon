# Shotgun Surgery (Cirurgia de Espingarda)

**Severidade:** 🟠 Alto
**Rule associada:** Rule 058

## O que é

Uma única mudança lógica exige alterações em muitos lugares diferentes do código simultaneamente. Cada vez que algo muda, você "atira" edições por toda a codebase como projéteis de espingarda. Oposto do Divergent Change: aqui, uma mudança exige N arquivos alterados.

## Sintomas

- Mudança de comportamento exige alterar 3+ classes/módulos
- Mesma lógica de cálculo ou validação existe em múltiplas localizações
- Adicionar novo campo/feature exige modificar N arquivos em diferentes camadas
- Bug fix precisa ser aplicado em múltiplos arquivos com mesmo padrão de correção
- Code review: "por que mudou esse arquivo também?"

## ❌ Exemplo (violação)

```javascript
// ❌ Adicionar campo "phone" exige editar todos estes arquivos:
// user.model.js      → adicionar campo
// user.validator.js  → adicionar validação
// user.dto.js        → adicionar ao DTO
// user.mapper.js     → adicionar ao mapeamento
// user.repository.js → adicionar à query
// user.test.js       → adicionar aos fixtures
```

## ✅ Refatoração

```javascript
// ✅ Feature coesa: schema centraliza tudo (Move Method + Move Field)
const userSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  phone: z.string().regex(/^\+\d{10,15}$/), // adiciona aqui → funciona em todo o sistema
});

// Type inference + validação + DTO + mapeamento = tudo em um lugar
type User = z.infer<typeof userSchema>;
```

## Codetag sugerida

```typescript
// FIXME: Shotgun Surgery — adicionar campo exige N arquivos: model, validator, dto, mapper, repository
// TODO: Centralizar schema com Zod/Yup para validação + types + DTOs unificados
```
