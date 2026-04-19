---
name: getter
description: Convenção para uso de getters para tratamento de leitura de valores. Use ao criar getters que precisam transformar, validar ou formatar dados antes de expor — ao revisar getters que retornam valores brutos sem lógica.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Getter

Convenção para uso de getters para tratamento de leitura de valores associados a membros privados.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Criação de getters que precisam aplicar valor padrão, transformação, formatação ou inicialização lazy a um membro privado (`#`) |
| **Prerequisites** | Skill `anatomy` para posicionamento do getter na classe (grupo 2); membro privado correspondente já declarado (grupo 1) |
| **Constraints** | Getter puro sem lógica é proibido (rule 008); getter não deve ter efeitos colaterais nem modificar estado; getter acessa apenas um membro privado |
| **Scope** | Padrões de implementação (null coalescing `??=`, transformação condicional, inicialização lazy); relação obrigatória com membro privado; limite de 15 linhas |

---

## Quando Usar

Use ao criar getters que precisam tratar leitura de valores, sempre associados a membros privados.

## Propósito

| Responsabilidade | Descrição |
|------------------|-------------|
| Valor padrão | Atribuir valor padrão quando membro privado é null ou undefined |
| Transformação | Aplicar transformação ou formatação ao valor lido |
| Inicialização lazy | Criar instância apenas quando primeiro acessado |
| Validação de leitura | Retornar valor alternativo baseado em condições |

## Padrões de Implementação

| Padrão | Uso |
|--------|-----|
| Null coalescing | Atribuir valor padrão usando operador `??=` |
| Retorno direto | Retornar valor sem transformação quando não há padrão |
| Transformação condicional | Aplicar transformação baseada em condição do valor |
| Inicialização lazy | Criar instância complexa apenas no primeiro acesso |

## Relação com Membros Privados

| Regra | Descrição |
|-------|-------------|
| Sempre privado | Getter deve acessar membro privado (prefixo `#`) |
| Nunca público | Getter não deve ler propriedade pública |
| Um para um | Cada getter acessa um único membro privado |
| Nome correspondente | Nome do getter corresponde ao nome do membro privado |

## Exemplos

```typescript
// ❌ Bad — getter trivial sem lógica (deveria ser propriedade)
get name() { return this.#name }  // apenas retorna, sem transformação

// ✅ Good — getter com lógica de transformação
get displayName() {
  return this.#name?.trim().toLowerCase() ?? 'anonymous'
}

get isValid() {
  return this.#email.includes('@') && this.#name.length > 0
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Getter puro sem lógica | Viola rule 008: getter deve ter lógica de tratamento, não ser mero accessor |
| Lógica complexa | Getters devem ter lógica simples e previsível |
| Efeitos colaterais | Getter não deve modificar estado ou disparar ações |
| Operações caras | Evitar operações pesadas que tornam leitura lenta |
| Acesso a múltiplos membros | Getter deve focar em um único membro privado (rule 010) |

## Melhores Práticas

| Prática | Descrição |
|---------|-------------|
| Null coalescing | Usar `??=` para atribuir valor padrão de forma concisa |
| Retorno direto | Retornar valor sem transformação quando não há lógica adicional |
| Inicialização lazy | Criar instâncias complexas apenas no primeiro acesso |
| Getter com setter | Sempre ter setter correspondente para o mesmo membro privado |

## Justificativa

- [008 - Proibição de Getters/Setters Puros](../../rules/008_proibicao-getters-setters.md): getters são permitidos quando têm lógica de tratamento (valor padrão, transformação, inicialização lazy), proibidos quando são meros accessors diretos sem lógica
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): lógica de tratamento centralizada no getter mantém código previsível e fácil de manter
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): getter tem responsabilidade única de tratar leitura do membro privado correspondente
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): getter deve ter máximo 15 linhas, extrair lógica complexa para métodos
