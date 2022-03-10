import RealmSwift

protocol CartRepositoryUseCase {
    var cart: CartObject? { get }
    func deleteCart()
    func addToCart(pizza: PizzaObject)
    func addToCart(drink: DrinkObject)
    func removeFromCart(pizza: PizzaObject)
    func removeFromCart(drink: DrinkObject)
    func getPizza(with ingridients: [Int]) -> PizzaObject?
    func getDrink(with id: Int) -> DrinkObject?
}

struct CartRepository: CartRepositoryUseCase {
    private let realm = RealmService.realm

    var cart: CartObject? {
        realm.objects(CartObject.self).first
    }

    func deleteCart() {
        guard let cart = cart else { return }
        delete(object: cart)
    }

    func addToCart(pizza: PizzaObject) {
        if cart == nil {
            createCart()
        }

        do {
            try realm.write {
                cart?.pizzas.append(pizza)
            }
        } catch {
            return
        }
    }

    func addToCart(drink: DrinkObject) {
        if cart == nil {
            createCart()
        }

        do {
            try realm.write {
                cart?.drinks.append(drink)
            }
        } catch {
            return
        }
    }

    func removeFromCart(pizza: PizzaObject) {
        if cart != nil {
            delete(object: pizza)
        }
    }

    func removeFromCart(drink: DrinkObject) {
        if cart != nil {
            delete(object: drink)
        }
    }

    func getPizza(with ingridients: [Int]) -> PizzaObject? {
        cart?.pizzas
            .first(where: { Array($0.ingridients).elementsEqual(ingridients) })
    }

    func getDrink(with id: Int) -> DrinkObject? {
        cart?.drinks
            .first(where: { $0.id == id })
    }

    private func delete(object: ObjectBase) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            return
        }
    }

    private func createCart() {
        do {
            try realm.write {
                realm.add(CartObject())
            }
        } catch {
            return
        }
    }

}
