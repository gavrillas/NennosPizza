import Foundation
import RealmSwift

public final class PizzaObject: EmbeddedObject {
    public let ingridients = List<Int>()
    @objc public dynamic var name = ""
    @objc public dynamic var imageUrl = ""

    convenience init(from pizza: Pizza) {
        self.init()

        ingridients.append(objectsIn: pizza.ingredients)
        name = pizza.name
        imageUrl = pizza.imageURL ?? ""
    }
}
