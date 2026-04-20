---
description: "Aciona @architect (modo review) para revisar branch, PR ou caminho src/ com CDD/ICP + 70 regras + segurança. Posta comentário diretamente em PRs. Uso: /audit | /audit pr <num> | /audit src/caminho | /audit <branch> [en|es|pt]"
argument-hint: "[branch | pr <número> | src/context/container/component] [en|es|pt]"
allowed-tools: Bash(git *), Bash(gh *), Read, Grep, Glob
---

## Propósito

Executa revisão completa de código usando @architect em modo review (CDD/ICP, 70 regras arquiteturais, segurança via ApplicationSecurityMCP). Aceita 4 modos:

| Argumento | O que revisa |
|-----------|--------------|
| _(sem argumento)_ | Diff da branch atual vs main |
| `src/context/container/component` | Arquivos de vertical slice específico |
| `pr <número>` | Pull Request no GitHub |
| `<nome-branch>` | Diff de branch específica vs main |

Branch atual:
!`git branch --show-current`

PR associado à branch:
!`gh pr view --json number,title,url 2>/dev/null | jq -r '"PR #\(.number): \(.title) → \(.url)"' 2>/dev/null || echo "(sem PR associado)"`

Arquivos alterados (branch atual vs main):
!`git diff main...HEAD --name-only 2>/dev/null | head -20 || echo "(nenhum diff detectado ou fora de repositório git)"`

---

## Instruções

### Passo 0 — Idioma dos Comentários

Verificar se `$ARGUMENTS` contém código de idioma explícito no final:

| Sufixo em `$ARGUMENTS` | Idioma dos Comentários |
|------------------------|------------------------|
| `en` | Inglês |
| `es` | Espanhol |
| `pt` _(ou ausente)_ | Português _(padrão)_ |

Exemplos: `/audit pr 42 es` → comentários em espanhol. `/audit feat/login` → português.

Extrair código de idioma e removê-lo de `$ARGUMENTS` antes de continuar com os passos seguintes.

---

### Passo 1 — Detectar alvo baseado em `$ARGUMENTS`

Analisar `$ARGUMENTS` (já sem sufixo de idioma):

| Condição | Modo |
|----------|------|
| Vazio | **Branch Atual** — diff vs main |
| Começa com `src/` | **Path** — vertical slice específico |
| É número ou começa com `pr ` | **PR** — Pull Request no GitHub |
| Qualquer outra string | **Branch** — diff de branch nomeada vs main |

---

### Passo 2 — Coletar contexto por modo

#### Modo Branch (atual ou nomeada)

```bash
# Branch atual
git diff main...HEAD --name-only

# Branch específica
git diff main...<branch> --name-only

# Diff completo para leitura
git diff main...HEAD
```

Listar arquivos alterados e obter diff completo para passar ao @architect.

Verificar se há arquivos `.tsx` ou `.jsx` entre os alterados — isso ativa análise de patterns React.

#### Modo Path (`src/...`)

Ler todos arquivos dentro do caminho:

```bash
find <path> -type f \( -name "*.ts" -o -name "*.tsx" \) | sort
```

Ler conteúdo de cada arquivo (controller.ts, service.ts, model.ts, repository.ts, *.test.ts) usando `Read`.

Verificar se há arquivos `.tsx` entre os lidos.

#### Modo PR (`pr <número>` ou número)

```bash
# Metadados e tipo do PR
gh pr view <número> --json number,title,body,headRefName,changedFiles,labels

# Status do CI
gh pr checks <número> 2>/dev/null || echo "(sem checks configurados)"

# Arquivos alterados
gh pr diff <número> --name-only

# Diff completo
gh pr diff <número>
```

**Detectar tipo do PR** a partir do título ou labels:

| Prefixo no título / label | Tipo | Tolerância de severidade |
|---------------------------|------|--------------------------|
| `fix:`, `bugfix`, `hotfix` | 🐛 Fix | **Alta** — correção vem primeiro |
| `feat:`, `feature` | ✨ Feature | **Média** — qualidade importa mas não trava MVP |
| `refactor:`, `refact` | ♻️ Refatoração | **Baixa** — deve melhorar qualidade |
| `docs:`, `doc` | 📝 Documentação | **Muito alta** — rigor técnico não se aplica |
| `chore:`, `ci:`, `build:` | 🔧 Infraestrutura | **Alta** — impacto limitado |
| `style:`, `ui:` | 🎨 Visual/UI | **Alta** — trade-offs de experiência |
| _(sem prefixo detectado)_ | ❓ Desconhecido | **Média** |

Verificar se há arquivos `.tsx` ou `.jsx` entre os alterados.

---

### Passo 3 — Carregar skills de análise

Antes de acionar @architect, ler os seguintes arquivos para carregar metodologias de análise:

```
.claude/skills/cdd/SKILL.md               → metodologia ICP (CC_base + nesting + responsibilities + coupling)
.claude/skills/software-quality/SKILL.md  → calibração de severidade via McCall (12 fatores de qualidade)
.claude/skills/anti-patterns/SKILL.md     → catálogo de 26 anti-patterns para identificação em diff
```

