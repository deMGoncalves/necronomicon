# Proibição de Código Zombie (Lava Flow)

**ID**: AP-02-056
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Lava Flow (Código Morto / Zombie Code) ocorre quando código não é mais usado mas permanece no sistema porque ninguém tem certeza se pode ser removido com segurança. Como lava que solidifica e endurece, esse código vira obstáculo permanente à manutenção. Códigos abandonados, comentados ou nunca chamados.

## Por que importa

- Carga cognitiva extra: desenvolvedores precisam entender código inútil para encontrar código útil
- Confusão perpetuada: novos desenvolvedores não sabem o que está ativo ou obsoleto
- Dívida técnica crescente: o sistema fica maior e mais lento de navegar
- Bugs preservados: código morto pode ser acidentalmente reativado e introduzir bugs antigos
- Falsa complexidade: sistema parece fazer mais do que realmente faz

## Critérios Objetivos

- [ ] Funções, classes ou módulos nunca chamados/executados
- [ ] Código comentado com markers como `// old version`, `// deprecated`, `// TODO remove`
- [ ] Importações de módulos/pacotes que nunca são referenciados
- [ ] Branches de `if` ou `switch` que nunca são executadas (cobertura de teste = 0%)
- [ ] Variáveis declaradas e nunca lidas
- [ ] Arquivos inteiros que ninguém sabe para que servem

## Exceções Permitidas

- Código temporariamente desabilitado/descomentado com @TODO bem documentado e prazo
- Feature flags ou A/B tests com uso conhecido
- Código mantido por rollback imediato (< 1 dia) quando há funcionalidade crítica
- Documentação histórica mantida em comentários quando tem valor educacional

## Como Detectar

### Manual
- Buscar por comentários com `//`, `#` prefixos e TODO, FIXME, DEPRECATED
- Procurar por arquivos com"If __name__ == '__main__'" mas sem uso real
- Identificar funções/classes sem testes de unidade, sem imports, sem referências
- Verificar módulos importados mas nunca utilizados

### Automático
- Análise estática: dead code detection (pyflakes, eslint no-unused-vars, unused-import)
- Cobertura de código: branches/lines com 0% coverage são suspeitos
- Tree shaking tools para detectar código não referenciado em frontend
- Ferramentas de IDE: "Find Unused Code" em VS Code, PyCharm

## Relacionada com

- [039 - Regra do Escoteiro (Refatoração Contínua)](039_regra-escoteiro-refatoracao-continua.md): reforça
- [021 - Proibição de Duplicação de Lógica](021_proibicao-duplicacao-logica.md): complementa
- [025 - Proibição de Anti-Pattern The Blob](025_proibicao-anti-pattern-the-blob.md): reforça
- [010 - Princípio de Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [032 - Cobertura de Teste Mínima de Qualidade](032_cobertura-teste-minima-qualidade.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0