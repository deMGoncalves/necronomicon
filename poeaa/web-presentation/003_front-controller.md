# Front Controller

**Tipo**: Padrão de Apresentação Web

---

## Intenção e Objetivo

Centralizar todo o tratamento de requisições HTTP em um único objeto que processa comportamentos comuns (autenticação, logging, roteamento) e, em seguida, despacha para handlers específicos (commands ou page controllers) para processar a lógica particular de cada requisição.

## Também Conhecido Como

- Central Dispatcher
- Request Processor
- Single Entry Point

---

## Motivação

À medida que as aplicações web crescem, múltiplos Page Controllers tendem a duplicar lógica comum: verificar autenticação, estabelecer conexões com banco de dados, registrar requisições em log, tratar erros, validar tokens CSRF, configurar cabeçalhos de resposta, etc. Essa duplicação viola o DRY e dificulta a adição de novos comportamentos globais — seria necessário modificar todos os controllers existentes.

O Front Controller resolve isso introduzindo um único ponto de entrada para todas as requisições. Cada requisição HTTP passa primeiro pelo Front Controller, que executa a lógica comum (verificações de segurança, logging, configuração de transação), determina qual handler específico deve processar a requisição (via roteamento ou command), despacha para esse handler e então executa o processamento pós-handler (limpeza, formatação da resposta).

Por exemplo, um Front Controller pode: (1) verificar se o usuário está autenticado, (2) iniciar a transação do banco de dados, (3) analisar a URL para determinar que `ProductController.show(id=123)` deve ser invocado, (4) chamar o handler, (5) confirmar a transação, (6) adicionar cabeçalhos de segurança à resposta, (7) registrar a requisição. Toda essa infraestrutura é escrita uma única vez e se aplica a todas as requisições, mantendo os handlers individuais limpos e focados na lógica específica.

---

## Aplicabilidade

Use Front Controller quando:

- A aplicação tiver comportamento significativo que deve ser executado em todas (ou na maioria das) requisições
- For necessário centralizar decisões de roteamento e despacho baseadas em regras complexas
- Múltiplos protocolos ou formatos de requisição precisarem ser suportados (HTTP, SOAP, GraphQL)
- A aplicação for grande o suficiente para que a duplicação de código entre Page Controllers seja um problema significativo
- Você quiser implementar cross-cutting concerns (logging, segurança, transações) de forma consistente
- A estrutura de navegação for complexa e se beneficiar de uma lógica de roteamento centralizada

---

## Estrutura

```
┌──────────────────────────────────────────────────────────────┐
│                    Cliente (Browser/API)                     │
│  Todas as requisições HTTP: /*, /api/*, /admin/*             │
└────────────────────────────┬─────────────────────────────────┘
                             │ TODO o tráfego
                             │
                ┌────────────▼────────────┐
                │   Front Controller      │
                │  (DispatcherServlet)    │
                │ ─────────────────────   │
                │ 1. Autentica usuário    │
                │ 2. Inicia transação     │
                │ 3. Analisa requisição   │
                │ 4. Roteia para handler  │
                │ 5. Despacha             │
                │ 6. Trata erros          │
                │ 7. Formata resposta     │
                │ 8. Registra requisição  │
                └────────────┬────────────┘
                             │ despacha para
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼──────────┐ ┌─────▼────────────┐ ┌──▼──────────────┐
│ ProductCommand     │ │ LoginCommand     │ │ CheckoutCommand │
│ ───────────────    │ │ ───────────────  │ │───────────────  │
│ + execute(req)     │ │ + execute(req)   │ │ + execute(req)  │
│   - business logic │ │   - auth logic   │ │   - payment     │
│   - return view    │ │   - return redir │ │   - return view │
└────────────────────┘ └──────────────────┘ └─────────────────┘
          │                  │                  │
          │ usam             │                  │
          ▼                  ▼                  ▼
   ┌─────────────┐    ┌─────────────┐   ┌─────────────┐
   │ Model/Service│   │ Model/Service│  │ Model/Service│
   └─────────────┘    └─────────────┘   └─────────────┘

Fluxo:
Requisição → Front Controller (processamento comum) →
Despacho para handler específico → Execução do handler →
Retorno ao Front Controller → Geração da resposta
```