> **Por que ler explicitamente:** skills só são auto-injetadas em subagentes via Task. No padrão
> de role-switching usado por comandos, arquivos precisam ser lidos antes da análise.

---

### Passo 4 — Acionar @architect

Montar contexto completo e passar ao @architect com instruções abaixo. Adaptar instruções conforme modo e o que foi coletado.

---

> **@architect**: Realize revisão completa do código abaixo.
>
> **Idioma:** Escrever todos os comentários em **[IDIOMA DETECTADO NO PASSO 0]**.
>
> ---
>
> **Contexto de negócio:**
> - Tipo de mudança: **[TIPO DETECTADO]** — tolerância de severidade **[ALTA/MÉDIA/BAIXA]**
> - Status do CI: **[RESULTADO DE gh pr checks OU "não disponível"]**
> - Arquivos com React (.tsx/.jsx): **[SIM/NÃO]**
>
> **Como calibrar severidade:**
>
> Calibração deve considerar **impacto real de negócio**, não apenas violação técnica isolada.
>
> - Em **bug fix**, priorizar correção estar correta — violações de estilo não são bloqueantes
> - Em **feature**, equilibrar qualidade e entrega — não travar por detalhes
> - Em **refatoração**, ser mais rigoroso — objetivo declarado é melhorar qualidade
> - **Nunca usar 🔴 para limites de linhas (50 vs 51)** — reservar para bugs reais, segurança e problemas sérios de manutenibilidade (>300 linhas, lógica crítica sem teste)
> - Reconhecer evolução: se código melhorou em relação ao estado anterior, dizer isso
>
> **Como analisar:**
> - Medir complexidade cognitiva de cada método via ICP (CC + nesting + responsibilities + coupling)
> - Verificar conformidade com regras arquiteturais priorizando impacto na manutenibilidade, segurança e correção
> - Usar ApplicationSecurityMCP para detectar vulnerabilidades de segurança
> - Se arquivos React: verificar deps de `useEffect`, prop drilling, cleanup de effects, tamanho de componentes
>
> **Tom e formato dos comentários — CRÍTICO:**
>
> Você é um **colega de desenvolvimento**, não um auditor. Objetivo é ajudar desenvolvedor a crescer, não pontuar erros.
>
> **O que NUNCA fazer:**
> - Usar headers markdown (`##`, `###`) em comentários de PR
> - Criar relatórios estruturados com seções tipo "Contexto", "Problema 1:", "Pontos Positivos"
> - Transformar comentário em lista numerada de bullets formal
> - Mencionar nomes de metodologias (CDD, ICP, McCall, SOLID) no texto para desenvolvedor
> - Usar mesmo início de frase em todos os comentários
>
> **O que SEMPRE fazer:**
> - Escrever como se fosse mensagem para colega — natural, direto, amigável
> - Variar inícios: "Vi que...", "Uma coisa...", "Atenção aqui...", "Boa aí com...", "Pode funcionar mas..."
> - Explicar POR QUE do problema — não só o que está errado, mas impacto que causa
> - Mostrar caminho para melhorar com exemplo de código quando ajudar a entender
> - Reconhecer o que está bom — objetivo é crescimento, não só crítica
> - Aplicar **Teste do Slack**: antes de formatar comentário, perguntar "eu enviaria isso para colega no Slack?" — se não, reescrever
>
> **Contexto desta revisão:** você está analisando diff de PR no GitHub — **não edite arquivos locais nem insira codetags no código**. Codetags são responsabilidade de @architect em revisões locais de código. Aqui, output é exclusivamente comentários em linguagem natural postados no PR.
>
> **Nunca mencione arquivos de config internos, IDs de regras como paths ou nomes de skills.**
>
> ---
>
> Produza um **relatório final em linguagem natural** (não estruturado com headers), organizado por impacto — do mais crítico ao menos urgente — com veredito claro e encorajador ao final.

---

### Passo 5 — Relatar e ação pós-revisão

Após @architect concluir:

1. **Exibir relatório** em linguagem natural:
   - Começar pelo que está bom (se aplicável)
   - Agrupar achados por tema e impacto real, não apenas severidade
   - Para cada ponto, explicar por que importa para código, testes ou negócio
   - Terminar com veredito claro e encorajador

   **Exemplo:**
   > "Código está bem organizado e estrutura correta.
   > Encontrei um ponto de segurança que precisa atenção antes de seguir,
   > e dois pontos de qualidade que vão facilitar manutenção futura."

2. **Se modo PR**, perguntar ao usuário:

   > Quer postar comentário no PR?
   > - `sim` — postar como comentário geral
   > - `não` — manter apenas aqui

   Se `sim`, executar:

   ```bash
   gh pr review <número> --comment -b "<texto do relatório>"
   ```

**Importante:** Nunca postar revisão em PR sem confirmação explícita do usuário.
