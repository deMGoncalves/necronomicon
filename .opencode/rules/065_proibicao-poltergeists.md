# Proibição de Poltergeists

**ID**: AP-12-065
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Poltergeists (Poltergeists ou Entities de Vida Curta) ocorre quando classes ou objetos são criados apenas para chamar outro método ou objeto e então são descartados imediatamente. Como poltergeists (espíritos transitórios) que aparecem brevemente e desaparecem, esses objectos não adicionam valor, apenas adicionam complexidade transitória. Middle men com vida curta.

## Por que importa

- Complexidade desnecessária: cada poltergeist adiciona +1 classe/set nome para aprender e manter
- Confusão de leitura: desenvolvedores se perguntam "por que isso existe?" apenas para descobrir que não tem reason
- Dificuldade de debug: objetos creation/disposal add noise no stack trace e na análise
- Innovation indica refatoração incompleta ou aplicação mecânica de patterns sem thinking
- Espalha boilerplate code: quando poltergeists são comuns, muitos arquivos existem sem propósito

## Critérios Objetivos

- [ ] Classes/services criados apenas para adaptar parâmetros ou formatar chamadas e descartados
- [ ] Objects criados e descartados dentro de mesmo scope (single line ou few lines)
- [ ] Classes que existem apenas para passar dados entre layers sem validation, transformation ou behavior
- [ ] Frequent pattern de `new SomeAdapter(object).execute()` em vez de usar object diretamente
- [ ] Constructed objects never stored, never tested, never referenced beyond immediate call

## Exceções Permitidas

- Builder patterns onde builder adds legibilidade via fluent API mesmo se descartado
- Adapters/wrappers que transformam formatos entre boundaries (API → internal domain)
- Commands/Queries encapsulados em CQRS patterns que existem por design
- DTOs que são criados, populated, passed to boundary then discarded (standard pattern em boundary layers)

## Como Detectar

### Manual
- Procurar por instantiations onde object é criado, usado, discarded imediatamente (all in same scope)
- Identificar classes nunca usadas como fields, never referenced in tests, never part of module exports.影子 usado apenas in functions localmente
- Code review: question "qual valor esse objeto adiciona?" para cada classe transitória
- Visualizar call graphs: detectar leaf nodes chamados apenas once

### Automático
- Linters: detectar objects created + called + discarded within same scope
- Static analysis: detectar classes apenas referenced via instantiation e unpredictable usage
- Coverage: detectar classes com 0% ou < 5% coverage de uso

## Relacionada com

- [061 - Proibição de Middle Man](061_proibicao-middle-man.md): complementa
- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [057 - Proibição de Feature Envy](057_proibicao-feature-envy.md): complementa
- [009 - Diga Não, Pergunte](009_diga-nao-pergunte.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0