---

## Participantes

- [**Front Controller**](003_front-controller.md): Único objeto que recebe todas as requisições HTTP. Executa o processamento comum (pré-processamento) antes do despacho e o pós-processamento depois.

- **Router/Dispatcher**: Componente do Front Controller responsável por determinar qual handler deve processar cada requisição (com base na URL, método HTTP, headers, etc).

- **Command/Handler**: Objetos específicos que contêm a lógica para processar tipos particulares de requisições. Podem ser classes Command (padrão GoF Command) ou métodos de Page Controller.

- **Handler Registry**: Mapeamento (configuração ou código) de padrões de requisição para handlers. Ex.: `/products/*` → ProductCommand.

- **Interceptors/Filters**: Cadeia de Responsabilidade de objetos que processam a requisição antes (pré-interceptores) e depois (pós-interceptores) do handler principal.

- **View Resolver**: Componente que transforma o resultado retornado pelo handler em uma resposta concreta (HTML, JSON, redirect).

---

## Colaborações

Quando uma requisição chega (ex.: `GET /products/123`), o Front Controller é invocado primeiro. Ele executa o pré-processamento: verifica autenticação, estabelece transação, analisa os headers. Em seguida, consulta o Router, que determina, com base na URL, que `ProductCommand` deve ser invocado.

O Front Controller despacha para ProductCommand.execute(request), passando o objeto de requisição. O Command executa a lógica específica (carrega o produto) e retorna um resultado (ex.: nome da view "productDetails" + dados do model).

O Front Controller retoma o controle, executa o pós-processamento (confirma transação, adiciona cabeçalhos CORS), invoca o View Resolver para transformar o resultado em resposta HTTP e a retorna ao cliente. Se ocorrer um erro em qualquer ponto, o Front Controller o captura e renderiza a página de erro apropriada.

---

## Consequências

### Vantagens

1. **Eliminação de Duplicação**: A lógica comum (auth, logging, transações) é escrita uma única vez no Front Controller.
2. **Cross-Cutting Concerns Centralizados**: Segurança, logging, tratamento de erros, CORS — tudo em um único lugar.
3. **Roteamento Sofisticado**: Lógica de roteamento complexa (negociação de conteúdo, versionamento, locale) centralizada e testável.
4. **Fácil Adição de Comportamentos Globais**: Adicionar um novo interceptor afeta todas as requisições sem tocar nos handlers individuais.
5. **Testabilidade da Infraestrutura**: O pré/pós-processamento pode ser testado independentemente dos handlers.
6. **Consistência**: Garante que toda requisição passe pelo mesmo pipeline de processamento.

### Desvantagens

1. **Ponto Único de Falha**: Se o Front Controller falhar, toda a aplicação falha. Exige implementação robusta.
2. **Complexidade Adicional**: Adiciona uma camada de indireção — pode ser excessivo para aplicações pequenas.
3. **Depuração Mais Difícil**: O fluxo da requisição cruza múltiplas camadas (interceptores, dispatcher, handler), tornando o rastreamento difícil.
4. **Sobrecarga de Desempenho**: Cada requisição passa por todos os interceptores, mesmo que não seja necessário para aquela requisição específica.
5. **Curva de Aprendizado**: Os desenvolvedores precisam entender a arquitetura de despacho e a cadeia de responsabilidade.

---

## Implementação

### Considerações de Implementação

1. **Integração com Servidor Web**: Em Java, implemente como Servlet. Em Node, como middleware Express. Em Python, como middleware WSGI/ASGI.

