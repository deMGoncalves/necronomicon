# Estrutura de Código (Rules 021, 022, 023, 024, 026)

## Regras

- **021**: DRY — sem duplicação de lógica
- **022**: KISS — Complexidade Ciclomática ≤5
- **023**: YAGNI — sem funcionalidade especulativa
- **024**: Sem constantes mágicas
- **026**: Comentários explicam PORQUÊ, não O QUÊ

## Checklist

- [ ] Sem copy-paste de blocos >5 linhas
- [ ] Lógica usada >2x → extrair para função reutilizável
- [ ] CC de cada método ≤5
- [ ] Sem classes/métodos vazios "para o futuro"
- [ ] Sem parâmetros não usados
- [ ] Valores numéricos (exceto 0/1) em constantes nomeadas
- [ ] Strings de domínio em Enums ou constantes
- [ ] Comentários justificam decisões não-óbvias

## Exemplos

```typescript
// ❌ Violações
// Duplicação (021)
function validateEmailInService(email) {
  if (!email || !email.includes('@')) throw new Error('Invalid');
}
function validateEmailInController(email) {
  if (!email || !email.includes('@')) throw new Error('Invalid'); // duplicado!
}

// Constante mágica (024)
if (user.age >= 18 && user.score > 100) { } // 18 e 100 são mágicas

// YAGNI (023)
class UserService {
  exportToCsv() { /* TODO: implementar depois */ } // especulativo
}

// Comentário redundante (026)
function getUser(id) {
  // busca o usuário pelo id
  return db.find(id); // óbvio!
}

// ✅ Conformidade
// DRY
function validateEmail(email: string) {
  if (!email || !email.includes('@')) throw new EmailInvalidError();
}

// Sem constantes mágicas
const LEGAL_AGE = 18;
const MIN_PREMIUM_SCORE = 100;
if (user.age >= LEGAL_AGE && user.score > MIN_PREMIUM_SCORE) { }

// Comentário útil (PORQUÊ)
function getUser(id: string) {
  // Busca por ID string por compatibilidade com API legada v1
  return db.find(String(id));
}
```

## Relação com ICP

- DRY reduz Responsabilidades (lógica em um lugar)
- KISS mantém CC_base baixo
- Constantes nomeadas são autodocumentadas (menos carga cognitiva)
