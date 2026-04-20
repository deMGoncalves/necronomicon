# Proibição de Poltergeists

**ID**: AP-12-065
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Poltergeists (ou Entidades de Vida Curta) ocorrem quando classes ou objetos são criados apenas para chamar outro método ou objeto e então são imediatamente descartados. Como poltergeists (espíritos transitórios) que aparecem brevemente e desaparecem, estes objetos não adicionam valor, apenas adicionam complexidade transitória. Middle men de vida curta.

## Por que importa

- Complexidade desnecessária: cada poltergeist adiciona +1 nome de classe/set para aprender e manter
- Confusão de leitura: desenvolvedores se perguntam "por que isso existe?" apenas para descobrir que não há razão
- Dificuldade de debugging: criação/descarte de objetos adicionam ruído ao stack trace e análise
- Indica refatoração incompleta ou aplicação mecânica de padrão sem pensar
- Espalha código boilerplate: quando poltergeists são comuns, muitos arquivos existem sem propósito

## Critérios Objetivos

- [ ] Classes/services criados apenas para adaptar parâmetros ou formatar chamadas e descartados
- [ ] Objetos criados e descartados dentro do mesmo escopo (linha única ou poucas linhas)
- [ ] Classes que existem apenas para passar dados entre camadas sem validação, transformação ou comportamento
- [ ] Padrão frequente de `new SomeAdapter(object).execute()` em vez de usar objeto diretamente
- [ ] Objetos construídos nunca armazenados, nunca testados, nunca referenciados além da chamada imediata

## Exceções Permitidas

- Padrões de Builder onde builder adiciona legibilidade via API fluente mesmo se descartado
- Adapters/wrappers que transformam formatos entre fronteiras (API → domínio interno)
- Commands/Queries encapsulados em padrões CQRS que existem por design
- DTOs que são criados, populados, passados para fronteira e então descartados (padrão padrão em camadas de fronteira)

## Como Detectar

### Manual
- Procurar instanciações onde objeto é criado, usado, descartado imediatamente (tudo no mesmo escopo)
- Identificar classes nunca usadas como campos, nunca referenciadas em testes, nunca parte de exports de módulo; apenas usadas localmente em funções
- Code review: questionar "que valor esse objeto adiciona?" para cada classe transitória
- Visualizar grafos de chamada: detectar nós folha chamados apenas uma vez

### Automático
- Linters: detectar objetos criados + chamados + descartados dentro do mesmo escopo
- Análise estática: detectar classes apenas referenciadas via instanciação e uso imprevisível
- Cobertura: detectar classes com 0% ou < 5% de cobertura de uso

## Relacionada com

- [061 - Proibição de Middle Man](061_proibicao-middle-man.md): complementa
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [057 - Proibição de Feature Envy](057_proibicao-feature-envy.md): complementa
- [009 - Diga, Não Pergunte](009_diga-nao-pergunte.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
