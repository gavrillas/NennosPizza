import RxSwift
import Resolver
import RxRelay

protocol CartServiceUseCase {
    var cart: BehaviorRelay<Cart> { get }
    var pizzaBasePrice: BehaviorRelay<Int> { get }
    func addToCart(pizza: Pizza)
    func addToCart(drink: Drink)
    func deleteCart()
    func removeFromCart(pizza: Pizza)
    func removeFromCart(drink: Drink)
}

struct CartService: CartServiceUseCase {
    @Injected var cartRepository: CartRepositoryUseCase

    static let shared = CartService()

    let cart: BehaviorRelay<Cart> = BehaviorRelay<Cart>(value: .init(pizzas: [], drinks: []))
    let pizzaBasePrice: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)

    private init() {
        guard let cartObject = cartRepository.cart else { return }
        cart.accept(Cart(from: cartObject))
    }

    func addToCart(pizza: Pizza) {
        let pizzaObject = PizzaObject(from: pizza)
        cartRepository.addToCart(pizza: pizzaObject)

        var newCart = cart.value
        newCart.pizzas.append(pizza)
        cart.accept(newCart)
    }

    func addToCart(drink: Drink) {
        let drinkObject = DrinkObject(from: drink)
        cartRepository.addToCart(drink: drinkObject)

        var newCart = cart.value
        newCart.drinks.append(drink)
        cart.accept(newCart)
    }

    func deleteCart() {
        cartRepository.deleteCart()
        cart.accept(.init(pizzas: [], drinks: []))
    }

    func removeFromCart(pizza: Pizza) {
        guard let pizzaObject = cartRepository.getPizza(with: pizza.ingredients) else { return }
        cartRepository.removeFromCart(pizza: pizzaObject)

        var newCart = cart.value
        let index = newCart.pizzas.firstIndex { $0.ingredients.elementsEqual(pizza.ingredients) }
        guard let index = index else { return }
        newCart.pizzas.remove(at: index)
        cart.accept(newCart)
    }

    func removeFromCart(drink: Drink) {
        guard let drinkObject = cartRepository.getDrink(with: drink.id) else { return }
        cartRepository.removeFromCart(drink: drinkObject)

        var newCart = cart.value
        let index = newCart.drinks.firstIndex { $0.id == drink.id }
        guard let index = index else { return }
        newCart.drinks.remove(at: index)
        cart.accept(newCart)
    }
}
