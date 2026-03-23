---
titulo: Proibição de Funções Inseguras (eval, new Function, Secrets)
aliases:
  - No eval
  - Hardcoded Secrets
tipo: rule
id: CC-10
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - comportamental
  - seguranca
resolver: Antes do commit
relacionados:
  - "[[proibicao-constantes-magicas]]"
  - "[[003_configuracoes-via-ambiente]]"
criado: 2025-10-08
---

# Proibição de Funções Inseguras (eval, new Function, Secrets)

*No eval / Unsafe Functions*


---

## Definição

Proíbe o uso de funções que executam código arbitrário a partir de strings (ex.: `eval()`) ou que criam vulnerabilidades graves de segurança, como o *hardcoding* de segredos.

## Motivação

Funções como `eval()` são vetores de ataque para **Remote Code Execution (RCE)** e injeção de código. O *hardcoding* de segredos viola a política de segurança, tornando o *deployment* inseguro.

## Quando Aplicar

- [ ] É proibido o uso de `eval()` e `new Function()` (sem a finalidade de compilação isolada).
- [ ] Chaves de API ou segredos devem ser injetados exclusivamente via `process.env` ou ferramenta de gerenciamento de segredos.
- [ ] É proibida a concatenação de *strings* de entrada do usuário em consultas diretas ao sistema de arquivos ou comandos *shell*.

## Quando NÃO Aplicar

- **Tooling/Etapas de Build**: Uso controlado de *eval* ou *new Function* em *build scripts* para otimizar o *bundling*.

## Violação — Exemplo

```javascript
// ❌ eval executa qualquer string como código — vetor de RCE
function calculate(expression) {
  return eval(expression); // se expression vier do usuário: DESASTRE
}

// ❌ segredo hardcoded no código-fonte
const client = new ApiClient({ apiKey: 'sk-prod-abc123xyz' });
```

## Conformidade — Exemplo

```javascript
// ✅ Alternativa segura sem eval
function calculate(a, operator, b) {
  const ops = { '+': (x, y) => x + y, '-': (x, y) => x - y };
  return ops[operator]?.(a, b) ?? null;
}

// ✅ Segredos via variáveis de ambiente
const client = new ApiClient({ apiKey: process.env.API_KEY });
```

## Anti-Patterns Relacionados

- **Code Injection** — executar input do usuário como código
- **Hardcoded Credentials** — segredos embutidos no código-fonte ou versionados

## Como Detectar

### Manual

Buscar `eval`, `new Function`, ou chaves de API *hardcoded*.

### Automático

Biome: [`noEval`](https://biomejs.dev/linter/rules/no-eval/) e [`noGlobalEval`](https://biomejs.dev/linter/rules/no-global-eval/).

## Relação com ICP

Impacta **[[componente-acoplamento|Acoplamento]]**: `eval` cria dependência dinâmica e imprevisível com qualquer código que possa ser passado como string, tornando o acoplamento impossível de analisar estaticamente.

## Relacionados

- [[proibicao-constantes-magicas]] — complementa
- [[003_configuracoes-via-ambiente|Configurações via Ambiente]] — reforça
