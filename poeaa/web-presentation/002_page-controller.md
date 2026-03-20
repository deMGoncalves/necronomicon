# Page Controller

**Tipo**: Padrão de Apresentação Web

---

## Intenção e Objetivo

Criar um objeto que trata as requisições HTTP de uma página ou ação específica de um site, onde cada página lógica tem seu próprio handler dedicado que processa a entrada e coordena a geração da resposta.

## Também Conhecido Como

- Page Handler
- Action Handler
- Script-per-Page

---

## Motivação

Sites são compostos de múltiplas páginas, cada uma com sua própria lógica de processamento (ex.: página de login, página de checkout, página de perfil). Uma questão arquitetural fundamental é: como organizar o código que trata as requisições HTTP de cada página?

O Page Controller resolve isso com a abordagem mais simples possível: criar um controller dedicado para cada página lógica. Por exemplo, o `LoginController` trata todas as requisições relacionadas ao login (exibir formulário, validar credenciais), o `CheckoutController` trata o checkout, etc. Cada controller é responsável por extrair dados da requisição HTTP, invocar a lógica de negócio apropriada e selecionar a view para renderizar a resposta.

A vantagem está na simplicidade e intuitividade — os desenvolvedores entendem imediatamente que para adicionar uma nova página, basta criar um novo controller. O mapeamento entre URL e controller é direto (ex.: `/login` → LoginController, `/checkout` → CheckoutController). Não há camadas de indireção complexas. Isso torna o Page Controller ideal para sites de pequeno a médio porte onde cada página tem lógica relativamente independente. Porém, se houver muita lógica compartilhada entre páginas (autenticação, logging, transações), essa lógica tende a ser duplicada entre os controllers, levando à necessidade do Front Controller.

---

## Aplicabilidade

Use Page Controller quando:

- A aplicação web tiver um número moderado de páginas/ações (dezenas, não centenas)
- A lógica de cada página for relativamente independente, com pouco comportamento compartilhado
- A equipe valorizar a simplicidade e quiser evitar abstrações complexas
- A navegação entre páginas for direta, sem fluxos complexos de múltiplas etapas em wizard
- Você estiver usando um framework MVC tradicional onde controllers por recurso são a norma
- Não houver necessidade de lógica de roteamento centralizada sofisticada ou interceptação de requisições

---

## Estrutura

```
┌──────────────────────────────────────────────────────────────┐
│                   Navegador (Cliente)                        │
└────────────────────────────┬─────────────────────────────────┘
                             │ Requisições HTTP
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼──────────┐ ┌─────▼────────────┐ ┌──▼──────────────┐
│ GET /login         │ │ POST /login      │ │ GET /checkout   │
└─────────┬──────────┘ └─────┬────────────┘ └──┬──────────────┘
          │                  │                  │
          │ roteado para     │                  │
          │                  │                  │
┌─────────▼──────────┐ ┌─────▼────────────┐ ┌──▼──────────────┐
│ LoginController    │ │ LoginController  │ │CheckoutController│
│ ───────────────    │ │ ───────────────  │ │───────────────── │
│ + showLoginForm()  │ │ + authenticate() │ │+ showCart()      │
│   - get view       │ │   - validate     │ │  - load items    │
│   - render         │ │   - call service │ │  - calculate $   │
│                    │ │   - redirect     │ │  - render        │
└─────────┬──────────┘ └─────┬────────────┘ └──┬──────────────┘
          │                  │                  │
          │ usa              │                  │
          │                  │                  │
          ▼                  ▼                  ▼
   ┌─────────────┐    ┌─────────────┐   ┌─────────────┐
   │ Model Layer │    │ Model Layer │   │ Model Layer │
   │ (Services)  │    │ (Services)  │   │ (Services)  │
   └─────────────┘    └─────────────┘   └─────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
   ┌─────────────┐    ┌─────────────┐   ┌─────────────┐
   │ View/Template│   │ View/Template│  │ View/Template│
   │ login.html   │   │ dashboard.html│  │ checkout.html│
   └─────────────┘    └─────────────┘   └─────────────┘
```

---

## Participantes

- [**Page Controller**](002_page-controller.md) (`LoginController`, `CheckoutController`): Objeto ou classe que trata as requisições de uma página específica. Contém métodos (action methods) para diferentes operações na página (GET, POST, etc).

- **Router/Dispatcher**: Componente que mapeia as URLs recebidas para o Page Controller apropriado. Nos frameworks, isso é a configuração de rotas (ex.: rotas Express, rotas Rails).

- **Requisição/Resposta HTTP**: Objetos que encapsulam os dados da requisição HTTP (params, headers, body) e da resposta (status, headers, body).

- **Model/Service Layer**: Lógica de negócio invocada pelo controller para processar as operações. Os controllers delegam o trabalho efetivo para essa camada.

- **View/Template**: Responsável por renderizar a resposta visual (HTML) usando os dados preparados pelo controller.

---

## Colaborações

Quando uma requisição HTTP chega (ex.: `POST /login`), o Router identifica que ela deve ser tratada pelo LoginController e invoca o método apropriado (`authenticate()`). O controller extrai os dados da requisição (username, password do formulário POST), os valida e invoca o serviço de autenticação no Model.

Se a autenticação for bem-sucedida, o controller cria a sessão, prepara o contexto de dados (objeto user) e redireciona para o dashboard (`redirect("/dashboard")`). Se falhar, retorna à página de login com mensagem de erro, renderizando a view `login.html` com o contexto de erro.

Cada requisição para uma página diferente é tratada por um controller diferente — não há coordenação central sofisticada. Os controllers são independentes entre si.

