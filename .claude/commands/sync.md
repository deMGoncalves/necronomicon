---
description: "Atualiza a branch atual com as últimas alterações do repositório remoto. Funciona em qualquer branch — main ou feature."
allowed-tools: Bash(git branch *), Bash(git fetch *), Bash(git pull *), Bash(git checkout *), Bash(git merge *), Bash(git status)
---

## Propósito

Sincroniza a branch local com o remoto, gerenciando corretamente branches de feature e main.

Branch atual:
!`git branch --show-current`

Status atual:
!`git status --short`

## Instruções

1. Salve o nome da branch atual

2. `git fetch origin` — busca alterações sem aplicar

3. **Se na main/master:** `git pull origin main`

4. **Se em feature branch:**
   - `git checkout main`
   - `git pull origin main`
   - `git checkout [branch-original]`
   - `git merge main`

5. Confirme com `git status`

**Importante:** Adapte `main` ou `master` conforme a convenção do repositório.