2. **Estratégia de Roteamento**: Decida entre roteamento baseado em configuração (XML, anotações) vs baseado em código (tabelas de rotas programáticas).

3. **Command vs Controller**: Os handlers podem ser Commands puros (padrão Command) ou métodos de Controller (híbrido com Page Controller).

4. **Cadeia de Interceptores**: Implemente a Cadeia de Responsabilidade para pré/pós-processamento. Permita que interceptores sejam registrados dinamicamente.

5. **Tratamento de Exceções**: O Front Controller deve capturar todas as exceções e renderizar respostas de erro apropriadas (400, 500).

6. **Abstração de Requisição/Resposta**: Encapsule objetos HTTP nativos (ServletRequest, Express req) em abstrações para facilitar os testes.

### Técnicas de Implementação

1. **Padrão Dispatcher Servlet**: Use servlet/middleware que receba todas as requisições e as despache com base em mapeamento.

2. **Correspondência de Padrão de URL**: Use regex ou templates de caminho (`/products/:id`) para mapear URLs para handlers.

3. **Cadeia de Responsabilidade**: Implemente interceptores/filters como cadeia onde cada um pode processar e passar para o próximo ou curto-circuitar.

4. **Command Registry**: Mantenha um Map de padrões de URL para classes Command, permitindo registro dinâmico.

5. **Estratégia View Resolver**: Use o padrão Strategy para diferentes view resolvers (JSP, Thymeleaf, JSON API, etc).

6. **Contexto Thread-Local**: Use armazenamento thread-local para guardar o contexto da requisição acessível por todos os handlers.

---

## Usos Conhecidos

1. **Spring DispatcherServlet**: Front Controller do Spring MVC que centraliza o tratamento de requisições e despacha para beans @Controller.

2. **Java Servlet Filters**: Arquitetura da Servlet API onde o FilterChain processa requisições antes de atingir o servlet final.

3. **Struts ActionServlet**: Antigo framework Java EE onde o ActionServlet era o Front Controller que despachava para classes Action.

4. **ASP.NET Core Middleware Pipeline**: Toda requisição passa pelo pipeline de middleware antes de atingir o Controller.

5. **Express.js App**: Em Node, `app.use()` constrói a cadeia de middleware que funciona como um Front Controller distribuído.

6. **Django Middleware**: Sistema de middleware que processa requisições/respostas globalmente antes/depois das views.

---

## Padrões Relacionados

- [**Page Controller**](002_page-controller.md): Os handlers invocados pelo Front Controller podem ser Page Controllers.
- [**Application Controller**](054_application-controller.md): Pode trabalhar com o Front Controller para gerenciar o fluxo de navegação.
- [**GoF Command**](../../gof/behavioral/002_command.md): Os handlers podem ser implementados como Commands que o Front Controller executa.
- [**GoF Chain of Responsibility**](../../gof/behavioral/001_chain-of-responsibility.md): Os Interceptors/Filters formam uma cadeia que processa as requisições.
- [**GoF Template Method**](../../gof/behavioral/010_template-method.md): O Front Controller pode usar Template Method para definir o esqueleto de processamento.
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): View Resolver e Router podem ser Strategies plugáveis.
- **Intercepting Filter** (J2EE): Padrão relacionado onde filtros interceptam requisições antes de atingir o controller.

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): ponto único de entrada
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): handlers plugáveis

---

## Relação com Regras de Negócio

- **[021] Prohibition of Logic Duplication**: O Front Controller elimina a duplicação de lógica comum entre os handlers.
- **[010] Single Responsibility Principle**: O Front Controller tem a única responsabilidade de coordenar o processamento das requisições.
- **[014] Dependency Inversion Principle**: Os handlers dependem de abstrações (Request, Response), não de detalhes HTTP.
- **[030] Prohibition of Unsafe Functions**: Verificações de segurança centralizadas no Front Controller previnem vulnerabilidades de forma consistente.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
