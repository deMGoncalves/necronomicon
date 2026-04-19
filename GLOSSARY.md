# Glossário

Termos-chave usados ao longo da documentação e dos agentes do oh my claude.

---

## A

**Agent**
Um sub-agente especializado do Claude definido em `.claude/agents/`. Cada agente tem uma única responsabilidade, contratos explícitos de entrada/saída e limites de tentativas delimitados. Os 6 agentes são: @planner, @architect, @designer, @coder, @tester, @deepdive.

**ADR (Architecture Decision Record)**
Um documento que registra uma decisão arquitetural importante, seu contexto, as opções consideradas e a justificativa para a opção escolhida. Armazenado em `docs/adr/`. Criado pelo @architect usando a skill `adr`.

**arc42**
Um template para documentação de arquitetura de software com 12 seções padronizadas. O oh my claude usa arc42 para a camada de documentação `docs/arc42/`. Veja a skill `arc42`.

---

## B

**BDD (Behavior-Driven Development)**
Uma técnica de especificação que usa Gherkin (Given/When/Then) para descrever o comportamento do sistema em linguagem de negócio. O oh my claude usa BDD para os arquivos de feature em `docs/bdd/`, escritos em português.

**Bounded loop**
Um mecanismo de tentativas com um máximo fixo (3 tentativas). Quando um agente atinge seu limite, o sistema para e pergunta ao humano se deve fazer re-spec ou forçar continuação. Evita loops descontrolados de IA.

---

## C

**C4 Model**
Um modelo de documentação hierárquico com 4 níveis de abstração: Context, Container, Component, Code. Usado para diagramas arquiteturais em `docs/c4/`.

**CCP (Common Closure Principle)**
Princípio de Pacotes (Regra 016): classes que mudam juntas pela mesma razão devem ser empacotadas juntas.

**CDD (Cognitive-Driven Development)**
Uma metodologia que mede a carga cognitiva do código como uma métrica objetiva. Implementada através da fórmula ICP. Veja a skill `cdd`.

**CC (Complexidade Ciclomática)**
Uma medida do número de caminhos independentes através de um método. O oh my claude limita a CC a ≤ 5 por método (Regra 022).

