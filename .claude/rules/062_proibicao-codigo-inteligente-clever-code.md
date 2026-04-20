# Proibição de Código Inteligente (Clever Code)

**ID**: AP-04-062
**Severidade**: 🟡 Média
**Categoria**: Comportamental

---

## O que é

Clever Code ocorre quando um desenvolvedor escreve código excessivamente conciso, usando truques não-óbvios, operadores complexos ou padrões de código não convencionais para mostrar "habilidade" em vez de priorizar clareza. Código que faz o desenvolvedor se sentir inteligente ao escrever (e outros se sentirem confusos ao ler).

## Por que importa

- Dificuldade de manutenção: outros desenvolvedores não entendem o código sem gastar muito tempo
- Esconde bugs: código complexo tem mais casos extremos e é mais difícil raciocinar sobre
- Frustra time: cria cultura de "esperteza de código" sobre clareza de código
- Dificuldade de onboarding: novos desenvolvedores levam muito mais tempo para serem produtivos
- Comum em code reviews: "isso funciona mas não consigo entender"

## Critérios Objetivos

- [ ] Comentários de code review perguntando "o que isso faz?" ou "pode ser mais claro?"
- [ ] Uso de one-liners complexos: encadeamento de ternários, arrow functions com múltiplas operações
- [ ] Operadores de bit-shifting, manipulações bitwise ou outros recursos avançados da linguagem sem comentários explicativos
- [ ] Regex complexo ou parsing de string embutido no código principal
- [ ] Funções com nomes curtos não-explicativos (`fn()`, `go()`, `proc()`) fazendo lógica complexa

## Exceções Permitidas

- Cópia otimizada de algoritmos conhecidos (CRC32, MD5) onde propósito é claro via nome da função
- Code golfing em funções intencionalmente minúsculas onde contexto torna significado óbvio
- Caminhos críticos de performance que foram perfilados como hotspots onde comentários justificam otimização
- Domínio específico (cripto, gráficos, programação de sistemas) onde operações padrão são conhecidas

## Como Detectar

### Manual
- Code review: regras explícitas para rejeitar código "esperto" sobre código "claro"
- Buscar one-liners com > 3 operações nas mesmas linhas
- Identificar código que desenvolvedor gasta 5 minutos lendo sem ser o autor
- Verificar comentários apontando "isso é uma otimização" sem medições de profiling

### Automático
- Linters: ESLint (no-nested-ternary, max-depth, complexity), regras de simplicidade do SonarQube
- Auto-formatters: prettier, black forçam estilo mais legível
- Complexidade ciclomática: detectar funções com alta complexidade que podem ser escritas mais simplesmente

## Relacionada com

- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [034 - Nomes de Classes e Métodos Consistentes](034_nomes-classes-metodos-consistentes.md): reforça
- [033 - Limite Máximo de Parâmetros por Função](033_limite-parametros-funcao.md): reforça
- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [069 - Proibição de Otimização Prematura](069_proibicao-otimizacao-prematura.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
