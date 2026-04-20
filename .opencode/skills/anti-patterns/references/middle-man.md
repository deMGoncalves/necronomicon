# Middle Man (Intermediário Inútil)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 061

## O que é

Classe que delega a maior parte de seus métodos para outra classe, sem adicionar valor próprio. Se 50%+ dos métodos de uma classe apenas repassam chamadas (`return this.obj.method(args)`) para outro objeto, ela é um Middle Man inútil. Inverso do Feature Envy.

## Sintomas

- 50%+ dos métodos da classe são one-line delegates sem adicionar valor
- Classe existe apenas para esconder outro objeto inicialmente exposto diretamente
- Sempre que adiciona um método ao objeto real, adiciona same wrapper ao Middle Man
- Stack trace sempre mostra same method names em duas camadas consecutivas
- Middle Man não é usado/testado isoladamente — sempre precisa do objeto real funcionando

## ❌ Exemplo (violação)

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

## ✅ Refatoração

```javascript
// ✅ Usar Department diretamente — Manager não agrega valor (Remove Middle Man)
const employees = department.getEmployees();

// Se Manager tiver lógica própria além de delegar, aí faz sentido existir:
class Manager {
  approve(request) {
    // lógica real de aprovação — adiciona valor
    if (request.amount > this.approvalLimit) throw new Error('Acima do limite');
    return this.department.processRequest(request);
  }
}
```

## Codetag sugerida

```typescript
// FIXME: Middle Man — Manager apenas delega 5/6 métodos para Department
// TODO: Remove Middle Man — expor Department diretamente ou adicionar lógica real a Manager
```
