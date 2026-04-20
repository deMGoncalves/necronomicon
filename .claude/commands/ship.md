---
description: "Prepara mudanças, cria commit Conventional Commits e envia para remoto. Usar após completar Feature, Task ou Quick fix."
allowed-tools: Bash(git add *), Bash(git status), Bash(git diff *), Bash(git commit *), Bash(git push *), Bash(git log *)
---

## Propósito

Commita e envia mudanças atuais para repositório remoto.

Estado atual:
!`git status --short`

Commits recentes (referência de estilo):
!`git log --oneline -5`

## Instruções

1. Executar `git status` — confirmar arquivos a commitar

2. Executar `git diff --stat` — entender escopo das mudanças

3. Elaborar mensagem de commit seguindo Conventional Commits:

   | Prefixo | Quando usar |
   |---------|-------------|
   | `feat:` | Nova funcionalidade |
   | `fix:` | Correção de bug |
   | `refactor:` | Refatoração sem mudança de comportamento |
   | `docs:` | Mudanças de documentação |
   | `chore:` | Manutenção, configs, scripts |
   | `test:` | Adicionar ou corrigir testes |

4. Preparar arquivos com `git add` específico (evitar `git add -A` com arquivos sensíveis)

5. Criar commit com HEREDOC:
   ```bash
   git commit -m "$(cat <<'EOF'
   tipo: descrição concisa no imperativo

   Co-Authored-By: deMGoncalves <noreply@github.com>
   EOF
   )"
   ```

6. Enviar: `git push`

7. Confirmar: `git status`

**Não commitar:** `.env` com valores reais, secrets, credenciais hardcoded.
