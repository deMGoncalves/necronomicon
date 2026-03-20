# Model-View-Controller (MVC)

**Tipo**: Padrão de Apresentação Web

---

## Intenção e Objetivo

Separar a apresentação da interface e a interação do usuário da lógica de negócio subjacente, dividindo a aplicação em três componentes interconectados: Model (dados e lógica), View (apresentação) e Controller (gerenciamento de entrada e coordenação).

## Também Conhecido Como

- Model-View-Presenter (variação)
- Model-View-ViewModel (MVVM - variação moderna)
- Separated Presentation

---

## Motivação

As interfaces de usuário são notoriamente voláteis — os requisitos de apresentação mudam com frequência (novo design, nova plataforma, testes A/B). Se a lógica de apresentação estiver misturada com a lógica de negócio, cada mudança visual exige tocar em código de negócio crítico, aumentando o risco de bugs e dificultando a evolução independente.

O MVC resolve esse problema estabelecendo uma separação clara de responsabilidades. O Model encapsula os dados do domínio e a lógica de negócio, completamente independente de como será apresentado. A View é responsável por renderizar a interface visual, consumindo dados do Model mas não contendo lógica de negócio. O Controller media entre eles: recebe a entrada do usuário (cliques, envios de formulários), invoca operações no Model e seleciona a View apropriada para apresentar os resultados.

Por exemplo, em um e-commerce, o ProductModel contém a lógica de cálculo de preços e validação de estoque. A ProductView renderiza o HTML exibindo o produto. O ProductController recebe a requisição HTTP "GET /product/123", carrega o produto via Model e passa-o à View que gera o HTML. Se amanhã for necessária uma API JSON, cria-se uma nova View (JSONView) sem tocar no Model ou no Controller. A separação permite evolução independente e reuso.

---

## Aplicabilidade

Use MVC quando:

- A aplicação tiver uma interface de usuário (web, desktop, mobile) que precisa ser desacoplada da lógica de negócio
- Múltiplas views/representações diferentes precisarem ser fornecidas para os mesmos dados (HTML, JSON, XML, PDF)
- A interface puder mudar com frequência (redesigns, novos recursos visuais) sem afetar a lógica de negócio
- Desenvolvedores diferentes trabalharem na apresentação e na lógica de negócio de forma independente
- Você quiser testabilidade — Models podem ser testados sem UI, Views podem ser testadas com dados simulados
- A aplicação for complexa o suficiente para justificar a separação de responsabilidades (não apenas uma página estática simples)

---

## Estrutura

```
┌──────────────────────────────────────────────────────────────┐
│                          Browser                             │
│  Usuário clica no botão → Requisição HTTP: POST /checkout    │
└────────────────────────────┬─────────────────────────────────┘
                             │ HTTP
                ┌────────────▼────────────┐
                │      Controller         │
                │  (CheckoutController)   │
                │ ─────────────────────   │
                │ + handleRequest(req)    │
                │ + processCheckout()     │
                │ + selectView(): View    │
                └───────┬────────┬────────┘
                        │        │
                invoca  │        │ usa
                        │        │
         ┌──────────────▼──┐  ┌──▼──────────────┐
         │     Model       │  │      View       │
         │  (OrderModel)   │  │ (CheckoutView)  │
         │ ──────────────  │  │ ──────────────  │
         │ + calculateTax()│  │ + render(model) │
         │ + applyDiscount │  │ + toHTML()      │
         │ + validateStock │  │                 │
         └─────────────────┘  └──────────────────┘
                │ notifica (Observer)
                ▼
         ┌─────────────────┐
         │  View (atualiz.) │
         │  Auto-refresh   │
         └─────────────────┘

Fluxo:
1. Usuário → Controller (entrada)
2. Controller → Model (operação de negócio)
3. Model → Controller (resultado)
4. Controller → View (seleciona e passa dados)
5. View → Usuário (resposta HTML)
```

---

## Participantes

- **Model**: Encapsula os dados da aplicação e a lógica de negócio. É independente da interface de usuário. Notifica as Views (via Observer) quando seu estado muda.

- **View**: Renderiza a apresentação visual do Model. Lê dados do Model, mas não o modifica. Pode haver múltiplas Views para o mesmo Model (HTMLView, JSONView).

- **Controller**: Recebe a entrada do usuário, interpreta-a, invoca operações no Model e seleciona a View apropriada para apresentar a resposta.

- **Mecanismo Observer** (opcional): Permite que o Model notifique as Views sobre mudanças de estado para atualização automática (mais comum em UIs desktop/mobile do que em requisição-resposta web).

- **Router** (no contexto web): Mapeia URLs para Controllers específicos (ex.: `/products/:id` → ProductController).

---

## Colaborações

Quando o usuário interage (ex.: clica em "Adicionar ao Carrinho"), o Controller correspondente (CartController) recebe a requisição. Ele extrai os parâmetros (productId, quantity), invoca o método de negócio no Model (cart.addItem(productId, quantity)), que valida o estoque e calcula os totais.

Após a operação no Model, o Controller decide qual View usar (em aplicações web, tipicamente um template). Passa os dados necessários (objeto cart) para a View, que renderiza o HTML com os itens do carrinho. O HTML é retornado ao usuário como resposta HTTP.

Em aplicações desktop com Observer, quando o Model muda, ele notifica as Views registradas, que se atualizam automaticamente para refletir o novo estado. Na web (requisição-resposta), a View é renderizada uma vez por requisição.

