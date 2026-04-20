# Proibição de Código Zombie (Lava Flow)

**ID**: AP-02-056
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Lava Flow (Dead Code / Zombie Code) ocorre quando código não é mais utilizado mas permanece no sistema porque ninguém tem certeza se pode ser removido com segurança. Como lava que solidifica e endurece, este código se torna um obstáculo permanente à manutenção. Código abandonado, comentado ou nunca chamado.

## Por que importa

- Carga cognitiva extra: desenvolvedores precisam entender código inútil para encontrar código útil
- Confusão perpetuada: novos desenvolvedores não sabem o que está ativo ou obsoleto
- Débito técnico crescente: o sistema se torna maior e mais lento para navegar
- Bugs preservados: código morto pode ser reativado acidentalmente e introduzir bugs antigos
- Complexidade falsa: sistema parece fazer mais do que realmente faz

## Critérios Objetivos

- [ ] Funções, classes ou módulos nunca chamados/executados
- [ ] Código comentado com marcadores como `// versão antiga`, `// deprecated`, `// TODO remover`
- [ ] Imports de módulos/pacotes que nunca são referenciados
- [ ] Branches de `if` ou `switch` que nunca são executados (cobertura de teste = 0%)
- [ ] Variáveis declaradas e nunca lidas
- [ ] Arquivos inteiros que ninguém sabe para que servem

## Exceções Permitidas

- Código temporariamente desabilitado/comentado com @TODO bem documentado e prazo
- Feature flags ou testes A/B com uso conhecido
- Código mantido para rollback imediato (< 1 dia) quando há funcionalidade crítica
- Documentação histórica mantida em comentários quando possui valor educacional

## Como Detectar

### Manual
- Procurar comentários com prefixos `//`, `#` e TODO, FIXME, DEPRECATED
- Buscar arquivos com "If __name__ == '__main__'" mas sem uso real
- Identificar funções/classes sem testes unitários, sem imports, sem referências
- Verificar módulos importados mas nunca usados

### Automático
- Análise estática: detecção de código morto (pyflakes, eslint no-unused-vars, unused-import)
- Cobertura de código: branches/linhas com 0% de cobertura são suspeitas
- Ferramentas de tree shaking para detectar código não referenciado em frontend
- Ferramentas de IDE: "Find Unused Code" no VS Code, PyCharm

## Relacionada com

- [039 - Regra do Escoteiro (Refatoração Contínua)](039_regra-escoteiro-refatoracao-continua.md): reforça
- [021 - Proibição da Duplicação de Lógica](021_proibicao-duplicacao-logica.md): complementa
- [025 - Proibição do Anti-Pattern The Blob](025_proibicao-anti-pattern-the-blob.md): reforça
- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [032 - Cobertura Mínima de Teste e Qualidade](032_cobertura-teste-minima-qualidade.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
