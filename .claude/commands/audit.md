---
description: "Aciona @reviewer para revisar branch, PR ou caminho src/ com CDD/ICP + 70 rules + segurança. Posta comentários diretamente em PRs. Use: /audit | /audit pr <num> | /audit src/path | /audit <branch>"
argument-hint: "[branch | pr <número> | src/context/container/component]"
allowed-tools: Bash(git *), Bash(gh *), Read, Grep, Glob
---

## Propósito

Executa um code review completo usando o @reviewer (CDD/ICP, 70 regras arquiteturais, segurança via ApplicationSecurityMCP). Aceita 4 modos:

| Argumento | O que revisa |
|-----------|-------------|
| _(sem argumento)_ | Diff da branch atual vs main |
| `src/context/container/component` | Arquivos de um vertical slice específico |
| `pr <número>` | Pull Request no GitHub |
| `<nome-da-branch>` | Diff de uma branch específica vs main |

Branch atual:
!`git branch --show-current`

PR associada à branch:
!`gh pr view --json number,title,url 2>/dev/null | jq -r '"PR #\(.number): \(.title) → \(.url)"' 2>/dev/null || echo "(sem PR associada)"`

Arquivos alterados (branch atual vs main):
!`git diff main...HEAD --name-only 2>/dev/null | head -20 || echo "(sem diff detectado ou fora de um repositório git)"`

---

## Instruções

### Passo 1 — Detectar o alvo com base em `$ARGUMENTS`

Analise `$ARGUMENTS`:

| Condição | Modo |
|----------|------|
| Vazio | **Branch atual** — diff vs main |
| Começa com `src/` | **Path** — vertical slice específico |
| É um número ou começa com `pr ` | **PR** — Pull Request do GitHub |
| Qualquer outra string | **Branch** — diff da branch nomeada vs main |

---

### Passo 2 — Coletar contexto conforme o modo

#### Modo Branch (atual ou nomeada)

```bash
# Branch atual
git diff main...HEAD --name-only

# Branch específica
git diff main...$ARGUMENTS --name-only

# Diff completo para leitura
git diff main...HEAD
```

Liste os arquivos alterados e obtenha o diff completo para passar ao @reviewer.

#### Modo Path (`src/...`)

Leia todos os arquivos dentro do path:

```bash
# Listar arquivos
find $ARGUMENTS -type f -name "*.ts" | sort
```

Leia o conteúdo de cada arquivo (controller.ts, service.ts, model.ts, repository.ts, *.test.ts) usando a ferramenta `Read`.

#### Modo PR (`pr <número>` ou número)

```bash
# Info da PR
gh pr view <número> --json number,title,body,headRefName,changedFiles

# Diff completo da PR
gh pr diff <número>

# Arquivos alterados
gh pr diff <número> --name-only
```

---

### Passo 3 — Acionar @reviewer

Passe o contexto coletado ao @reviewer com as seguintes instruções:

> **@reviewer**: Realize um code review completo do código abaixo.
>
> **Como analisar:**
> - Meça a complexidade cognitiva de cada método (CC, aninhamento, responsabilidades, acoplamento)
> - Verifique conformidade com boas práticas de engenharia de software
> - Use ApplicationSecurityMCP para detectar vulnerabilidades de segurança
> - Calibre a severidade considerando o impacto real no código, testes e segurança
>
> **Como comunicar:**
> - Escreva em português, com tom de parceiro de desenvolvimento — não de auditor
> - Para cada codetag, explique o PORQUÊ do problema, o impacto que causa e o caminho para melhorar
> - Codetags podem ser multi-linha quando o contexto pede mais explicação
> - **Nunca mencione arquivos de configuração internos, IDs de regras como caminhos ou nomes de skills**
> - Reconheça o que está bem quando relevante — o objetivo é crescimento, não só crítica
>
> Produza um relatório final em linguagem natural, organizado por severidade (🔴 → 🟠 → 🟡), com um veredito claro ao final.

---

### Passo 4 — Relatório e ação pós-review

Após o @reviewer concluir:

1. **Exiba o relatório** em linguagem natural:
   - Comece reconhecendo o que está bem (se aplicável)
   - Agrupe findings por tema/impacto, não apenas por severidade
   - Para cada ponto, explique o impacto real — por que importa para o código, testes ou segurança
   - Termine com um veredito claro e encorajador

   **Exemplo de estrutura:**
   > "O código está bem organizado e a estrutura vertical slice está correta.
   > Encontrei um ponto de segurança que precisa atenção antes de seguir,
   > e dois pontos de qualidade que vão facilitar a manutenção futura."

2. **Se for modo PR**, pergunte ao usuário:

   > Deseja postar o review na PR? Escolha:
   > - `comment` — postar como comentário geral
   > - `request-changes` — solicitar alterações
   > - `approve` — aprovar a PR
   > - `skip` — não postar

   O texto postado na PR deve seguir o mesmo tom educativo — como um colega revisando, não um sistema de auditoria. Se for `request-changes`, seja claro sobre o que precisa mudar e por quê, nunca apenas "não aprovado".

   Então execute:

   ```bash
   # Postar como comentário geral
   gh pr review <número> --comment -b "<texto do relatório>"

   # Solicitar alterações
   gh pr review <número> --request-changes -b "<texto do relatório>"

   # Aprovar
   gh pr review <número> --approve -b "<texto do relatório>"
   ```

**Importante:** Nunca poste o review na PR sem confirmação explícita do usuário.
