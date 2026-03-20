---
titulo: Proibição de Duplicação de Lógica (Princípio DRY)
aliases:
  - DRY — Don't Repeat Yourself
  - Don't Repeat Yourself
tipo: rule
id: CC-01
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - estrutural
  - dry
resolver: Antes do commit
relacionados:
  - "[[001_single-responsibility-principle]]"
  - "[[007_maximum-lines-per-class]]"
  - "[[priorizacao-simplicidade-clareza]]"
  - "[[001_single-codebase]]"
criado: 2025-10-08
---

# Proibição de Duplicação de Lógica (Princípio DRY)

*DRY — Don't Repeat Yourself*


---

## Definição

Requer que cada trecho de conhecimento tenha uma representação única, inequívoca e autoritativa dentro do sistema. Proíbe a duplicação de lógica ou código funcionalmente idêntico.

## Motivação

A duplicação gera dívida técnica severa, pois uma alteração exige modificar N outros trechos duplicados, aumentando exponencialmente o risco de bugs de regressão e o custo de manutenção.

## Quando Aplicar

- [ ] É proibida a cópia direta de blocos de código com mais de **5** linhas entre classes ou métodos.
- [ ] Lógica complexa utilizada em mais de **2** locais deve ser extraída para uma função ou classe reutilizável.
- [ ] A reutilização deve ser feita via abstração (função, classe, interface) e não via *copy-paste*.

## Quando NÃO Aplicar

- **Configurações de Baixo Nível**: Pequenas repetições em arquivos de configuração ou DTOs puramente estruturais.
- **Testes Unitários**: Configuração de *fixtures* ou *setups* para cenários de teste específicos.

## Violação — Exemplo

```javascript
// ❌ Mesma validação duplicada em dois serviços diferentes
class OrderService {
  createOrder(email) {
    if (!email || !email.includes('@')) throw new Error('Email inválido');
    // ...
  }
}

class UserService {
  registerUser(email) {
    if (!email || !email.includes('@')) throw new Error('Email inválido'); // duplicado
    // ...
  }
}
```

## Conformidade — Exemplo

```javascript
// ✅ Lógica extraída para uma fonte única e autoritativa
function validateEmail(email) {
  if (!email || !email.includes('@')) throw new Error('Email inválido');
}

class OrderService {
  createOrder(email) { validateEmail(email); /* ... */ }
}

class UserService {
  registerUser(email) { validateEmail(email); /* ... */ }
}
```

## Anti-Patterns Relacionados

- [[cut-and-paste-programming|Copy-Paste Programming]] — duplicar código em vez de extrair abstrações

## Como Detectar

### Manual

Buscar trechos de código que parecem idênticos, mas possuem pequenas variações (duplicação sutil).

### Automático

SonarQube/ESLint: `no-duplicated-code` (com análise semântica).

## Relação com ICP

Reduz **Responsabilidades** (extrair lógica duplicada clarifica responsabilidades de cada módulo) e **Acoplamento** (módulos passam a depender de uma fonte única em vez de implementar a mesma lógica independentemente).

## Relacionados

- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[007_maximum-lines-per-class|Limite Máximo de Linhas por Classe]] — reforça
- [[priorizacao-simplicidade-clareza]] — complementa
- [[001_single-codebase|Base de Código Única]] — complementa
