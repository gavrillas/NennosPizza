//
//  PizzaCellViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 12..
//

import RxSwift
import Resolver
import struct RxCocoa.Driver

struct PizzaCellViewModel {
    @Injected private var cartService: CartServiceUseCase

    struct Input {
        let addToCart: Observable<Void>
    }

    struct Output {
        let addedToCart: Driver<Void>
    }

    private let basePrice: Int
    private let pizza: Pizza
    private let ingridients: [Ingridient]
    let imageUrl: String?
    let price: Double
    let ingridientsText: String
    let name: String

    init(basePrice: Int, pizza: Pizza, ingridients: [Ingridient]) {
        self.basePrice = basePrice
        self.pizza = pizza
        self.ingridients = ingridients
        imageUrl = pizza.imageURL

        let filteredIngrideints = ingridients.filter {
            pizza.ingredients.contains($0.id)
        }

        price = filteredIngrideints.map { $0.price }
        .reduce(0, { $0 + $1 }) + Double(basePrice)

        ingridientsText = filteredIngrideints.map { $0.name }
        .joined(separator: ", ")

        name = pizza.name
    }

    func transform(input: Input) -> Output {
        let addedToCart = input.addToCart.map { _ in
            cartService.addToCart(pizza: pizza)
        }.asDriver(onErrorJustReturn: ())

        return Output(addedToCart: addedToCart)
    }
}