---

## Consequências

### Vantagens

1. **Separação de Responsabilidades**: A lógica de negócio (Model) é completamente separada da apresentação (View) e do controle de fluxo (Controller).
2. **Reusabilidade do Model**: O mesmo Model pode ser usado por múltiplas Views (HTML web, API JSON, relatório PDF).
3. **Testabilidade**: Models podem ser testados isoladamente; Views podem ser testadas com dados simulados; Controllers testados com Models simulados.
4. **Manutenibilidade**: Mudanças na UI não afetam a lógica de negócio, e vice-versa.
5. **Desenvolvimento Paralelo**: Designers trabalham nas Views, desenvolvedores backend nos Models, sem conflitos.
6. **Flexibilidade de Apresentação**: Fácil adicionar novos formatos de saída (app mobile, CLI) sem alterar o Model.

### Desvantagens

1. **Complexidade Adicional**: Para aplicações simples, o MVC pode ser uma sobrecarga desnecessária.
2. **Curva de Aprendizado**: Novos desenvolvedores precisam entender as responsabilidades de cada camada.
3. **Fragmentação de Código**: A lógica de uma funcionalidade é distribuída por múltiplos arquivos (Model, View, Controller).
4. **Debate de Responsabilidades**: Onde colocar lógica de formatação? Validação de entrada? Pode gerar debates intermináveis.
5. **Sobrecarga de Desempenho**: Camadas adicionais podem adicionar latência (mitigável com otimizações).

---

## Implementação

### Considerações de Implementação

1. **Fat Models, Skinny Controllers**: Mantenha a lógica de negócio no Model; Controllers devem ser finos, apenas coordenando.

2. **Views Passivas**: Views não devem conter nenhuma lógica de negócio — apenas apresentação e loops/condicionais simples de renderização.

3. **Observer vs Requisição-Resposta**: Em desktop/mobile, implemente Observer para notificação. Em web requisição-resposta, dispense o Observer.

4. **Separação da Lógica de View**: Use templates (Mustache, Handlebars) ou componentes (React) para manter a lógica de View separada dos Controllers.

5. **Roteamento**: Implemente um Router que mapeie URLs/rotas para os Controllers apropriados (ex.: rotas Rails, rotas Express).

6. **Injeção de Dependência**: Injete Models nos Controllers para facilitar testes e desacoplamento.

### Técnicas de Implementação

1. **Template Engines**: Use engines (EJS, Pug, Razor) para Views — separe HTML da lógica de apresentação.

2. **Padrão Front Controller**: Combine MVC com Front Controller para centralizar o tratamento de requisições antes de distribuir aos Controllers.

3. **Action Methods**: Nos Controllers, crie métodos para cada ação (index, show, create, update, delete) — padrão RESTful.

4. **View Models/DTOs**: Crie objetos intermediários (ViewModels) que transformam Models de domínio em estruturas otimizadas para as Views.

5. **Lazy Loading de Views**: Carregue Views apenas quando necessário para economizar memória.

6. [**Service Layer**](../domain-logic/004_service-layer.md): Adicione uma Service Layer entre Controllers e Models para lógica de aplicação complexa (fluxos com múltiplos modelos).

---

## Usos Conhecidos

1. **Ruby on Rails**: Framework MVC clássico — Models (ActiveRecord), Views (templates ERB), Controllers (ActionController).

2. **ASP.NET MVC**: Framework Microsoft que implementa MVC para web com C# — Models (POCOs), Views (Razor), Controllers (ControllerBase).

3. **Django (Python)**: Usa MTV (Model-Template-View), que é essencialmente MVC com nomenclatura diferente.

4. **Spring MVC (Java)**: Framework Java para web com anotações (@Controller, @RequestMapping) mapeando URLs para métodos.

5. **Express.js**: Framework Node.js que permite estruturar manualmente o MVC (sem opinião) por meio de routers e middleware.

6. **Smalltalk-80**: Origem do padrão MVC — usado para interfaces desktop interativas.

---

## Padrões Relacionados

- [**Page Controller**](002_page-controller.md): Tipo específico de Controller — um Controller por página lógica.
- [**Front Controller**](003_front-controller.md): Centraliza o tratamento de requisições antes de distribuir para Controllers específicos.
- [**Template View**](../twelve-factor/012_template-view.md): Estratégia de implementação de View usando templates.
- [**Application Controller**](054_application-controller.md): Gerencia o fluxo de navegação entre views/páginas.
- [**GoF Observer**](../../gof/behavioral/007_observer.md): Usado para o Model notificar Views sobre mudanças (MVC desktop/mobile).
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Views podem ser diferentes estratégias para apresentar o mesmo Model.
- [**Service Layer**](../domain-logic/004_service-layer.md): Fica entre Controllers e Domain Model para lógica de aplicação.

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar responsabilidades do MVC
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): controller coordena ações

---

## Relação com Regras de Negócio

- **[010] Single Responsibility Principle**: Cada componente (M, V, C) tem uma única responsabilidade bem definida.
- **[022] Prioritization of Simplicity and Clarity**: A separação torna cada componente mais simples e fácil de entender isoladamente.
- **[014] Dependency Inversion Principle**: Controllers e Views dependem de abstrações do Model, não de implementações concretas.
- **[032] Minimum Test Coverage**: A separação facilita os testes — Models podem ter cobertura >85% sem UI.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
