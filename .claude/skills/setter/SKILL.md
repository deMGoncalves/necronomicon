---
name: setter
description: Convenção para uso de setters para tratamento de escrita de valores. Use ao criar setters que precisam validar entrada, sincronizar estado interno ou acionar efeitos colaterais — ao revisar setters que são meras atribuições.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Setter

Convenção para uso de setters para tratamento de escrita de valores associados a membros privados.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar setters que precisam validar entrada, sincronizar estado interno ou acionar efeitos de re-renderização; ao revisar setters que são meras atribuições sem lógica |
| **Prerequisites** | Skill `getter` (par obrigatório); skill `render` (decorators `repaint`/`retouch`); rule 008 (proibição de getters/setters puros) |
| **Constraints** | Setter sem lógica de tratamento viola rule 008; operações assíncronas são proibidas em setters; validações complexas devem estar em métodos de negócio, não no setter |
| **Scope** | Padrões de implementação de setters com decorators `attributeChanged`, `retouch` e `repaint`; relação obrigatória com membros privados (`#`) |

---

## Quando Usar

Use ao criar setters que precisam tratar a escrita de valor, sempre associados a membros privados.

## Propósito

| Responsabilidade | Descrição |
|------------------|-----------|
| Atribuição simples | Atribuir valor ao membro privado correspondente |
| Sincronização de atributo | Sincronizar valor com atributo HTML usando decorator |
| Acionamento de re-renderização | Acionar re-renderização parcial ou completa do componente |
| Validação de escrita | Aplicar transformação ou normalização antes de atribuir |

## Padrões de Implementação

| Padrão | Uso |
|--------|-----|
| Atribuição direta | Atribuir valor recebido diretamente ao membro privado |
| Com re-renderização | Usar decorator para acionar atualização visual após escrita |
| Com sincronização | Usar decorator para manter atributo HTML sincronizado |
| Com transformação | Aplicar transformação simples antes de atribuir |

## Decorators Associados

| Decorator | Função |
|-----------|--------|
| attributeChanged | Sincroniza setter com mudança de atributo HTML |
| retouch | Aciona re-renderização parcial após mudança de valor |
| repaint | Aciona re-renderização completa após mudança de valor |

## Relação com Membros Privados

| Regra | Descrição |
|-------|-----------|
| Sempre privado | Setter deve modificar membro privado (prefixo `#`) |
| Nunca público | Setter não deve modificar propriedade pública |
| Um para um | Cada setter modifica um único membro privado |
| Nome correspondente | Nome do setter corresponde ao nome do membro privado |

## Exemplos

```typescript
// ❌ Ruim — setter trivial (viola rule 008)
set email(value: string) { this.#email = value }  // sem validação

// ✅ Bom — setter com validação e sincronização
set email(value: string) {
  if (!value.includes('@')) throw new InvalidEmailError(value)
  this.#email = value
  this.internals.states.add('email-validated')
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Setter puro sem lógica | Viola rule 008: setter deve ter lógica de tratamento (sincronização, re-renderização, transformação), não ser mera atribuição |
| Lógica de negócio complexa | Setters devem ter lógica simples de atribuição e transformação |
| Efeitos colaterais não relacionados | Setter não deve modificar outros estados além do membro alvo (rule 010) |
| Validação complexa | Validações complexas devem estar em métodos de negócio |
| Modificar múltiplos membros | Setter deve focar em um único membro privado (rule 010) |
| Operações assíncronas | Setters devem ser síncronos e previsíveis |

## Relação com Getter

| Aspecto | Descrição |
|---------|-----------|
| Par obrigatório | Setter deve ter getter correspondente para o mesmo membro |
| Ordem de declaração | Getter sempre antes do setter na anatomia da classe |
| Tipo consistente | Getter e setter do mesmo membro devem ter tipos compatíveis |

## Boas Práticas

| Prática | Descrição |
|---------|-----------|
| Atribuição simples | Setter foca em atribuir valor e acionar efeitos colaterais necessários |
| Decorators | Usar @attributeChanged, @retouch ou @repaint para sincronização |
| Transformação mínima | Aplicar apenas transformações simples e diretas |
| Setter com getter | Sempre ter getter correspondente para o mesmo membro privado |

## Justificativa

- [008 - Proibição de Getters/Setters Puros](../../rules/008_proibicao-getters-setters.md): setters são permitidos quando têm lógica de tratamento (sincronização de atributo, re-renderização, transformação), proibidos quando são meras atribuições diretas sem lógica
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): lógica de tratamento centralizada no setter mantém código previsível e fácil de manter
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): setter tem responsabilidade única de tratar escrita do membro privado correspondente
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): setter deve ter máximo 15 linhas, extrair lógica complexa para métodos
