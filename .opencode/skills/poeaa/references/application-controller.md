# Application Controller

**Camada:** Web Presentation
**Complexidade:** Complexa
**Intenção:** Ponto centralizado para lidar com a navegação da tela e o fluxo da aplicação.

---

## Quando Usar

- Aplicações com fluxo de navegação complexo entre múltiplas telas/passos
- Wizards e formulários multi-step com regras de transição
- Quando diferentes usuários devem ver diferentes fluxos baseado em contexto
- Aplicações com lógica de "qual tela mostrar a seguir" complexa

## Quando NÃO Usar

- Aplicações simples com fluxo linear sem condicionais (use Page Controller)
- APIs REST sem estado de navegação (Front Controller é suficiente)
- Quando lógica de navegação pode ser expressa com roteamento simples

## Estrutura Mínima (TypeScript)

```typescript
// Application Controller: controla fluxo entre telas
class OnboardingController {
  // Determina próxima tela baseado no estado atual do usuário
  nextStep(user: User, currentStep: OnboardingStep): OnboardingStep {
    if (currentStep === OnboardingStep.WELCOME) {
      return OnboardingStep.PROFILE_SETUP
    }

    if (currentStep === OnboardingStep.PROFILE_SETUP) {
      return user.needsEmailVerification()
        ? OnboardingStep.EMAIL_VERIFICATION
        : OnboardingStep.COMPLETED
    }

    if (currentStep === OnboardingStep.EMAIL_VERIFICATION) {
      return OnboardingStep.COMPLETED
    }

    return OnboardingStep.COMPLETED
  }

  // Verifica se usuário pode acessar determinada tela
  canAccess(user: User, step: OnboardingStep): boolean {
    if (step === OnboardingStep.EMAIL_VERIFICATION) {
      return user.hasCompletedProfileSetup()
    }
    return true
  }

  // Retorna view correta para o passo atual
  getView(step: OnboardingStep): string {
    const views: Record<OnboardingStep, string> = {
      [OnboardingStep.WELCOME]: 'onboarding/welcome',
      [OnboardingStep.PROFILE_SETUP]: 'onboarding/profile',
      [OnboardingStep.EMAIL_VERIFICATION]: 'onboarding/verify-email',
      [OnboardingStep.COMPLETED]: 'onboarding/completed',
    }
    return views[step]
  }
}
```

## Relacionada com

- [front-controller.md](front-controller.md): depende — Application Controller determina o destino; Front Controller executa o despacho
- [page-controller.md](page-controller.md): complementa — Application Controller decide qual Page Controller ativar em cada passo do fluxo

---

**PoEAA Camada:** Web Presentation
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