**changes/**
O diretório onde o contexto de Feature e Task é armazenado de forma persistente. Cada feature vive em `changes/00X_name/` com seus próprios arquivos de PRD, design, specs e tasks.

**Codetag**
Uma anotação de comentário educacional para marcar violações de regras: `FIXME` (crítica), `TODO` (alta), `XXX` (média), `SECURITY` (crítica). Sempre inclui explicação de por que o problema importa e como corrigi-lo.

**CQS (Command-Query Separation)**
Regra 038: um método deve ser ou um Comando (altera estado, retorna void) ou uma Consulta (retorna dados, sem efeitos colaterais) — nunca os dois.

---

## D

**DIP (Dependency Inversion Principle)**
Princípio SOLID (Regra 014): módulos de alto nível não devem depender de módulos de baixo nível — ambos devem depender de abstrações (interfaces).

**DRY (Don't Repeat Yourself)**
Regra 021: cada peça de conhecimento deve ter uma representação única, não ambígua e autoritativa dentro do sistema.

---

## E

**Evaluator-Optimizer pattern**
Um padrão de arquitetura de agentes onde um agente gera saída e outro a avalia, em loop até que o critério de qualidade seja atingido. Usado pelo @tester (avaliador) + @coder (otimizador).

---

## F

**Feature mode**
Um modo de fluxo de trabalho para novos contextos delimitados com incerteza arquitetural. Executa um fluxo completo de 4 fases: Planejar → Especificar → Codificar → Documentar.

**First Class Collection**
Regra de Object Calisthenics 004: qualquer coleção com lógica de negócio deve ser encapsulada em sua própria classe com métodos de comportamento.

**findings.md**
O artefato de saída do modo Research — um relatório estruturado de investigação produzido pelo @deepdive com evidências, causa raiz e recomendações.

---

## G

**GoF (Gang of Four)**
Os 23 padrões de design de "Design Patterns: Elements of Reusable Object-Oriented Software" (Gamma, Helm, Johnson, Vlissides). Cobertos pela skill `gof`.

---

## H

**Harness**
O diretório `.claude/` e todo o seu conteúdo. O "harness" é o sistema completo que orquestra o desenvolvimento assistido por IA.

**Hook**
Um script shell automático que é disparado em eventos do Claude Code sem invocação manual. O oh my claude tem 3 hooks: `prompt.sh` (UserPromptSubmit), `lint.sh` (PostToolUse), `loop.sh` (Stop).

---

## I

**ICP (Integrated Cognitive Persistence)**
A métrica de carga cognitiva: `ICP = CC_base + Nesting + Responsibilities + Coupling`. Valores: ≤3 excelente, 4-6 aceitável, 7-10 preocupante, >10 crítico.

**ISP (Interface Segregation Principle)**
Princípio SOLID (Regra 013): clientes não devem ser forçados a depender de interfaces que não utilizam.

---

## K

**KISS (Keep It Simple, Stupid)**
Regra 022: o código e o design devem ser o mais simples possível. Sem complexidade desnecessária. Medido pela Complexidade Ciclomática ≤ 5.

---

## L

**LSP (Liskov Substitution Principle)**
Princípio SOLID (Regra 012): classes derivadas devem ser substituíveis pelas suas classes base sem alterar a correção do programa.

---

## M

**Mode**
Uma das 5 classificações de fluxo de trabalho: Quick, Task, Feature, Research, UI. O hook `prompt.sh` detecta o modo provável e injeta uma sugestão.

---

## O

**OCP (Open/Closed Principle)**
Princípio SOLID (Regra 011): entidades de software devem ser abertas para extensão, mas fechadas para modificação.

**Orchestrator-Worker pattern**
Um padrão de arquitetura de agentes onde um orquestrador (Tech Lead/CLAUDE.md) roteia o trabalho para workers especializados (@planner, @coder, etc.). Cada worker tem uma única responsabilidade.

---

## P

**PoEAA (Patterns of Enterprise Application Architecture)**
Os 51 padrões empresariais de Martin Fowler. Cobertos pela skill `poeaa`. Inclui Repository, Data Mapper, Unit of Work, etc.

**PRD (Product Requirements Document)**
Um documento criado pelo @planner no modo Feature que captura o contexto de negócio, requisitos funcionais/não-funcionais e critérios de aceitação. Armazenado como `changes/00X/PRD.md`.

**Progressive Disclosure**
O padrão de carregamento de skills: `SKILL.md` é um índice leve sempre disponível; os arquivos de detalhe em `references/` são carregados sob demanda somente quando necessário, evitando inchaço de contexto.

---

## Q

**Quick mode**
O modo de fluxo de trabalho mais simples: vai diretamente para o @coder, sem criar diretório `changes/`. Usado para alterações em ≤2 arquivos existentes sem nova entidade.

---

## R

**Re-spec**
Quando o @coder falha 3 vezes, o fluxo de trabalho aciona a re-especificação: o @architect revisa o `specs.md` com a lista de problemas identificados. O contador de tentativas é zerado.

**Research mode**
Um modo de fluxo de trabalho para causas raiz desconhecidas: o @deepdive investiga primeiro, depois o @planner cria um plano baseado em evidências.

**Rule**
Uma das 70 restrições arquiteturais em `.claude/rules/`. Cada regra tem um ID, severidade, critérios objetivos, exceções e referências cruzadas.

---

## S

**Skill**
Um dos 35 módulos de conhecimento em `.claude/skills/`. Carregado pelos agentes sob demanda. Segue divulgação progressiva: índice leve + referências detalhadas.

**specs.md**
O artefato de especificação técnica criado pelo @architect: interfaces TypeScript, definições de contrato, critérios de aceitação. Consumido pelo @coder para implementar.

**SRP (Single Responsibility Principle)**
Princípio SOLID (Regra 010): uma classe deve ter apenas uma razão para mudar.

---

## T

**Task mode**
Um modo de fluxo de trabalho para novos contratos de interface com escopo claro. Cria `specs.md` + `tasks.md` em `changes/`. Usa um fluxo de spec leve sem PRD completo.

**tasks.md**
O rastreador de fluxo de trabalho para cada feature: lista de tasks T-001...T-NNN, fase atual, contadores de tentativas e marcador de modo. Monitorado pelo hook `loop.sh`.

**Tech Lead**
O papel desempenhado pelo próprio Claude Code (via CLAUDE.md): classifica pedidos, roteia para agentes, monitora loops, toma decisões de re-spec.

**Twelve-Factor**
Uma metodologia para construir aplicações nativas de nuvem, capturada nas Regras 040–051. Abrange codebase, configuração, serviços de apoio, processos stateless, etc.

---

## U

**UI mode**
Um modo de fluxo de trabalho para componentes visuais: @designer + @architect trabalham em paralelo antes do @coder, garantindo conformidade com o design system e acessibilidade.

---

## V

**Value Object**
Regra de Object Calisthenics 003: primitivos de domínio (como Email, CPF, Moeda) devem ser encapsulados em classes Value Object imutáveis que validam na construção.

**Vertical Slice**
O padrão de organização de código usado pelo oh my claude: `src/[context]/[container]/[component]/`. Os arquivos de cada feature vivem juntos em um diretório. Veja a skill `colocation`.

---

## W

**WCAG (Web Content Accessibility Guidelines)**
Padrões internacionais de acessibilidade. O agente @designer do oh my claude aplica a conformidade WCAG AA como linha de base mínima para componentes de UI.

---

**Voltar para [README.md](README.md)**
