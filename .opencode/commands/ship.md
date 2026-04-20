---
description: "Prepara as alterações, cria commit Conventional Commits e envia para o remoto. Use após concluir uma Feature, Task ou Quick fix."
---

## Propósito

Commita e envia as alterações atuais para o repositório remoto.

Estado atual:
!`git status --short`

Commits recentes (referência de estilo):
!`git log --oneline -5`

## Instruções

1. Execute `git status` — confirme os arquivos a commitar

2. Execute `git diff --stat` — entenda o escopo das alterações

3. Elabore a mensagem de commit seguindo Conventional Commits:

   | Prefixo | Quando usar |
   |---------|-------------|
   | `feat:` | Nova funcionalidade |
   | `fix:` | Correção de bug |
   | `refactor:` | Refatoração sem mudança de comportamento |
   | `docs:` | Alterações em documentação |
   | `chore:` | Manutenção, configs, scripts |
   | `test:` | Adição ou correção de testes |

4. Prepare os arquivos com `git add` específico (evitar `git add -A` com arquivos sensíveis)

5. Crie o commit com HEREDOC:
   ```bash
   git commit -m "$(cat <<'EOF'
   tipo: descrição concisa no imperativo

   Co-Authored-By: deMGoncalves <noreply@github.com>
   EOF
   )"
   ```

6. Envie: `git push`

7. Confirme: `git status`

**Não commitar:** `.env` com valores reais, secrets, credenciais hardcoded.
