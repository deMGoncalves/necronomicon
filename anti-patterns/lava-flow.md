---
titulo: Lava Flow (Código Morto)
aliases:
  - Lava Flow
  - Dead Code
  - Zombie Code
tipo: anti-pattern
id: AP-02
severidade: 🟠 Alto
origem: antipatterns-book
tags: [anti-pattern, estrutural, complexidade, manutencao]
criado: 2026-03-20
relacionados:
  - "[[the-blob]]"
  - "[[regra-escoteiro-refatoracao-continua]]"
---

# Lava Flow (Código Morto)

*Lava Flow / Dead Code / Zombie Code*

---

## Definição

Código que não é mais usado mas permanece no sistema porque ninguém tem certeza se pode ser removido com segurança. Como lava que solidifica e endurece, esse código vira obstáculo permanente à manutenção.

## Sintomas

- Funções, classes ou módulos nunca chamados
- Código comentado que ninguém remove (`// old version`, `// deprecated`)
- Variáveis declaradas e nunca lidas
- Branches de `if` que nunca são executados
- Importações de módulos não utilizados
- Arquivos que ninguém sabe para que servem

## Causas Raiz

- Refatorações incompletas: código antigo mantido "por precaução"
- Falta de cobertura de testes: sem testes, ninguém ousa remover
- Ausência de ownership: ninguém se sente responsável por limpar
- Pressão de prazo: "deixa que já funciona"

## Consequências

- Carga cognitiva extra: desenvolvedor precisa entender código inútil
- Dívida técnica crescente: o sistema fica maior e mais lento de navegar
- Falsa sensação de complexidade: parecer que o sistema faz mais do que faz
- Bugs preservados: código morto pode ser acidentalmente reativado

## Solução / Refatoração

Remover código morto sem hesitação — o controle de versão guarda o histórico. Usar ferramentas de análise estática para detectar código não referenciado. Aplicar a **Regra do Escoteiro**: sempre deixar o código mais limpo do que encontrou.

## Exemplo — Problemático

```javascript
// ❌ Funções que ninguém chama, código comentado acumulado
function calculateOldDiscount(price) { // deprecated - use calculateDiscount
  return price * 0.1;
}

// function formatUserV1(user) {
//   return user.name + ' (' + user.email + ')';
// }

function getUser(id) {
  // const cache = loadCache(); // removido em 2023 mas mantido por segurança
  return db.find(id);
}
```

## Exemplo — Refatorado

```javascript
// ✅ Apenas o que é usado existe no código
function getUser(id) {
  return db.find(id);
}
```

## Rules que Previnem

- [[regra-escoteiro-refatoracao-continua]] — exige limpeza contínua
- [[proibicao-duplicacao-logica]] — código duplicado vira lava flow quando uma versão é abandonada

## Relacionados

- [[the-blob]] — Blobs acumulam lava flow internamente
- [[boat-anchor]] — variante: componente inútil mantido por precaução
