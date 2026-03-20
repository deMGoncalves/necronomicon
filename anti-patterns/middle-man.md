---
titulo: Middle Man (Intermediário Inútil)
aliases:
  - Middle Man
  - Intermediário Inútil
tipo: anti-pattern
id: AP-19
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, acoplamento, complexidade]
criado: 2026-03-20
relacionados:
  - "[[poltergeists]]"
  - "[[feature-envy]]"
  - "[[priorizacao-simplicidade-clareza]]"
---

# Middle Man (Intermediário Inútil)

*Middle Man*

---

## Definição

Classe que delega a maior parte de seus métodos para outra classe, sem adicionar valor próprio. Se metade ou mais dos métodos de uma classe apenas repassam chamadas para um objeto interno, ela é um Middle Man.

## Sintomas

- Classe com 10 métodos onde 8 são uma linha: `return this.realObject.method(args)`
- Cada vez que você adiciona método ao objeto real, adiciona o mesmo wrapper ao Middle Man
- Difícil de saber qual classe tem a lógica real sem navegar por camadas

## Causas Raiz

- Encapsulamento mal aplicado: esconder o objeto real por princípio, sem necessidade
- Refatoração incompleta: classe que já teve responsabilidades, perdeu-as para outra, mas ficou
- Aplicação mecânica de padrões como Facade ou Proxy onde não há valor

## Consequências

- Complexidade sem benefício: mais arquivos, mais imports, mais nomes
- Manutenção duplicada: cada mudança na interface real exige mudança no Middle Man
- Debugging mais lento: stack trace com camadas desnecessárias

## Solução / Refatoração

Aplicar **Remove Middle Man** (Fowler): expor o objeto real diretamente. Se o Middle Man adiciona algum valor (transformação, cache, controle de acesso), ele tem razão de existir — mas se só delega, remova.

## Exemplo — Problemático

```javascript
// ❌ Manager que só repassa tudo para Department
class Manager {
  constructor(department) { this.department = department; }
  getEmployees() { return this.department.getEmployees(); }
  addEmployee(e) { return this.department.addEmployee(e); }
  removeEmployee(e) { return this.department.removeEmployee(e); }
  getBudget() { return this.department.getBudget(); }
}
```

## Exemplo — Refatorado

```javascript
// ✅ Usar Department diretamente — Manager não agrega valor
const employees = department.getEmployees();

// Se Manager tiver lógica própria além de delegar, aí faz sentido existir
class Manager {
  approve(request) { /* lógica real de aprovação */ }
}
```

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — KISS: não adicione camadas sem propósito

## Relacionados

- [[poltergeists]] — Poltergeists são Middle Men de vida curta
- [[feature-envy]] — oposto: Feature Envy faz o trabalho dos outros; Middle Man repassa o próprio trabalho
