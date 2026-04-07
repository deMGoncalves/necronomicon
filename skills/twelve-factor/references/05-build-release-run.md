# Factor 05 — Build, Release, Run

**deMGoncalves Rule:** [044 - Separation of Build, Release, Run](../../../rules/044_separacao-build-release-run.md)
**Question:** Three separate and immutable stages (Build → Release → Run)?

## What It Is

The deployment process must be separated into three distinct and immutable stages:

- **Build**: compiles code + dependencies → executable artifact
- **Release**: Build + Config → immutable release with unique ID
- **Run**: executes the release in runtime environment

**Each release is immutable — fixes require new release.**

## Compliance Criteria

- [ ] **Build** stage produces executable artifact without environment configuration dependencies
- [ ] **Release** stage is immutable — fixes require new release with new ID
- [ ] Every release has **unique identifier** (timestamp, hash, sequential number)

## ❌ Violation

```bash
# Build + Run mixed ❌
ssh prod-server
cd /app
git pull origin main  # direct change in prod
npm install
npm start

# Mutable release ❌
# Modify code in already deployed release
vim /app/src/config.js  # violation
```

## ✅ Good

```bash
# CI/CD Pipeline with 3 separate stages ✅

# 1. Build (CI)
npm run build
# → Output: dist/bundle.js

# 2. Release (CI + Deploy)
docker build -t myapp:v1.2.3 .  # Build
docker tag myapp:v1.2.3 myapp:release-456  # Release ID
docker push myapp:release-456

# 3. Run (Prod)
kubectl set image deployment/myapp app=myapp:release-456
# Immutable release — rollback = deploy previous release
```

## Codetag when violated

```typescript
// FIXME: Config being changed at runtime — should be in release stage
if (process.env.NODE_ENV === 'production') {
  config.apiUrl = 'https://api.prod.com';  # violation
}
```
