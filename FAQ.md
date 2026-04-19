# Perguntas Frequentes

---

## Geral

### O que é o oh my claude?

Um diretório de configuração `.claude/` que transforma o Claude Code em um fluxo de trabalho estruturado de engenharia de software. Ele fornece 6 agentes de IA especializados, 70 regras arquiteturais, 35 skills de conhecimento, 6 comandos e 3 hooks automáticos — todos trabalhando juntos para garantir qualidade de código consistente.

### É um plugin? Um framework?

Nenhum dos dois. É um harness — um conjunto de instruções e módulos de conhecimento que o Claude Code carrega automaticamente quando você abre um projeto. Não há nada para instalar além de clonar o repositório.

### Funciona com minha stack tecnológica?

Sim. O harness é agnóstico em relação à tecnologia por design. Os agentes não fazem referência a ferramentas, frameworks ou linguagens específicas. As ferramentas do seu próprio projeto (linters, test runners, bundlers) se integram naturalmente através de hooks que delegam ao que você tiver configurado.

### Funciona com outras linguagens além de TypeScript?

Sim. Os agentes, regras e skills descrevem princípios de engenharia que se aplicam a qualquer linguagem orientada a objetos ou funcional. Os exemplos de código na documentação usam TypeScript/JavaScript por concretude, mas os conceitos têm aplicação ampla.

### Por que a documentação interna está em português?

O autor do projeto ([@deMGoncalves](https://github.com/deMGoncalves)) é brasileiro. A documentação interna — agentes, skills, regras — está em português para corresponder ao domínio cognitivo do autor. A documentação externa (README, CONTRIBUTING, este FAQ) está em inglês para alcance no OSS.

---

## Fluxo de Trabalho

### Qual é a diferença entre Quick, Task e Feature?

| Modo | Usar quando | Cria changes/? |
|------|-------------|----------------|
| **Quick** | ≤2 arquivos, sem nova entidade | Não |
| **Task** | Novo contrato de interface, escopo claro | Sim (specs.md + tasks.md) |
| **Feature** | Novo contexto delimitado, incerteza arquitetural | Sim (PRD + design + specs + tasks) |

### Quando devo usar o modo Research?

Quando você não sabe a causa raiz de um problema. Em vez de adivinhar e pedir ao @coder para implementar uma correção, o @deepdive investiga o código primeiro, produz um relatório de findings e, em seguida, o @planner cria um plano de implementação baseado em evidências.

### Quando devo usar o modo UI?

Ao criar ou modificar um componente visual. O @designer cria uma especificação de componente (design tokens, estados, acessibilidade) antes do @coder implementar — prevenindo o problema clássico de "vou definir o design enquanto codifico".

### Posso rodar múltiplas features em paralelo?

Sim. Cada feature vive em seu próprio diretório `changes/00X_name/` com contadores independentes. Apenas esteja ciente de que alterações em arquivos compartilhados (como exports de `index.ts`) podem conflitar entre features.

### O que acontece quando um agente falha 3 vezes?

O contador de tentativas (`attempts-coder`, `attempts-tester`) chega a 3 e o sistema para para perguntar se você quer re-spec ou forçar continuação. Re-spec significa que o @architect revisa as specs com a lista de problemas identificados — geralmente a escolha certa quando as specs eram ambíguas.

### Como retomo um fluxo de trabalho interrompido?

Digite `continue` no Claude Code. O Tech Lead lê o estado atual do `tasks.md` e retoma a partir da última tarefa não concluída.

---

## Agentes

### Qual é a diferença entre @planner e @architect?

**@planner** pensa sobre *o que construir e em que ordem* — decomposição de tarefas, mapeamento de dependências, identificação de riscos. Cria o `tasks.md` e o `PRD.md`.

**@architect** pensa sobre *como construir tecnicamente* — design de interface, seleção de padrões, `specs.md` e documentação arquitetural. Lê a saída do @planner para criar specs implementáveis.

### O que aconteceu com o @reviewer?

Na v2.0.0, o `@reviewer` foi absorvido pelo `@architect` como modo de revisão. Quando o @architect faz revisão de código (após o @tester passar), ele aplica a mesma metodologia ICP/CDD e a validação das 70 regras que o @reviewer costumava fazer. O papel existe — ele vive dentro do @architect agora.

### Posso invocar um agente diretamente?

Sim. Digite `@nomedoagente [pedido]` para rotear diretamente para qualquer agente. Por exemplo:
- `@deepdive investigate why src/auth/login fails silently`
- `@architect design the interface for a payment processing module`
- `@designer spec the dropdown component`

### O que o @deepdive produz?

Um relatório estruturado de findings com: escopo, método, evidências (citações arquivo:linha), causa raiz (para bugs) e recomendações acionáveis atribuídas a agentes específicos. Ele investiga, mas nunca implementa.

---

## Regras

### Quais são as 70 regras?

Restrições arquiteturais organizadas em 6 categorias: Object Calisthenics (001–009), SOLID (010–014), Package Principles (015–020), Clean Code (021–039), Twelve-Factor (040–051) e Anti-Patterns (052–070). Cada regra tem critérios objetivos e mensuráveis — não opiniões subjetivas.

### O que é ICP?

Integrated Cognitive Persistence — uma métrica que o @architect usa para medir carga cognitiva:
```
ICP = CC_base + Nesting + Responsibilities + Coupling
```
ICP > 10 significa refatoração obrigatória. O objetivo é manter o código dentro dos limites de compreensão humana.

### Posso desabilitar uma regra?

Não globalmente — as regras são aplicadas pela consciência dos agentes, não por bloqueio automatizado (exceto limites de ICP). Se uma regra não se aplica ao seu projeto, documente a exceção em um ADR (`/docs` cria um) para que futuros colaboradores entendam o desvio deliberado.

### O que é um codetag?

Um formato de comentário educacional para marcar violações de regras diretamente no código:
- `// FIXME:` — violação crítica (bloqueia PR)
- `// TODO:` — melhoria de alta prioridade
- `// XXX:` — melhoria de média prioridade
- `// SECURITY:` — preocupação de segurança

Os codetags sempre explicam *por que* o problema importa e *como* corrigi-lo — não apenas que algo está errado.

---

## Skills

### O que é uma skill?

Um módulo de conhecimento armazenado em `.claude/skills/` que um agente carrega sob demanda. As skills contêm explicações detalhadas, exemplos e referências que os agentes usam ao tomar decisões. Elas são lidas no contexto quando relevantes — não são sempre carregadas.

### Quantas skills existem?

35 skills cobrindo: estrutura de classes, convenções de membros, padrões de comportamento, manipulação de dados, organização de código, princípios OOP, qualidade de código, padrões de design (GoF: 23 padrões, PoEAA: 51 padrões), documentação, infraestrutura e anti-padrões.

### Posso adicionar minhas próprias skills?

Sim. Veja o [CONTRIBUTING.md](CONTRIBUTING.md) para o template de skill. As skills seguem divulgação progressiva: um índice leve `SKILL.md` + `references/` detalhadas carregadas sob demanda.

---

## Contribuição

### Por onde começo se quiser contribuir?

Leia o [CONTRIBUTING.md](CONTRIBUTING.md). As contribuições de maior impacto são:
1. Novas regras (próximo ID: 071)
2. Novas skills (especialmente para padrões ainda não cobertos)
3. Correções de bugs em hooks ou comandos

### Posso sugerir um novo agente?

Sim — abra uma Discussion primeiro. Novos agentes precisam de uma única responsabilidade clara que não se sobreponha aos agentes existentes, e contratos explícitos de entrada/saída.

---

**Voltar para [README.md](README.md)**
