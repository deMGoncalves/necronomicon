# Solução de Problemas

Problemas comuns e suas soluções ao usar o oh my claude.

---

## Problemas de Fluxo de Trabalho

### loop.sh bloqueia todas as respostas

**Sintoma:** O Claude Code não consegue terminar de responder — o loop.sh continua bloqueando.

**Causa:** Existem tasks com `- [ ]` sem marcar em `changes/*/tasks.md`.

**Solução:**
1. Execute `/status` para ver qual feature tem tasks pendentes
2. Continue o fluxo de trabalho para concluir as tasks pendentes, OU
3. Marque as tasks manualmente como concluídas no `tasks.md` (mude `- [ ]` para `- [x]`), OU
4. Use o escape hatch para contornar emergencialmente:

```bash
touch .claude/.loop-skip
# Resolva o problema que está bloqueando
rm .claude/.loop-skip
```

> **Atenção:** Use o escape hatch somente se o fluxo de trabalho estiver genuinamente travado, não para pular controles de qualidade.

---

### prompt.sh não injeta hints de modo

**Sintoma:** Nenhuma classificação de modo acontece — o Claude Code não sugere Quick/Task/Feature.

**Causa:** O hook não está registrado no `settings.json`, ou o `jq` não está instalado.

**Solução:**
1. Verifique que o `settings.json` registra o hook:
```json
{
  "hooks": {
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "bash .claude/hooks/prompt.sh" }] }]
  }
}
```
2. Verifique se o `jq` está instalado: `which jq`
3. Teste o hook manualmente: `echo '{"prompt":"implement user auth"}' | bash .claude/hooks/prompt.sh`

---

### lint.sh não formata arquivos automaticamente

**Sintoma:** Os arquivos não são formatados após a escrita.

**Causa:** Hook não registrado para PostToolUse, ou o projeto não tem nenhum linter configurado.

**Solução:**
1. Verifique o `settings.json` para o registro do hook PostToolUse
2. Certifique-se de que seu projeto tem um linter configurado — o hook delega à configuração de linter do próprio projeto
3. Verifique se o hook é executável: `ls -la .claude/hooks/lint.sh`

---

### Agente fica preso em um loop

**Sintoma:** O @coder continua falhando e o loop não para.

**Causa:** O contador `attempts-coder` pode não estar incrementando, ou as specs são ambíguas.

**Solução:**
1. Verifique o contador em `changes/00X/tasks.md`:
```
<!-- attempts-coder: N -->
```
2. Se N ≥ 3, acione o re-spec: "Re-spec é necessário — @architect por favor revise o specs.md"
3. Se o contador não estiver incrementando, atualize-o manualmente

---

## Problemas com Agentes

### @architect não encontra ADRs existentes

**Sintoma:** O @architect cria ADRs que contradizem os já existentes.

**Causa:** `docs/adr/` não existe ou está vazio.

**Solução:**
```bash
mkdir -p docs/adr docs/arc42 docs/c4 docs/bdd
```

---

### @coder ignora o specs.md

**Sintoma:** A implementação não corresponde às specs.

**Causa:** O caminho de `changes/00X/specs.md` está errado, ou múltiplas features estão abertas simultaneamente.

**Solução:**
1. Execute `/status` para verificar qual feature está ativa
2. Verifique o diretório `changes/`: `ls changes/`
3. Confirme que o specs.md existe no diretório correto da feature

---

### @deepdive retorna "inconclusivo"

**Sintoma:** O relatório de investigação diz que a confiança é Baixa.

**Causa:** Não há código suficiente disponível para rastrear o problema.

**Solução:**
1. Forneça mais contexto na solicitação: mensagens de erro exatas, passos para reprodução
2. Aponte o @deepdive para arquivos específicos: "@deepdive investigate src/auth/login/"
3. Verifique se o problema está em uma dependência — o @deepdive não consegue ler o código-fonte de pacotes externos

---

### @tester falha com erros de import

**Sintoma:** Os testes falham porque os imports não podem ser resolvidos.

**Causa:** Os path aliases configurados no `tsconfig.json` ou na configuração do projeto não são reconhecidos pelo test runner.

**Solução:**
1. Verifique a configuração de path aliases no config de build/teste do seu projeto
2. Certifique-se de que o test runner consegue resolver aliases — a maioria precisa de um plugin ou uma opção de configuração
3. Adicione um comentário `// NOTE: path alias requires [config]` próximo ao import

---

## Problemas com /comandos

### /audit não posta no PR

**Sintoma:** `/audit pr 42` roda mas não posta um comentário.

**Causa:** O GitHub CLI não está autenticado.

**Solução:**
```bash
gh auth login
gh auth status  # verificar
```

---

### /ship falha ao fazer push

**Sintoma:** `/ship` cria um commit mas o push falha.

**Causa:** Regras de proteção de branch, nenhum remote configurado, ou um problema de autenticação.

**Solução:**
```bash
git remote -v           # verificar remote
git push --set-upstream origin $(git branch --show-current)
```

---

### /start cria número errado

**Sintoma:** Nova feature recebe o número sequencial errado.

**Causa:** `changes/` tem lacunas ou nomes de diretório fora do padrão.

**Solução:**
1. Verifique as features existentes: `ls changes/`
2. O comando `/start` escolhe o próximo número após o maior existente
3. Você pode renomear diretórios manualmente para corrigir lacunas

---

## Ainda travado?

1. Verifique as [Discussions](https://github.com/deMGoncalves/oh-my-claude/discussions) para problemas similares
2. Abra uma [Issue](https://github.com/deMGoncalves/oh-my-claude/issues) com:
   - O que você estava tentando fazer
   - O que aconteceu em vez disso
   - Saída relevante de hooks ou agentes
   - Conteúdo do `tasks.md` afetado

---

**Voltar para [README.md](README.md)**
