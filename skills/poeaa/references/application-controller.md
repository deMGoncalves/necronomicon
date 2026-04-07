# Application Controller

**Layer:** Web Presentation
**Complexity:** Complex
**Intent:** Centralized point to handle screen navigation and application flow.

---

## When to Use

- Applications with complex navigation flow between multiple screens/steps
- Wizards and multi-step forms with transition rules
- When different users should see different flows based on context
- Applications with complex "which screen to show next" logic

## When NOT to Use

- Simple applications with linear flow without conditionals (use Page Controller)
- Stateless REST APIs without navigation state (Front Controller is enough)
- When navigation logic can be expressed with simple routing

## Minimal Structure (TypeScript)

```typescript
// Application Controller: controls flow between screens
class OnboardingController {
  // Determines next screen based on user's current state
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

  // Checks if user can access a given screen
  canAccess(user: User, step: OnboardingStep): boolean {
    if (step === OnboardingStep.EMAIL_VERIFICATION) {
      return user.hasCompletedProfileSetup()
    }
    return true
  }

  // Returns correct view for current step
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

## Related

- [front-controller.md](front-controller.md): depends — Application Controller determines destination; Front Controller executes dispatch
- [page-controller.md](page-controller.md): complements — Application Controller decides which Page Controller to activate at each flow step

---

**PoEAA Layer:** Web Presentation
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
