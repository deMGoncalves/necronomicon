# MVC (Model-View-Controller)

**Layer:** Web Presentation
**Complexity:** Moderate
**Intent:** Separate application into three components: Model (data and business logic), View (presentation), and Controller (coordination between Model and View).

---

## When to Use

- Any application with user interface
- When presentation logic should be separated from business logic
- To allow different Views to display the same data (e.g., HTML and JSON)
- Fundamental pattern in web frameworks (Express, Fastify, NestJS)

## When NOT to Use

- Never — MVC is suitable for any size web application
- In very simple applications it can be simplified, but the separation always pays off

## Minimal Structure (TypeScript)

```typescript
// Model: data and business rules
class UserModel {
  async findById(id: string): Promise<User | null> {
    return userRepository.findById(id)
  }

  async create(data: CreateUserDTO): Promise<User> {
    const user = User.create(data.name, data.email)
    await userRepository.save(user)
    return user
  }
}

// View: rendering (can be JSON for APIs)
class UserView {
  renderJSON(user: User): object {
    return { id: user.id, name: user.name, email: user.email }
  }

  renderHTML(user: User): string {
    return `<div class="user"><h1>${user.name}</h1><p>${user.email}</p></div>`
  }
}

// Controller: coordinates Model and View
class UserController {
  constructor(
    private readonly model: UserModel,
    private readonly view: UserView
  ) {}

  async show(request: Request, response: Response): Promise<void> {
    const user = await this.model.findById(request.params.id)
    if (!user) { response.status(404).json({ error: 'User not found' }); return }
    response.json(this.view.renderJSON(user))
  }
}
```

## Related

- [front-controller.md](front-controller.md): complements — Front Controller is the entry point that dispatches to MVC Controllers
- [page-controller.md](page-controller.md): complements — Page Controller is a simplified implementation of the Controller role in MVC
- [rule 010 - Single Responsibility Principle](../../../rules/010_principio-responsabilidade-unica.md): reinforces — clearly separates responsibilities of data, presentation and coordination

---

**PoEAA Layer:** Web Presentation
**Source:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
