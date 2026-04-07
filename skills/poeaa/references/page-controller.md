# Page Controller

**Layer:** Web Presentation
**Complexity:** Simple
**Intent:** An object that handles a request for a specific page or action on a website.

---

## When to Use

- Simple applications with few well-defined endpoints
- When each page/endpoint has sufficiently distinct logic
- Prototypes and MVPs where speed matters more than architecture
- Complement to Front Controller for specific page handlers

## When NOT to Use

- When cross-cutting logic (auth, logging) needs to be centralized (use Front Controller)
- When endpoints have a lot of common logic that would cause duplication (rule 021)

## Minimal Structure (TypeScript)

```typescript
// Page Controller: handles a single page or resource
class UserListPageController {
  constructor(private readonly userRepository: UserRepository) {}

  // Each method corresponds to an HTTP verb for this resource
  async handleGet(request: Request, response: Response): Promise<void> {
    const users = await this.userRepository.findAll()
    response.json(users.map(u => ({ id: u.id, name: u.name })))
  }

  async handlePost(request: Request, response: Response): Promise<void> {
    const user = User.create(request.body.name, request.body.email)
    await this.userRepository.save(user)
    response.status(201).json({ id: user.id })
  }
}

class UserDetailPageController {
  constructor(private readonly userRepository: UserRepository) {}

  async handleGet(request: Request, response: Response): Promise<void> {
    const user = await this.userRepository.findById(request.params.id)
    if (!user) { response.status(404).json({ error: 'Not found' }); return }
    response.json({ id: user.id, name: user.name, email: user.email })
  }
}
```

## Related

- [front-controller.md](front-controller.md): complements — Front Controller dispatches to specific Page Controllers
- [mvc.md](mvc.md): depends — Page Controller implements the Controller role within MVC architecture

---

**PoEAA Layer:** Web Presentation
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
