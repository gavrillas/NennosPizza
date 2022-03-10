//
//  Cart.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 12..
//

struct Cart: Codable {
    var pizzas: [Pizza]
    var drinks: [Drink]

    init(pizzas: [Pizza], drinks: [Drink]) {
        self.pizzas = pizzas
        self.drinks = drinks
    }

    init(from cartObject: CartObject) {
        pizzas = Array(cartObject.pizzas.map { Pizza(from: $0)})
        drinks = Array(cartObject.drinks.map { Drink(from: $0)})
    }
}
