# Factor 05 — Build, Release, Run

**Rule deMGoncalves:** [044 - Separação Build, Release, Run](../../../rules/044_separacao-build-release-run.md)
**Pergunta:** Três estágios separados e imutáveis (Build → Release → Run)?

## O que é

O processo de deploy deve ser separado em três estágios distintos e imutáveis:

- **Build**: compila o código + dependências → artefato executável
- **Release**: Build + Config → release imutável com ID único
- **Run**: executa o release em ambiente de execução

**Cada release é imutável — correções exigem novo release.**

## Critério de Conformidade

- [ ] Estágio **Build** produz artefato executável sem dependências de configuração de ambiente
- [ ] Estágio **Release** é imutável — correções exigem novo release com novo ID
- [ ] Todo release tem **identificador único** (timestamp, hash, número sequencial)

## ❌ Violação

```bash
# Build + Run misturados ❌
ssh prod-server
cd /app
git pull origin main  # mudança direta em prod
npm install
npm start

# Release mutável ❌
# Alterar código em release já deployado
vim /app/src/config.js  # violação
```

## ✅ Correto

```bash
# CI/CD Pipeline com 3 estágios separados ✅

# 1. Build (CI)
npm run build
# → Output: dist/bundle.js

# 2. Release (CI + Deploy)
docker build -t myapp:v1.2.3 .  # Build
docker tag myapp:v1.2.3 myapp:release-456  # Release ID
docker push myapp:release-456

# 3. Run (Prod)
kubectl set image deployment/myapp app=myapp:release-456
# Release imutável — rollback = deploy release anterior
```

## Codetag quando violado

```typescript
// FIXME: Config sendo alterada em runtime — deveria ser em release stage
if (process.env.NODE_ENV === 'production') {
  config.apiUrl = 'https://api.prod.com';  // violação
}
```
