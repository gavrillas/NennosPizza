//
//  PizzaIngrideintViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 16..
//


struct PizzaIngridientViewModel {
    let name: String
    let price: Double
    let isSelected: Bool

    init(ingridient: Ingridient, pizzaIngrideints: [Int]) {
        name = ingridient.name
        price = ingridient.price
        isSelected = pizzaIngrideints.contains(ingridient.id)
    }
}
