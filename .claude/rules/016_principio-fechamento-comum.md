# Princípio do Fechamento Comum (CCP)

**ID**: ESTRUTURAL-016
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

As classes que mudam juntas pela mesma razão devem ser empacotadas juntas.

## Por que importa

O CCP reforça o SRP no nível de pacote, garantindo que as modificações de software sejam localizadas. Reduz a necessidade de alterar muitos pacotes em uma única alteração de requisito, facilitando a implantação e manutenção.

## Critérios Objetivos

- [ ] O pacote deve ser revisado se a alteração de um requisito causar modificações em mais de **3** arquivos de classes/módulos não relacionados.
- [ ] Classes relacionadas a uma única entidade de domínio (ex: `Pedido`, `PedidoService`, `PedidoFactory`) devem estar no mesmo pacote.
- [ ] Classes que mudam juntas devem ser localizadas em um mesmo diretório para facilitar a coesão.

## Exceções Permitidas

- **Classes de Infraestrutura Compartilhada**: Classes que são utilizadas em muitos pacotes e vivem em um pacote de utilidades de baixo nível.

## Como Detectar

### Manual

Analisar o histórico de commits: verificar se um único *feature request* afetou classes espalhadas por vários pacotes.

### Automático

Análise de métricas de código: ferramentas que rastreiam arquivos alterados por funcionalidade.

## Relacionada com

- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [015 - Princípio de Lançamento e Reuso](015_principio-equivalencia-lancamento-reuso.md): complementa
- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): reforça
- [017 - Princípio do Reuso Comum](017_principio-reuso-comum.md): complementa
- [058 - Proibição de Shotgun Surgery](058_proibicao-shotgun-surgery.md): reforça
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): complementa

---

**Criada em**: 2025-10-04
**Versão**: 1.0
