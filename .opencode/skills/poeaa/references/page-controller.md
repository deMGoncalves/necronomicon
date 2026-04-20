# Page Controller

**Camada:** Web Presentation
**Complexidade:** Simples
**Intenção:** Um objeto que lida com requisição para uma página específica ou ação em um website.

---

## Quando Usar

- Aplicações simples com poucos endpoints bem definidos
- Quando cada página/endpoint tem lógica suficientemente distinta
- Protótipos e MVPs onde velocidade importa mais que arquitetura
- Complemento ao Front Controller para handlers de página específica

## Quando NÃO Usar

- Quando lógica cross-cutting (auth, logging) precisa ser centralizada (use Front Controller)
- Quando os endpoints têm muita lógica em comum que causaria duplicação (rule 021)

## Estrutura Mínima (TypeScript)

```typescript
// Page Controller: lida com uma única página ou recurso
class UserListPageController {
  constructor(private readonly userRepository: UserRepository) {}

  // Cada método corresponde a um verbo HTTP para este recurso
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

## Relacionada com

- [front-controller.md](front-controller.md): complementa — Front Controller despacha para Page Controllers específicos
- [mvc.md](mvc.md): depende — Page Controller implementa o papel do Controller dentro da arquitetura MVC

---

**PoEAA Camada:** Web Presentation
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
