# Proibição de Herança Recusada

**ID**: AP-17-059
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Refused Bequest ocorre quando uma classe herda de outra mas não usa a maioria dos métodos ou atributos herdados. A classe recusa/rejeita a herança que recebe. Indica hierarquia de herança mal modelada — a classe filha não deveria herdar da mãe ou a herança deveria ser composição em vez de herança.

## Por que importa

- Interface abstrata vazia ou inútil: herança faz classe implementar métodos que não fazem sentido
- Violação de LSP (Princípio de Substituição de Liskov): substituir pai por filho quebra comportamento esperado
- Complexidade desnecessária: classe filha carrega bagagem inútil da classe pai
- Bugs sutis: métodos não usados podem ser invocados acidentalmente (ex: via reflexão, chamadas super)
- Indica design errado: se não usa a herança, não deveria ter herdado

## Critérios Objetivos

- [ ] Classe sobrescreve métodos do pai com exceções (throw UnsupportedOperationException)
- [ ] Classe herda métodos/atributos que nunca são chamados ou usados
- [ ] 60%+ dos métodos/atributos da classe pai nunca são usados na classe filha
- [ ] Classe filha usa apenas 1-2 métodos da classe pai mas herda 10+
- [ ] Implementações vazias (pass) ou stubs para métodos herdados que não fazem sentido

## Exceções Permitidas

- Interfaces marcadoras onde subclasse intencionalmente herda "capacidade" mesmo se não usada
- Padrões de template method abstrato onde subclasse sobrescreve maior parte do comportamento mas herda contrato
- Classes de framework onde métodos não usados fazem parte de interface obrigatória
- Código legado onde refatoração imediata traria alto risco sem ganho claro

## Como Detectar

### Manual
- Ler subclasses: identificar aquelas com muitos métodos sobrescritos vazios ou lançando exceções
- Buscar classes onde apenas 1-2 métodos herdados são realmente usados
- Verificar herança onde subclasse não "comporta-se como um" superclasse (violação semântica)
- Analisar testes: testes para subclasse não usam/testam métodos herdados

### Automático
- Análise de código: detectar classes com alta taxa de métodos sobrescritos ou não usados
- Linters: detectar métodos sobrescritos com exceções ou implementações vazias
- Cobertura de código: branches/métodos com 0% de cobertura em subclasses interessantes

## Relacionada com

- [012 - Princípio de Substituição de Liskov](012_principio-substituicao-liskov.md): reforça
- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): complementa
- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): complementa
- [008 - Proibição de Getters e Setters](008_proibicao-getters-setters.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
