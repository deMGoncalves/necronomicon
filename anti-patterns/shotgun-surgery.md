---
titulo: Shotgun Surgery (Cirurgia de Espingarda)
aliases:
  - Shotgun Surgery
  - Cirurgia de Espingarda
tipo: anti-pattern
id: AP-15
severidade: 🟠 Alto
origem: refactoring
tags: [anti-pattern, estrutural, acoplamento, manutencao]
criado: 2026-03-20
relacionados:
  - "[[divergent-change]]"
  - "[[cut-and-paste-programming]]"
  - "[[001_single-responsibility-principle]]"
---

# Shotgun Surgery (Cirurgia de Espingarda)

*Shotgun Surgery*

---

## Definição

Uma única mudança lógica exige alterações em muitos lugares diferentes do código simultaneamente. Cada vez que algo muda, você "atira" edições por toda a codebase como projéteis de espingarda.

## Sintomas

- Adicionar um campo exige mudar 8 arquivos diferentes
- Alterar uma regra de negócio força edições em models, controllers, services, validators e tests separados
- Review de PR: "por que mudou esse arquivo também?"
- Bug introduzido porque um dos N lugares foi esquecido

## Causas Raiz

- Lógica distribuída sem centralização (oposto do DRY)
- Corte de responsabilidades errado: divisão por tipo de arquivo em vez de por feature
- Herança mal aplicada: mudança em classe pai exige ajuste em todos os filhos

## Consequências

- Alto risco de regressão: fácil esquecer um dos lugares
- Commits grandes e difíceis de revisar
- Lentidão no desenvolvimento: uma mudança simples toma muito tempo
- Bugs sistemáticos por inconsistência entre os N lugares

## Solução / Refatoração

Aplicar **Move Method** e **Move Field** (Fowler) para centralizar a lógica dispersa. Organizar por feature em vez de por tipo técnico: `user/user.service.ts` em vez de `services/user.ts` + `models/user.ts` + `controllers/user.ts` separados sem coesão.

## Exemplo — Problemático

```javascript
// ❌ Adicionar campo "phone" exige editar todos estes arquivos:
// user.model.js      → adicionar campo
// user.validator.js  → adicionar validação
// user.dto.js        → adicionar ao DTO
// user.mapper.js     → adicionar ao mapeamento
// user.repository.js → adicionar à query
// user.test.js       → adicionar aos fixtures
```

## Exemplo — Refatorado

```javascript
// ✅ Feature coesa: schema centraliza tudo, sem N arquivos para sincronizar
const userSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  phone: z.string().regex(/^\+\d{10,15}$/), // adiciona aqui → funciona em todo o sistema
});
```

## Rules que Previnem

- [[proibicao-duplicacao-logica]] — DRY: lógica centralizada não exige shotgun surgery

## Relacionados

- [[divergent-change]] — oposto complementar: Shotgun Surgery = 1 mudança, N classes; Divergent Change = 1 classe, N razões para mudar
- [[cut-and-paste-programming]] — duplicação gera Shotgun Surgery
