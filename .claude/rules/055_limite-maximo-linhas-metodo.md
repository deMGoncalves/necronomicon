# Limite Máximo de Linhas por Método

**ID**: AP-19-055
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Long Method (Método Longo) ocorre quando um método possui muitas linhas de código, tipicamente fazendo muitas coisas diferentes. Métodos longos são difíceis de entender, testar, reutilizar e manter. E frequentemente contêm múltiplas abstrações ocultas.

## Por que importa

- Baixa legibilidade: desenvolvedores perdem o fluxo lógico em métodos extensos
- Dificuldade de teste: testar múltiplas responsabilidades em um único método é complexo
- Baixa reutilização: partes do método não podem ser reutilizadas isoladamente
- Code smell: métodos longos frequentemente indicam violação de SRP e baixa coesão
- Bugs ocultos: é fácil se perder em control flow complexo e introduzir bugs

## Critérios Objetivos

- [ ] Métodos com mais de 20 linhas de código (excluindo blank lines e comentários)
- [ ] Métodos com mais de 3 níveis de indentação aninhada
- [ ] Métodos que fazem mais de 3 coisas diferentes (ex: valida + persiste + loga)
- [ ] Métodos com múltiplas responsabilidades em sequência sem dependência clara
- [ ] Métodos onde mesmo o autor não consegue explicar em uma frase "o que faz"

## Exceções Permitidas

- Constructors de objetos complexos quando não há alternativa mais legível
- Métodos que implementam algoritmos matemáticos ou científicos onde breaking da lógica reduziria clareza
- Compatibilidade com código legado onde refatoração traria risco alto
- Event handlers or callbacks externos com código arbitrário de terceiros

## Como Detectar

### Manual
- Ler métodos: se precisar pausar no meio para continuar entendendo, é longo demais
- Procurar por comentários explicando "aquá faz X, agora faz Y" — pontos de extração
- Identificar métodos onde CTRL+F mostra重复 patterns, condições, ou validations

### Automático
- Linters: eslint (complexity, max-lines-per-function), SonarQube, CodeClimate
- Métricas de cyclomatic complexity > 10 geralmente indica método longo
- Análise estática: detectar métodos com muitas linhas e complexidade alta

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [010 - Princípio de Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): complementa
- [009 - Diga Não, Pergunte](009_diga-nao-pergunte.md): complementa
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): complementa
- [059 - Proibição de Herança de Refusão](059_proibicao-heranca-refusao.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0