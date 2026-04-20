# Proibição de Feature Envy (Inveja de Funcionalidade)

**ID**: AP-13-057
**Severidade**: 🟡 Média
**Categoria**: Comportamental

---

## O que é

Feature Envy ocorre quando um método usa dados e comportamentos de outra classe mais do que da própria. Indica que o método está na classe errada — ele "inveja" a outra classe e deveria estar lá. O método parece mais interessado nos dados de outro objeto do que nos próprios.

## Por que importa

- Violação de Encapsulamento: método precisa expor dados internos de outra classe (`getters`)
- Acoplamento desnecessário: torna difícil alterar uma classe sem quebrar a outra
- Lógica fragmentada: para entender uma regra de negócio completa, você precisa ler múltiplas classes
- Dificulta teste: testar o método exige construir objeto de outra classe com estado correto
- Violation of Tell, Don't Ask: perguntando estado em vez de pedir comportamento

## Critérios Objetivos

- [ ] Método chama getters de outro objeto 3 ou mais vezes
- [ ] Método acessa propriedades de outro objeto mais do que de `this`
- [ ] Método parece estar trabalhando nos dados de outro objeto em vez de seus próprios
- [ ] Para testar o método, você precisa configurar estado complexo de objetos dependentes
- [ ] Método que não usa nenhum atributo ou método da própria classe, apenas de dependências

## Exceções Permitidas

- Methods em controllers/orchestrators que orquestram fluxos entre múltiplos service objects
- DTOs/Data mappers que extrai dados de múltiplos objetos para formatar/serializar
- Event handlers que agregam dados de diferentes sources para processamento único
- Código legado onde refatoração traria risco alto sem ganho claro

## Como Detectar

### Manual
- Ler métodos: identificar aqueles que chamam `obj.getSomething()` repetidamente
- Procurar aplicações onde nível de acoplamento é alto mesmo encapsulado via getters
- Verificar métodos que não usam `this` internamente (ou usam minimamente)
- Analisar testes: se testar método exige setup complexo de dependências externas, pode ser feature envy

### Automático
- Análise de acoplamento: detectar métodos com alta dependência de dados de outras classes
- Code complexity tools: detectar métodos que acessam muitos atributos de objetos diferentes
- Linters: detectar tentativas de acessar propriedades internas em vez de métodos

## Relacionada com

- [009 - Diga Não, Pergunte](009_diga-nao-pergunte.md): reforça
- [008 - Proibição de Getters e Setters](008_proibicao-getters-setters.md): reforça
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): complementa
- [061 - Proibição de Middle Man](061_proibicao-middle-man.md): complementa
- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): reforça
- [012 - Princípio de Substituição de Liskov](012_principio-substituicao-liskov.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0