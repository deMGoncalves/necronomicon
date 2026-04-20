# Proibição de Inferno de Callbacks (Callback Hell)

**ID**: AP-05-063
**Severidade**: 🟠 Alta
**Categoria**: Comportamental

---

## O que é

Callback Hell (Inferno de Callbacks) ocorre quando código assíncrono é escrito usando aninhamentos profundos de callbacks, criando control flow difícil de seguir. Múltiplos callbacks aninhados criam arrow-shaped code com indentação progressing to the right, tornando o código quase impossível de ler e manter.

## Por que importa

- Dificulta leitura: desenvolvedores perdem track dos níveis; não sabem em que callback they are
- Erros difíceis de debug: error handling espalhado em múltiplos níveis
- Dificulta testes: testar cada callback isoladamente é impossível
- Erros comuns: esquecer de call next callback, proper error handling, ou return early
- Problema específico de languages/paradigmas sem async/await ou promises

## Critérios Objetivos

- [ ] Mais de 3 níveis de aninhamento de callbacks
- [ ] Callback functions definidos inline em vez de named functions
- [ ] Erro handling repetido em cada callback level (try/catch dentro de each callback)
- [ ] `}) })` pattern em end of file — markers de callback hell
- [ ] Variables capturadas em closures de múltiplos níveis, creating hard-to-reason-about state

## Exceções Permitidas

- Código legado onde language/runtimes não suportam promises ou async/await
- APIs externas que requiremente usam c callback pattern sem alternative
- Single-level callback nesting com lógica simples (only one async operation)

## Como Detectar

### Manual
- Visual scan: procurar por código com right-drifting indentation multi-level callbacks
- Procurar por `} })` pattern em final de funções with many callbacks
- Identificar funções passando callbacks que por sua vez passam callbacks
- Verificar stack traces when debugging: deeply nested stack frames with callback functions

### Automático
- Linters: detect callback nesting depth > threshold
- Code metrics: calculate cyclomatic complexity em função with callbacks
- Code quality tools: detect anti-patern de callback hell específico para JS/Python

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [028 - Tratamento de Exceção Assíncrona](028_tratamento-excecao-assincrona.md): reforça
- [060 - Proibição de Código Spaghetti](060_proibicao-codigo-spaghetti.md): reforça
- [027 - Qualidade de Tratamento de Erros de Domínio](027_qualidade-tratamento-erros-dominio.md): reforça
- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0