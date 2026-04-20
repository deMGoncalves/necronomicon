# Limite Máximo de Linhas por Método

**ID**: AP-19-055
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Long Method ocorre quando um método possui muitas linhas de código, tipicamente fazendo várias coisas diferentes. Métodos longos são difíceis de entender, testar, reutilizar e manter. E frequentemente contêm múltiplas abstrações ocultas.

## Por que importa

- Baixa legibilidade: desenvolvedores perdem o fluxo lógico em métodos extensos
- Dificuldade de teste: testar múltiplas responsabilidades em um único método é complexo
- Baixa reusabilidade: partes do método não podem ser reutilizadas isoladamente
- Code smell: métodos longos frequentemente indicam violação de SRP e baixa coesão
- Bugs ocultos: é fácil se perder no fluxo de controle complexo e introduzir bugs

## Critérios Objetivos

- [ ] Métodos com mais de 20 linhas de código (excluindo linhas em branco e comentários)
- [ ] Métodos com mais de 3 níveis de indentação aninhada
- [ ] Métodos que fazem mais de 3 coisas diferentes (ex: valida + persiste + loga)
- [ ] Métodos com múltiplas responsabilidades em sequência sem dependência clara
- [ ] Métodos onde até o autor não consegue explicar "o que ele faz" em uma frase

## Exceções Permitidas

- Construtores de objetos complexos quando não há alternativa mais legível
- Métodos implementando algoritmos matemáticos ou científicos onde quebrar a lógica reduziria clareza
- Compatibilidade com código legado onde refatoração traria alto risco
- Event handlers ou callbacks externos com código de terceiros arbitrário

## Como Detectar

### Manual
- Ler métodos: se você precisa pausar no meio para continuar entendendo, está longo demais
- Buscar comentários explicando "aqui ele faz X, agora faz Y" — pontos de extração
- Identificar métodos onde CTRL+F mostra padrões repetidos, condições ou validações

### Automático
- Linters: eslint (complexity, max-lines-per-function), SonarQube, CodeClimate
- Métricas de complexidade ciclomática > 10 geralmente indicam método longo
- Análise estática: detectar métodos com muitas linhas e alta complexidade

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): complementa
- [009 - Diga, Não Pergunte](009_diga-nao-pergunte.md): complementa
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): complementa
- [059 - Proibição de Herança Recusada](059_proibicao-heranca-refusao.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
