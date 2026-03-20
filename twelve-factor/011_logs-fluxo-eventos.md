# Logs como Fluxo de Eventos

**ID**: INFRASTRUCTURE-050
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

A aplicação deve tratar logs como um **fluxo contínuo de eventos** ordenados por tempo, escritos em `stdout`. A aplicação nunca deve se preocupar com roteamento, armazenamento ou rotação de logs — essa é a responsabilidade do ambiente de execução.

## Por que importa

Logs em arquivos locais são perdidos quando containers são destruídos, difíceis de agregar em sistemas distribuídos e criam dependência do sistema de arquivos. O stdout permite que o ambiente de execução capture, agregue e roteie logs para qualquer destino.

## Critérios Objetivos

- [ ] Todos os logs devem ser escritos em **stdout** (ou stderr para erros), nunca em arquivos locais.
- [ ] É proibido o uso de bibliotecas de logging que escrevem diretamente em arquivos ou fazem rotação de logs.
- [ ] Os logs devem ser estruturados (JSON) para facilitar o parsing e a análise automatizada.

## Exceções Permitidas

- **Ambiente de Desenvolvimento Local**: Formatação colorida e legível para console em dev, desde que o stdout seja mantido.
- **Logs de Debug Temporários**: `console.log` para depuração local, removido antes do commit.

## Como Detectar

### Manual

Verificar a configuração da biblioteca de logging para identificar escritas em arquivos ou configuração de rotação.

### Automático

Análise de código: Buscar configurações de `FileAppender`, `RotatingFileHandler` ou caminhos de arquivo no logging.

## Relacionado a

- [027 - Qualidade do Tratamento de Erros](../clean-code/qualidade-tratamento-erros-dominio.md): complementa
- [045 - Processos Stateless](../twelve-factor/006_processos-stateless.md): reforça
- [048 - Descartabilidade de Processos](../twelve-factor/009_descartabilidade-processos.md): complementa
- [026 - Qualidade de Comentários](../clean-code/qualidade-comentarios-porque.md): complementa

---

**Criado em**: 2025-01-10
**Versão**: 1.0
