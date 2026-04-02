# Nomenclatura (Rules 006, 034, 035)

## Regras

- **006**: Sem nomes abreviados ou acrônimos ambíguos
- **034**: Classes = substantivos, Métodos = verbos
- **035**: Sem nomes enganosos ou notação húngara

## Checklist

- [ ] Nomes ≥3 caracteres (exceto `i`, `j` em loops)
- [ ] Sem acrônimos (`Mngr` → `Manager`)
- [ ] Classes em PascalCase, substantivos singulares
- [ ] Métodos em camelCase, verbos
- [ ] Booleanos com prefixos `is`, `has`, `can`
- [ ] Coleções nomeadas conforme estrutura real (Set, Map, Array)
- [ ] Sem prefixos de tipo (`strName` → `name`)

## Exemplos

```typescript
// ❌ Violações
class UserMgr { } // acrônimo ambíguo
function usr(id) { } // abreviado + substantivo como método
const strName = 'Alice'; // notação húngara
const accountList = new Set(); // nome enganoso (Set não é List)

// ✅ Conformidade
class UserManager { }
function getUser(id) { } // verbo + substantivo
const userName = 'Alice';
const accountSet = new Set();
const isActive = true;
const hasPermission = user.roles.includes('admin');
```

## Relação com ICP

Nomes claros reduzem custo cognitivo — o leitor entende a intenção sem precisar ler implementação.
