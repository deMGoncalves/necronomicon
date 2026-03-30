# Proibição de Herança de Refusão (Refused Bequest)

**ID**: AP-17-059
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Refused Bequest (Herança de Refusão) ocorre quando uma classe herda de outra mas não usa a maior parte dos métodos ou atributos herdadas. A classe recusa/refuta a herança que recebe. Indica hierarquia de herança mal modelada — a classe filho não deveria herdar da pai ou a herança deveria ser composition em vez de inheritance.

## Por que importa

- Interface abstrata vazia ou inútil: herança faz classe implementar métodos que não fazem sentido
- Violação do LSP (Liskov Substitution Principle): substituir pai por filho quebra comportamento esperado
- Complexidade desnecessária: classe filha carrega bagagem inútil da classe pai
- Bugs sutis: métodos não usados podem ser acidentalmente invocados (ex: via reflection, super calls)
- Indica design errado: se não usa a herança, não deveria ter herdado

## Critérios Objetivos

- [ ] Classe sobrescreve métodos pai com exceptions (throw UnsupportedOperationException)
- [ ] Classe herda methods/atributos que nunca são chamados ou utilizados
- [ ] 60%+ dos métodos/atributos da classe pai nunca são utilizados na classe filha
- [ ] Classe filha apenas usa 1-2 métodos da classe pai mas herda 10+
- [ ] Implementações vazias (pass) ou stubs para métodos herdados que não fazem sentido

## Exceções Permitidas

- Interfaces marker where subclass intentionally inherits "capability" even if unused
- Abstract template method patterns where subclass overrides most behavior but inherits contract
- Framework classes where unused methods part of required interface
- Código legado onde refatoração imediata traria risco alto sem ganho claro

## Como Detectar

### Manual
- Ler subclasses: identificar aquelas com muitos métodos sobrescritos vazios ou lançando exceptions
- Procurar por classes onde apenas 1-2 métodos herdados são realmente usados
- Verificar heranças onde subclass não "behaves like a" superclass (violação semântica)
- Analisar testes: testes para subclass não usam/testam métodos herdados

### Automático
- Análise de código: detectar classes com alta taxa de métodos sobrescritos ou não usados
- Linters: detectar métodos sobrescritos com exceptions ou implementações vazias
- Cobertura de código: branches/methods com 0% coverage em subclasses interessantes

## Relacionada com

- [012 - Princípio de Substituição de Liskov](012_principio-substituicao-liskov.md): reforça
- [010 - Princípio de Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): complementa
- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): complementa
- [008 - Proibição de Getters e Setters](008_proibicao-getters-setters.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0