# Portability — Portabilidade

**Dimensão:** Transição
**Severidade Default:** 🟡 Sugestão
**Pergunta Chave:** Pode ser executado em outro ambiente?

## O que é

O esforço necessário para transferir o software de um ambiente de hardware/software para outro. Alta portabilidade significa que a aplicação pode rodar em diferentes sistemas operacionais, navegadores ou infraestruturas cloud com mínima ou nenhuma modificação.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Path absoluto hardcoded | 🟠 Important |
| Vendor lock-in em serviço crítico | 🟠 Important |
| Comando shell sem fallback | 🟡 Suggestion |
| Line ending hardcoded | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não portável - path específico de sistema
const configPath = '/home/user/app/config.json';
const tempDir = 'C:\\Users\\Admin\\Temp';

// ✅ Portável - paths relativos ou via ambiente
const configPath = path.join(process.cwd(), 'config.json');
const tempDir = process.env.TEMP_DIR || os.tmpdir();
```

## Codetags Sugeridos

```javascript
// PORTABILITY(042): Path absoluto - usar variável de ambiente
// PORTABILITY: Comando específico de Linux - adicionar fallback
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Path absoluto hardcoded | 🟠 Important |
| Vendor lock-in em serviço crítico | 🟠 Important |
| Comando shell sem fallback | 🟡 Suggestion |
| Line ending hardcoded | 🟡 Suggestion |

## Rules Relacionadas

- 042 - Configurações via Ambiente
- 041 - Declaração Explícita de Dependências
- 024 - Proibição de Constantes Mágicas
