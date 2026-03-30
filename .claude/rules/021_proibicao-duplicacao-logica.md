# Proibição da Duplicação de Lógica (Princípio DRY)

**ID**: ESTRUTURAL-021
**Severidade**: 🔴 Crítica
**Categoria**: Estrutural

---

## O que é

Exige que cada peça de conhecimento tenha uma representação única, não ambígua e autoritativa dentro do sistema. Proíbe a duplicação de lógica ou código funcionalmente idêntico.

*(Previne o anti-pattern Cut-and-Paste Programming: reutilização de código por cópia em vez de abstração, criando N fontes de verdade que divergem com o tempo.)*

## Por que importa

A duplicação cria um débito técnico severo, pois uma alteração exige a modificação de N outros trechos duplicados, aumentando o risco de bugs de regressão e o custo de manutenção exponencialmente.

## Critérios Objetivos

- [ ] É proibida a cópia direta de blocos de código com mais de **5** linhas entre classes ou métodos.
- [ ] Lógica complexa usada em mais de **2** locais deve ser extraída para uma função ou classe reutilizável.
- [ ] O reuso deve ser feito via abstração (função, classe, interface) e não via *copy-paste*.

## Exceções Permitidas

- **Configurações de Baixo Nível**: Pequenas repetições em arquivos de configuração ou DTOs puramente estruturais.
- **Testes Unitários**: Configuração de *fixtures* ou *setups* para cenários de teste específicos.

## Como Detectar

### Manual

Busca por trechos de código que parecem idênticos, mas têm pequenas variações (duplicação sutil).

### Automático

SonarQube/ESLint: `no-duplicated-code` (com análise semântica).

## Relacionada com

- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): complementa
- [040 - Base de Código Única](040_base-codigo-unica.md): complementa
- [058 - Proibição de Shotgun Surgery](058_proibicao-shotgun-surgery.md): reforça

---

**Criada em**: 2025-10-08
**Versão**: 1.0
