# Proibição de Middle Man

**ID**: AP-19-061
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Middle Man ocorre quando uma classe delega a maioria de seus métodos para outra classe sem adicionar seu próprio valor. Se 50%+ dos métodos de uma classe apenas repassam chamadas (linha única `return this.obj.method(args)`), é um Middle Man inútil. É o inverso de Feature Envy: aqui, o middle man delega tudo; lá, o método faz o trabalho de outro objeto.

## Por que importa

- Complexidade desnecessária: mais arquivos, mais imports, mais nomes para aprender
- Manutenção duplicada: cada mudança na interface real requer mudança no Middle Man
- Debug mais lento: stack trace com camadas desnecessárias e confusão sobre onde está a lógica real
- Acoplamento indireto: se remover objeto real, middle man perde existência sem valor
- Indica over-engineering ou refatoração incompleta: classe foi útil uma vez mas perdeu propósito

## Critérios Objetivos

- [ ] 50%+ dos métodos da classe são delegates de uma linha sem adicionar valor
- [ ] Classe existe apenas para esconder outro objeto exposto diretamente inicialmente
- [ ] Sempre que adicionar método ao objeto real, adiciona mesma wrapper ao Middle Man
- [ ] Stack trace sempre mostra mesmos nomes de método em duas camadas consecutivas
- [ ] Middle Man não é usado/testado isoladamente — sempre precisa do objeto real funcionando

## Exceções Permitidas

- Padrões de Facade que simplificam interface complexa (adicionando valor via simplificação)
- Proxies com preocupações transversais (logging, caching, autenticação)
- Adapters que transformam interfaces de formatos diferentes
- DTOs/ViewModels que transformam objetos de entidade para camada de apresentação

## Como Detectar

### Manual
- Ler classe: identificar métodos que apenas fazem `return this.obj.method(args)` sem modificação
- Buscar classes onde adicionar método sempre requer adicionar mesmo delegate em outra classe
- Verificar testes: testes do middle man apenas testam que ele repassa corretamente, não lógica própria
- Analisar chamadas: sempre navega pelo middle man para chegar ao objeto real

### Automático
- Análise estática: detectar classes com alta taxa de métodos que apenas delegam (vs implementam lógica)
- Complexidade de código: detectar classes onde complexidade ciclomática por método ≈ 1 (código mais delegando)
- Análise de acoplamento: detectar classes que apenas existem para encapsular outras sem adicionar comportamento

## Relacionada com

- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [057 - Proibição de Feature Envy](057_proibicao-feature-envy.md): complementa
- [008 - Proibição de Getters e Setters](008_proibicao-getters-setters.md): reforça
- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): complementa
- [065 - Proibição de Poltergeists](065_proibicao-poltergeists.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
