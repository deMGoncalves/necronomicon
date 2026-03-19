# Portability (Portabilidade)

**Dimensão**: Transição
**Severidade Default**: 🟡 Suggestion

---

## Pergunta Chave

**Pode ser executado em outro ambiente?**

## Definição

O esforço necessário para transferir o software de um ambiente de hardware/software para outro. Alta portabilidade significa que a aplicação pode rodar em diferentes sistemas operacionais, navegadores ou infraestruturas cloud com mínima ou nenhuma modificação.

## Critérios de Verificação

- [ ] Configurações via variáveis de ambiente
- [ ] Sem dependência de paths absolutos do sistema
- [ ] Sem código específico de plataforma hardcoded
- [ ] Containers/virtualização para isolamento
- [ ] Abstração de serviços externos
- [ ] Build reproduzível em qualquer máquina

## Indicadores de Problema

### Exemplo 1: Paths Absolutos

```javascript
// ❌ Não portável - path específico de sistema
const configPath = '/home/user/app/config.json';
const tempDir = 'C:\\Users\\Admin\\Temp';

// ✅ Portável - paths relativos ou via ambiente
const configPath = path.join(process.cwd(), 'config.json');
const tempDir = process.env.TEMP_DIR || os.tmpdir();
```

### Exemplo 2: Código Específico de Plataforma

```javascript
// ❌ Não portável - assume Linux
function clearScreen() {
  process.stdout.write('\x1Bc'); // Escape code específico
}

function openFile(filepath) {
  exec(`xdg-open ${filepath}`); // Comando Linux
}

// ✅ Portável - abstrai plataforma
function clearScreen() {
  console.clear(); // Cross-platform
}

function openFile(filepath) {
  const opener = {
    darwin: 'open',
    win32: 'start',
    linux: 'xdg-open'
  }[process.platform];
  exec(`${opener} "${filepath}"`);
}
```

### Exemplo 3: Dependência de Serviço Específico

```javascript
// ❌ Não portável - acoplado a serviço específico
class StorageService {
  async upload(file) {
    const s3 = new AWS.S3({
      region: 'us-east-1',
      bucket: 'my-bucket'
    });
    return s3.upload(file);
  }
}

// ✅ Portável - abstração de storage
class StorageService {
  constructor(storageProvider) {
    this.provider = storageProvider;
  }

  async upload(file) {
    return this.provider.upload(file);
  }
}

// Pode usar S3, GCS, Azure Blob, ou local filesystem
new StorageService(new S3Provider(config));
new StorageService(new LocalFileProvider());
```

### Exemplo 4: Line Endings e Encoding

```javascript
// ❌ Não portável - assume line ending Unix
const lines = content.split('\n');
const output = lines.join('\n');

// ✅ Portável - trata diferentes line endings
const lines = content.split(/\r?\n/);
const output = lines.join(os.EOL);

// Ou usar biblioteca que abstraia isso
import { EOL } from 'os';
```

### Exemplo 5: Browser-Specific Code

```javascript
// ❌ Não portável - código específico de Chrome
function copyToClipboard(text) {
  document.execCommand('copy'); // Deprecated
}

function detectBrowser() {
  if (navigator.userAgent.includes('Chrome')) {
    // Código específico
  }
}

// ✅ Portável - APIs modernas cross-browser
async function copyToClipboard(text) {
  await navigator.clipboard.writeText(text);
}

// Feature detection em vez de browser detection
function supportsClipboard() {
  return 'clipboard' in navigator;
}
```

## Sinais de Alerta em Code Review

1. **Paths absolutos** começando com `/` ou `C:\`
2. **process.platform** com código específico sem fallback
3. **exec/spawn** com comandos shell específicos
4. **Import direto** de SDKs cloud específicos em lógica de negócio
5. **navigator.userAgent** para detecção de browser
6. **Line endings** hardcoded (`\n` ou `\r\n`)

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Path absoluto | Não roda em outras máquinas |
| Comando shell específico | Falha em outros OS |
| Serviço cloud específico | Lock-in de vendor |
| Browser-specific | Não funciona em todos browsers |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Path absoluto hardcoded | 🟠 Important |
| Vendor lock-in em serviço crítico | 🟠 Important |
| Comando shell sem fallback | 🟡 Suggestion |
| Line ending hardcoded | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// PORTABILITY: Path absoluto - usar variável de ambiente
// PORTABILITY: Comando específico de Linux

// TODO: Abstrair serviço de storage
// TODO: Implementar feature detection
```

## Exemplo de Comentário em Review

```
Este path absoluto no va a funcionar en otras máquinas:

const config = '/home/deploy/app/config.json'; // ❌

Mejor usar paths relativos o variables de ambiente:

const config = path.join(process.cwd(), 'config.json');
// o
const config = process.env.CONFIG_PATH || './config.json';

🟡 Sugerencia para portabilidad
```

## Rules Relacionadas

- [twelve-factor/003 - Config via Environment](../../twelve-factor/003_configuracoes-via-ambiente.md)
- [twelve-factor/002 - Dependencies](../../twelve-factor/002_declaracao-explicita-dependencias.md)

## Patterns Relacionados

- [gof/structural/001 - Adapter](../../gof/structural/001_adapter.md): para adaptar interfaces específicas
- [gof/structural/002 - Bridge](../../gof/structural/002_bridge.md): para separar abstração de implementação
- [poeaa/base/003 - Gateway](../../poeaa/base/003_gateway.md): para encapsular acesso a sistemas externos

---

**Criada em**: 2026-03-18
**Versão**: 1.0
