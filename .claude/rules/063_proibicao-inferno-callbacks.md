# Proibição do Inferno de Callbacks

**ID**: AP-05-063
**Severidade**: 🟠 Alta
**Categoria**: Comportamental

---

## O que é

Callback Hell ocorre quando código assíncrono é escrito usando aninhamento profundo de callbacks, criando fluxo de controle difícil de seguir. Múltiplos callbacks aninhados criam código em forma de seta com indentação progredindo para a direita, tornando o código quase impossível de ler e manter.

## Por que importa

- Dificuldade de leitura: desenvolvedores perdem o rastro dos níveis; não sabem em qual callback estão
- Difícil debugar erros: tratamento de erros espalhado por múltiplos níveis
- Dificuldade de teste: testar cada callback isoladamente é impossível
- Erros comuns: esquecer de chamar próximo callback, tratamento de erro adequado ou retorno antecipado
- Problema específico de linguagens/paradigmas sem async/await ou promises

## Critérios Objetivos

- [ ] Mais de 3 níveis de aninhamento de callbacks
- [ ] Funções de callback definidas inline em vez de funções nomeadas
- [ ] Tratamento de erro repetido em cada nível de callback (try/catch dentro de cada callback)
- [ ] Padrão de `}) })` no final do arquivo — marcadores de callback hell
- [ ] Variáveis capturadas em closures de múltiplos níveis, criando estado difícil de raciocinar

## Exceções Permitidas

- Código legado onde linguagem/runtimes não suportam promises ou async/await
- APIs externas que exigem estritamente padrão de callback sem alternativa
- Aninhamento de callback de nível único com lógica simples (apenas uma operação assíncrona)

## Como Detectar

### Manual
- Varredura visual: procurar código com indentação derivando para direita em callbacks multi-nível
- Buscar padrão de `} })` no final de funções com muitos callbacks
- Identificar funções passando callbacks que por sua vez passam callbacks
- Verificar stack traces ao debugar: stack frames profundamente aninhados com funções de callback

### Automático
- Linters: detectar profundidade de aninhamento de callbacks > threshold
- Métricas de código: calcular complexidade ciclomática em função com callbacks
- Ferramentas de qualidade de código: detectar anti-pattern callback hell específico de JS/Python

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [028 - Tratamento de Exceção Assíncrona](028_tratamento-excecao-assincrona.md): reforça
- [060 - Proibição de Código Spaghetti](060_proibicao-codigo-spaghetti.md): reforça
- [027 - Qualidade de Tratamento de Erros de Domínio](027_qualidade-tratamento-erros-dominio.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
