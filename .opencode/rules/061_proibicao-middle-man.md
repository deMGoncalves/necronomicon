# Proibição de Middle Man (Intermediário Inútil)

**ID**: AP-19-061
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Middle Man (Intermediário Inútil) ocorre quando uma classe delega a maioria de seus métodos para outra classe sem adicionar valor próprio. Se 50%+ dos métodos de uma classe apenas repassam chamadas (one-line `return this.obj.method(args)`), ela é um Middle Man inútil. É inverso do Feature Envy: aqui, o middle man delega tudo; lá, o método faz trabalho de outro objeto.

## Por que importa

- Complexidade desnecessária: mais arquivos, mais imports, mais nomes para aprender
- Manutenção duplicada: cada mudança na interface real exige mudança no Middle Man
- Debugging mais lento: stack trace com camadas desnecessárias e confusão sobre onde está a lógica real
- Acoplamento indireto: se remover o objeto real, middle man perde existência sem valor
- Indica sobre-engenharia ou refatoração incompleta: classe foi útil alguma vez mas perdeu propósito

## Critérios Objetivos

- [ ] 50%+ dos métodos da classe são one-line delegates sem adicionar valor
- [ ] Classe existe apenas para esconder outro objeto iniçialemnte exposto diretamente
- [ ] Sempre que adiciona um método ao objeto real, adiciona same wrapper ao Middle Man
- [ ] Stack trace sempre mostra same method names em duas camadas consecutivas
- [ ] Middle Man não é usado/testado isoladamente — sempre precisa do objeto real funcionando

## Exceções Permitidas

- Facade patterns que simplificam interface complexa (adding value via simplification)
- Proxies com cross-cutting concerns (logging, caching, authentication)
- Adapters que transformam interfaces de formatos diferentes
- DTOs/ViewModels que transformam entity objects for presentation layer

## Como Detectar

### Manual
- Ler classe: identificar métodos que apenas fazem `return this.obj.method(args)` sem modification
- Procurar por classes onde adicionar método sempre exige adicionar same delegate em another class
- Verificar testes: testes de middle man só testam que repassa corretamente, não lógica própria
- Analisar chamadas: sempre se navega through middle man para chegar no objeto real

### Automático
- Static analysis: detectar classes com taxa alta de métodos que apenas delegam (vs implementam lógica)
- Code complexity: detectar classes onde cyclomatic complexity por método ≈ 1 (mais código delegando)
- Análise de acoplamento: detectar classes apenas existem para encapsular outras sem adicionar comportamento

## Relacionada com

- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [057 - Proibição de Feature Envy](057_proibicao-feature-envy.md): complementa
- [008 - Proibição de Getters e Setters](008_proibicao-getters-setters.md): reforça
- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): complementa
- [065 - Proibição de Poltergeists](065_proibicao-poltergeists.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0