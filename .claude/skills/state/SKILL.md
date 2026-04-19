---
name: state
description: Convenção para controle de estado em Web Components usando Element Internals API — ao criar estados gerenciáveis via internals.states em Web Components, implementar estados CSS customizados (:state()) ou revisar código que usa atributos para gerenciar estado
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# State

Convenção para controle de estado em Web Components usando Element Internals API com contratos Symbol para manipulação de estado customizado.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar estados gerenciáveis via `internals.states` em Web Components; ao implementar estados CSS customizados via pseudo-classe `:state()`; ao revisar código que usa atributos para gerenciar estado |
| **Prerequisites** | Skill `setter` (setters são o ponto de entrada do estado); skill `anatomy`; Element Internals API (`attachInternals`, `states.add/delete`); Symbol como contrato de interface |
| **Constraints** | Não usar `@retouch` ou `@repaint` em estados — estados usam `@around(contrato)` para sincronização com internals; não manipular `internals.states` diretamente no setter; cada método de contrato trata um único estado (rule 010) |
| **Scope** | Anatomia completa de estado em Web Component: membro privado, getter, setter, Symbol de contrato, método de contrato e getter de internals com inicialização lazy |

---

## Quando Usar

Use ao criar estados em Web Components que precisam ser gerenciáveis via atributos HTML, acessíveis via pseudo-classe CSS state, e sincronizados com Element Internals API.

## Propósito

| Responsabilidade | Descrição |
|------------------|-----------|
| Estado gerenciável | Expor estado customizado via Element Internals API para uso em CSS e JavaScript |
| Sincronização | Manter atributo HTML, propriedade JavaScript e internals.states sincronizados |
| Contrato claro | Usar Symbol para definir contrato de manipulação de estado |
| Middleware | Interceptar mudanças de estado via decorator para executar lógica adicional |

## Anatomia do Estado

| Componente | Função | Localização |
|------------|--------|-------------|
| Membro privado | Armazenar valor do estado | Campo privado na classe |
| Getter | Retornar valor do estado com default | Getter público correspondente |
| Setter | Atribuir novo valor ao estado | Setter público com decorators |
| Symbol de contrato | Definir interface de manipulação | arquivo interface.js |
| Método de contrato | Manipular internals.states | Método com notação de colchetes |
| Getter internals | Criar Element Internals | Getter com inicialização lazy |

## Fluxo de Execução

| Passo | Ação | Responsável |
|-------|------|-------------|
| 1 | Atributo HTML mudou ou propriedade foi setada | Browser ou JavaScript |
| 2 | Decorator attributeChanged dispara | Sistema de decorators |
| 3 | Setter executa e atribui valor | Setter da classe |
| 4 | Decorator around intercepta | Middleware |
| 5 | Método de contrato é chamado | Middleware via notação de colchetes |
| 6 | internals.states é atualizado | Método de contrato |
| 7 | Pseudo-classe CSS state reage | Browser |

## Decorators Associados

| Decorator | Função |
|-----------|--------|
| attributeChanged | Sincroniza setter com mudança de atributo HTML |
| around | Intercepta setter para executar método de contrato |

## Nomenclatura

| Elemento | Padrão | Exemplo |
|----------|--------|---------|
| Estado (atributo) | Particípio ou adjetivo | active, collapsed, disabled, visible |
| Symbol (contrato) | Estado + sufixo `-able` | activable, collapsible, disableable, visibilable |
| Membro privado | Hashtag + nome do estado | #active, #collapsed, #disabled |
| Getter | Nome do estado | active, collapsed, disabled |
| Setter | Nome do estado | active, collapsed, disabled |
| Método de contrato | Notação de colchetes com Symbol | [activable], [collapsible] |

## Relação com Internals

| Aspecto | Descrição |
|---------|-----------|
| Inicialização lazy | internals criado apenas no primeiro acesso para otimização |
| attachInternals | Chamado uma vez no getter usando null coalescing |
| states.add | Adiciona estado customizado quando valor é truthy |
| states.delete | Remove estado customizado quando valor é falsy |
| Acesso CSS | Estado acessível via pseudo-classe :state(nome) |

## Relação com Symbol

| Aspecto | Descrição |
|---------|-----------|
| Contrato explícito | Symbol define interface clara de manipulação de estado |
| Nome correlacionado | Symbol tem sufixo -able relacionado ao nome do estado |
| Notação de colchetes | Método usa Symbol entre colchetes para contrato privado |
| Import | Symbol exportado de interface.js e importado na classe |

## Exemplos

```typescript
// ❌ Ruim — estado via atributo (exposto, sem encapsulamento)
class MyInput extends HTMLElement {
  setValid() {
    this.setAttribute('data-valid', '')  // estado exposto no DOM
  }
}

// ✅ Bom — estado via Element Internals
class MyInput extends HTMLElement {
  #internals = this.attachInternals()

  setValid() {
    this.#internals.states.add('valid')  // estado encapsulado
    // CSS: my-input:state(valid) { ... }
  }
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Usar @retouch ou @repaint | Não re-renderiza, estados usam @around(contrato) para sincronização com internals |
| Setter sem contrato | Estado não sincroniza com internals.states, tornando-o inacessível via CSS |
| Nome sem correlação | Symbol deve ter sufixo -able correlacionado ao nome do estado para clareza |
| Múltiplos estados em método | Cada método de contrato trata um único estado (rule 010) |
| Lógica complexa em método | Método apenas adiciona ou remove estado, sem efeitos colaterais adicionais |
| Manipular internals.states no setter | Manipulação deve estar no método de contrato, não no setter |

## Boas Práticas

| Prática | Descrição |
|---------|-----------|
| Contrato Symbol | Sempre criar Symbol em interface.js para cada estado gerenciável |
| Decorator @around | Usar decorator para interceptar setter e chamar método de contrato |
| Operador ternário | Usar condição ternária para clareza na lógica add/delete |
| Retornar this | Sempre retornar this no método de contrato para interface fluente |
| Default booleano | Estados devem ter valor default false no getter |
| Internals lazy | Criar internals apenas no primeiro acesso usando null coalescing |

## Justificativa

- [008 - Proibição de Getters/Setters Puros](../../rules/008_proibicao-getters-setters.md): setter tem lógica de tratamento via middleware @around
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): padrão claro e previsível para controle de estado
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): método de contrato trata um único estado
- [009 - Diga, Não Pergunte](../../rules/009_diga-nao-pergunte.md): componente gerencia próprio estado internamente
- [036 - Restrição de Funções com Efeitos Colaterais](../../rules/036_restricao-funcoes-efeitos-colaterais.md): método de contrato apenas manipula internals.states
