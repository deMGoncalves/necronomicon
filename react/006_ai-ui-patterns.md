# AI UI Patterns

**Classificação**: Padrão de Design React para IA

---

## Intenção e Objetivo

Fornecer padrões arquiteturais e de implementação para construir interfaces de usuário que integram assistentes conversacionais de IA e Large Language Models (LLMs), focando em responsividade em tempo real, segurança e experiência do usuário otimizada.

## Também Conhecido Como

- Conversational AI Patterns
- LLM Integration Patterns
- Chat Interface Patterns

## Motivação

AI UI Patterns abordam desafios únicos de construir interfaces para IA conversacional e assistentes inteligentes. A ideia central envolve integrar serviços de IA backend (como API da OpenAI) com componentes React reativos para criar interações responsivas e em tempo real.

Elementos fundamentais incluem:
- **Gerenciamento de estado conversacional** através de histórico de mensagens
- **Streaming de respostas em tempo real** para feedback imediato do usuário
- **Arquitetura backend segura** para proteger API keys
- **Tratamento eficiente de input** para prevenir spam de API
- **Recuperação graceful de erros** para confiabilidade

## Aplicabilidade

Use AI UI Patterns quando:

- Construir chatbots ou interfaces conversacionais multi-turno
- Integrar APIs de LLM (OpenAI, Gemini, Anthropic)
- Requerer feedback em tempo real durante geração de IA
- Proteger credenciais sensíveis (API keys)
- Suportar IA agêntica com traces de raciocínio ou tool calls

## Estrutura

### Arquitetura Fundamental

```
Frontend (React)
├── Input Component (debounced)
├── Message List (auto-scroll)
├── Streaming Response Display
└── Error Handling UI

Backend (Next.js API Routes / Node.js)
├── API Route Handler
├── LLM Client Configuration
├── Message History Management
└── Error Handling & Retry Logic

External Services
└── LLM API (OpenAI, Anthropic, etc.)
```

## Padrões Principais

### 1. Gerenciamento de Prompts & Estado

Estruturar conversas como sequências de mensagens com papéis (user, assistant, system). Como observado, "uma interface de chat de IA típica consiste de um **frontend** (para input do usuário e exibição de respostas) e um **backend** (para chamar o modelo de IA)." Prompts de sistema estabelecem contexto, enquanto histórico de conversação fornece memória para interações multi-turno.

```javascript
const messages = [
  { role: 'system', content: 'You are a helpful assistant' },
  { role: 'user', content: 'Hello' },
  { role: 'assistant', content: 'Hi! How can I help?' }
];
```

### 2. Streaming de Respostas

Ao invés de esperar por respostas completas, implementar streaming token-por-token. Isso melhora dramaticamente a responsividade percebida já que "streaming permite exibir resultados parciais imediatamente" ao invés de forçar usuários a esperar por gerações longas.

```javascript
// Next.js API Route
export async function POST(req) {
  const stream = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: await req.json(),
    stream: true
  });

  return new StreamingTextResponse(stream);
}
```

### 3. Input Debounced

Para recursos de interação contínua como autocomplete, atrasar chamadas de API até que o usuário pause de digitar. Isso "previne uma enxurrada de chamadas para estados de input intermediários" enquanto mantém responsividade.

```javascript
const debouncedFetch = useMemo(
  () => debounce((value) => fetchAI(value), 500),
  []
);
```

### 4. Tratamento de Erros & Resiliência

Implementar padrões try/catch nos servidores, fornecer mensagens de erro voltadas ao usuário, e incluir mecanismos de retry. Tratar chamadas de IA como operações inerentemente incertas requerendo modos de falha graceful.

```javascript
try {
  const response = await openai.chat.completions.create(config);
  return response;
} catch (error) {
  console.error('AI API Error:', error);
  return { error: 'Failed to generate response. Please try again.' };
}
```

### 5. Arquitetura UI Baseada em Componentes

Separar componentes de apresentação (ChatMessage, InputBox) da lógica de data fetching. Isso habilita reutilização entre frameworks e facilita testes.

## Implementação Específica de Framework

### Vantagens do Next.js

