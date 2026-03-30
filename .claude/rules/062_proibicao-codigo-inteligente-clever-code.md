# Proibição de Código Inteligente (Clever Code)

**ID**: AP-04-062
**Severidade**: 🟡 Média
**Categoria**: Comportamental

---

## O que é

Clever Code (Código Inteligente) ocorre quando desenvolvedor escreve código excessivamente conciso, usando truques non-obvious, operadores complexos, ou padrões de código pouco convencionais para mostrar "habilidade" em vez de priorizar clareza. Código que faz o desenvolvedor se sentir smart ao escrever (e os outros se sentirem confusos ao ler).

## Por que importa

- Dificulta manutenção: outros desenvolvedores não entendem o código sem gastar muito tempo
- Esconde bugs: code complexo has more edge cases e harder to reason about
- Frustra equipe: criar cultura de "code cleverness" over code clarity
- Dificulta onboarding: novos desenvolvedores demoram muito mais para ser productivos
- Er comum em revisões de código: "isso funciona mas não consigo entender"

## Critérios Objetivos

- [ ] Comentários de code review perguntando "o que isso faz?" ou "pode ser mais claro?"
- [ ] Uso de one-liners complexos: ternary chaining, arrow functions com múltiplas operações
- [ ] Operadores bit-shifting, bitwise manipulations,或其他 advanced language features sem comentários clarifying propósito
- [ ] Regex ou parsing de strings complexos embedded no código principal
- [ ] Funções com nomes curtos não-explicativos (`fn()`, `go()`, `proc()`) doing complex logic

## Exceções Permitidas

- Cópia otimizada de algorithms conhecidos (CRC32, MD5) onde purpose é claro via nome de função
- Code golfing em funções intentionally tiny onde contexto torna meaning óbvio
- Performance-critical paths que foram profiled como hotspots onde注释 justificam optimization
- Domínio específico (crypto, graphics, systems programming) onde操作 padrão são conhecidas

## Como Detectar

### Manual
- Code review: regras explicitas para rejeitar code "clever" over code "clear"
- Procurar por one-liners com > 3 operações nas mesmas linhas
- Identificar code que desenvolvedor gasta 5 minutes para ler sem ser autor
- Verificar comentarios apontando "esta é uma otimização" sem medidas profiling

### Automático
- Linters: ESLint (no-nested-ternary, max-depth, complexity), SonarQube simplicity rules
- Auto-formatters: prettsier, black forza estilo mais readable
- Cyclomatic complexity: detectar funções com alta complexidade que podem ser escritas de forma mais simples

## Relacionada com

- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [034 - Nomes de Classes e Métodos Consistentes](034_nomes-classes-metodos-consistentes.md): reforça
- [033 - Limite de Parâmetros por Função](033_limite-parametros-funcao.md): reforça
- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [069 - Proibição de Otimização Prematura](069_proibicao-otimizacao-prematura.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0