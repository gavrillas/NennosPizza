import Foundation
import RealmSwift

public final class CartObject: Object {
    public let pizzas = List<PizzaObject>()
    public let drinks = List<DrinkObject>()
}