- Rotas de API built-in (estrutura `app/api/`)
- Streaming nativo via `StreamingTextResponse`
- Deploy otimizado na Vercel
- Menor complexidade geral

### Abordagem Vite + Node

- Requer backend Express/Node separado
- Mais controle sobre arquitetura
- Maior complexidade de setup inicial
- Útil para aplicações React existentes

## Participantes

- **Frontend Components**: Componentes React para UI de chat
- **Backend API Routes**: Endpoints seguros que fazem proxy para APIs de LLM
- **LLM Service**: Serviço externo de IA (OpenAI, Anthropic, etc.)
- **Message State**: Gerenciamento de estado de histórico de conversação
- **Stream Handler**: Lógica para processar respostas streaming

## Colaborações

- Frontend envia mensagens do usuário para backend via POST
- Backend faz proxy de requests para API do LLM com credentials seguras
- LLM retorna response (streaming ou completo)
- Frontend atualiza UI com respostas conforme chegam
- Estado é mantido através de hooks ou gerenciamento de estado

## Consequências

### Vantagens

- **UX Superior**: Streaming é "crucial para melhor UX porque respostas geradas por modelo podem ser longas ou lentas"
- **Segurança**: Nunca expor API keys em código client-side
- **Controle de Custos**: Rate limiting e debouncing controlam consumo de quota de API
- **Manutenibilidade**: Separação clara de responsabilidades facilita testes e debugging

### Desvantagens

- **Complexidade**: Requer configuração de backend adicional
- **Gerenciamento de Estado**: Estado conversacional pode tornar-se complexo
- **Custos**: Chamadas de API de LLM podem ser custosas
- **Latência**: Dependente de performance da API externa

## Considerações de Implementação

### Performance

Streaming é "crucial para melhor UX porque respostas geradas por modelo podem ser longas ou lentas." Sempre priorizar isso para aplicações de chat.

### Segurança

Nunca expor API keys em código client-side. Rotear todas as requests de IA através de endpoints backend seguros.

### Gerenciamento de Custos

Implementar rate limiting e debouncing para controlar consumo de quota de API.

### Experiência do Usuário

Combinar indicadores visuais (animações de digitação), containers com auto-scroll, e mensagens de erro claras. Considerar biblioteca Vercel AI Elements para componentes production-ready fornecendo "auto-scrolling" e recursos de acessibilidade automaticamente.

### Arquitetura de Estado

Use hooks como `useChat` do Vercel AI SDK para gerenciamento de estado simplificado, ou implemente soluções customizadas baseadas em `useState` para mais controle.

## Uso Conhecido

- **ChatGPT Interface**: Interface de chat conversacional da OpenAI
- **Claude.ai**: Interface de chat da Anthropic
- **GitHub Copilot Chat**: Assistente de código conversacional
- **Perplexity**: Interface de busca com IA
- **Character.AI**: Plataforma de chatbot com personalidades

## Padrões Relacionados

- [**Hooks Pattern**](002_hooks-pattern.md): Base para gerenciamento de estado em AI UIs
- [**Server-side Rendering**](009_server-side-rendering.md): Útil para SEO em páginas de chat
- [**Streaming SSR**](013_streaming-ssr.md): Conceitos similares de streaming de conteúdo

### Relação com Rules

- [028 - Tratamento de Exceção Assíncrona](../../clean-code/008_tratamento-excecao-assincrona.md): crucial para robustez
- [030 - Proibição de Funções Inseguras](../../clean-code/010_proibicao-funcoes-inseguras.md): proteger API keys
- [042 - Configurações via Ambiente](../../twelve-factor/003_configuracoes-via-ambiente.md): gerenciar credenciais
- [050 - Logs como Fluxo de Eventos](../../twelve-factor/011_logs-fluxo-eventos.md): monitoring de interações com IA

## Bibliotecas e Ferramentas Recomendadas

- **Vercel AI SDK**: Hooks e utilities para integração com LLMs
- **LangChain**: Framework para aplicações com LLM
- **OpenAI SDK**: Cliente oficial para API da OpenAI
- **Anthropic SDK**: Cliente oficial para API do Claude
- **AI Elements**: Componentes UI production-ready da Vercel

---

**Criada em**: 2026-03-17
**Versão**: 1.0