---

## Consequências

### Vantagens

1. **Simplicidade**: Abordagem direta e fácil de entender — cada página tem seu handler.
2. **Baixa Curva de Aprendizado**: Novos desenvolvedores entendem rapidamente onde adicionar código para uma nova página.
3. **Isolamento**: Os controllers são independentes — mudanças em um raramente afetam os outros.
4. **Depuração Fácil**: O fluxo da requisição é linear — fácil de rastrear de URL → Controller → View.
5. **Estrutura Clara**: A organização do código por página reflete a estrutura do site, facilitando a navegação pelo código.
6. **Sem Overengineering**: Não introduz abstrações desnecessárias para sites de pequeno/médio porte.

### Desvantagens

1. **Duplicação de Código**: A lógica compartilhada (verificação de autenticação, logging, tratamento de erros) tende a ser duplicada entre os controllers.
2. **Escalabilidade Limitada**: Para sites com centenas de páginas, o número de controllers se torna ingerenciável.
3. **Difícil Interceptação Global**: Adicionar comportamento que deve ocorrer em todas as requisições (ex.: CORS, cabeçalhos de segurança) exige alterar todos os controllers.
4. **Sem Roteamento Sofisticado**: Lógica de roteamento complexa (ex.: negociação de conteúdo, versionamento) é difícil de implementar de forma consistente.
5. **Testabilidade Reduzida do Comportamento Comum**: O comportamento compartilhado duplicado precisa ser testado em múltiplos controllers.

---

## Implementação

### Considerações de Implementação

1. **Um Controller por Recurso**: Em REST, crie controllers por recurso (ProductController, OrderController), não por página individual (evita explosão de classes).

2. **Action Methods**: Dentro de cada controller, crie métodos para cada ação (index, show, create, update, delete) — padrão CRUD.

3. **Base Controller**: Crie uma classe AbstractController com funcionalidades comuns (render, redirect, tratamento de erros) que os Page Controllers herdam.

4. **Injeção de Dependência**: Injete serviços e repositories nos controllers via construtor para facilitar os testes.

5. **Convenção sobre Configuração**: Use convenções de nomenclatura para mapear URLs automaticamente (ex.: `/products/show` → ProductController.show()).

6. **Separação de GET e POST**: Use métodos diferentes para operações idempotentes (GET showForm) e mutativas (POST submitForm).

### Técnicas de Implementação

1. **Classe Única por Página**: Crie uma classe controller para cada página lógica com múltiplos métodos para diferentes ações.

2. **Script por Ação**: Alternativamente, crie arquivos de script separados para cada ação (login.php, logout.php) — estilo PHP clássico.

3. **Roteamento por Anotação**: Use anotações para mapear métodos a rotas (Spring: `@GetMapping("/login")`, decorators do Express).

4. **Cadeia de Middleware**: Implemente comportamento comum (auth, logging) como middleware que executa antes dos controllers.

5. **Métodos Auxiliares**: Extraia comportamento comum em métodos auxiliares privados dentro do controller ou em uma classe utilitária.

6. **Convenções RESTful**: Adote convenções REST para nomenclatura de métodos e URLs (index, show, store, update, destroy).

---

## Usos Conhecidos

1. **Ruby on Rails**: Framework MVC clássico onde cada recurso tem um controller com métodos de ação padrão (index, show, new, create, edit, update, destroy).

2. **ASP.NET MVC**: Controllers herdam de `ControllerBase` e contêm action methods decorados com `[HttpGet]`, `[HttpPost]`, etc.

3. **Spring MVC**: Usa `@Controller` e `@RequestMapping` para definir Page Controllers com métodos para diferentes métodos HTTP.

4. **Laravel (PHP)**: Framework que usa controllers para agrupar a lógica de requisição relacionada, com suporte a resource controllers.

5. **Express.js**: Embora permita Front Controller, muitas aplicações usam routers com handlers dedicados por rota (estilo Page Controller).

6. **Django Views**: Views baseadas em funções no Django são essencialmente Page Controllers — uma função por padrão de URL.

---

## Padrões Relacionados

- [**Front Controller**](003_front-controller.md): Alternativa que centraliza o tratamento de requisições em um único ponto antes do despacho.
- [**Application Controller**](054_application-controller.md): Gerencia a navegação e o fluxo entre páginas — complementa o Page Controller.
- [**Template View**](../twelve-factor/012_template-view.md): Page Controllers tipicamente usam Template Views para renderizar respostas.
- [**Transaction Script**](../domain-logic/001_transaction-script.md): Page Controllers frequentemente usam Transaction Scripts para lógica de negócio simples.
- [**Model-View-Controller**](001_model-view-controller.md): Page Controller é uma implementação específica do "C" no MVC.
- [**GoF Command**](../../gof/behavioral/002_command.md): Cada action method no Page Controller pode ser visto como um Command.
- [**Service Layer**](../domain-logic/004_service-layer.md): Page Controllers delegam a lógica de negócio à Service Layer.

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): controller por página
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar páginas sem modificar as existentes

---

## Relação com Regras de Negócio

- **[010] Single Responsibility Principle**: Cada Page Controller tem a única responsabilidade de tratar requisições de uma página/recurso específico.
- **[022] Prioritization of Simplicity and Clarity**: O Page Controller é a abordagem mais simples e clara para organizar o tratamento de requisições.
- **[021] Prohibition of Logic Duplication**: Exige disciplina para extrair código comum em classes base ou helpers.
- **[007] Maximum Lines per Class**: Controllers devem permanecer pequenos, delegando para Services.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
