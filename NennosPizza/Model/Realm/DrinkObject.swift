import Foundation
import RealmSwift

public final class DrinkObject: EmbeddedObject {
    @objc public dynamic var price = 0.0
    @objc public dynamic var name = ""
    @objc public dynamic var id = 0

    convenience init(from drink: Drink) {
        self.init()

        price = drink.price
        name = drink.name
        id = drink.id
    }
}
