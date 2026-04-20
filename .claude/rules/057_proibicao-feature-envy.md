# Proibição de Feature Envy

**ID**: AP-13-057
**Severidade**: 🟡 Média
**Categoria**: Comportamental

---

## O que é

Feature Envy ocorre quando um método usa dados e comportamentos de outra classe mais do que da sua própria. Indica que o método está na classe errada — ele "inveja" a outra classe e deveria estar lá. O método parece mais interessado nos dados de outro objeto do que nos seus próprios.

## Por que importa

- Violação de encapsulamento: método precisa expor dados internos de outra classe (`getters`)
- Acoplamento desnecessário: dificulta mudar uma classe sem quebrar a outra
- Lógica fragmentada: para entender uma regra de negócio completa, precisa ler múltiplas classes
- Dificuldade de teste: testar o método requer construir objeto de outra classe com estado correto
- Violação de Tell, Don't Ask: perguntando por estado em vez de solicitar comportamento

## Critérios Objetivos

- [ ] Método chama getters de outro objeto 3 ou mais vezes
- [ ] Método acessa propriedades de outro objeto mais do que `this`
- [ ] Método parece estar trabalhando nos dados de outro objeto em vez dos seus próprios
- [ ] Para testar o método, precisa configurar estado complexo de objetos dependentes
- [ ] Método que não usa nenhum atributo ou método da própria classe, apenas dependências

## Exceções Permitidas

- Métodos em controllers/orchestrators que orquestram fluxos entre múltiplos objetos de serviço
- DTOs/Data mappers que extraem dados de múltiplos objetos para formatar/serializar
- Event handlers que agregam dados de diferentes fontes para processamento único
- Código legado onde refatoração traria alto risco sem ganho claro

## Como Detectar

### Manual
- Ler métodos: identificar aqueles que repetidamente chamam `obj.getSomething()`
- Buscar aplicações onde nível de acoplamento é alto mesmo encapsulado via getters
- Verificar métodos que não usam `this` internamente (ou usam minimamente)
- Analisar testes: se testar método requer setup complexo de dependências externas, pode ser feature envy

### Automático
- Análise de acoplamento: detectar métodos com alta dependência em dados de outras classes
- Ferramentas de complexidade de código: detectar métodos que acessam muitos atributos de objetos diferentes
- Linters: detectar tentativas de acessar propriedades internas em vez de métodos

## Relacionada com

- [009 - Diga, Não Pergunte](009_diga-nao-pergunte.md): reforça
- [008 - Proibição de Getters e Setters](008_proibicao-getters-setters.md): reforça
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): complementa
- [061 - Proibição de Middle Man](061_proibicao-middle-man.md): complementa
- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): reforça
- [012 - Princípio de Substituição de Liskov](012_principio-substituicao-liskov.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
