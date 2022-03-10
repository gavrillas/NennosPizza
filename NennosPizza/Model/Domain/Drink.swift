//
//  Drink.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 11..
//

import Foundation

struct Drink: Codable {
    let price: Double
    let name: String
    let id: Int

    init(price: Double, name: String, id: Int) {
        self.price = price
        self.name = name
        self.id = id
    }

    init(from drinkObject: DrinkObject) {
        price = drinkObject.price
        name = drinkObject.name
        id = drinkObject.id
    }
}
