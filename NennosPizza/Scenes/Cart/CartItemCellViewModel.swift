//
//  CartItemCellViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 25..
//

import Foundation
import Resolver
import RxSwift
import struct RxCocoa.Driver

struct CartItemCellViewModel {
    @Injected var cartService: CartServiceUseCase

    struct Input {
        let removeFromCart: Observable<Void>
    }

    struct Output {
        let removedFromCart: Driver<Void>
    }

    enum Item {
        case drink(drink: Drink)
        case pizza(pizza: Pizza)
    }

    private let item: Item
    let name: String
    let price: Double

    init(item: Item, basePrice: Int = 0, ingridients: [Ingridient] = []) {
        self.item = item

        switch item {
        case let .drink(drink):
            name = drink.name
            price = drink.price
        case let .pizza(pizza):
            name = pizza.name
            price = ingridients.filter {
                pizza.ingredients.contains($0.id)
            }.map { $0.price }
            .reduce(0, { $0 + $1 }) + Double(basePrice)
        }
    }

    func transform(input: Input) -> Output {
        let removedFromCart = input.removeFromCart.map { _ in
            switch item {
            case let .pizza(pizza):
                cartService.removeFromCart(pizza: pizza)
            case let .drink(drink):
                cartService.removeFromCart(drink: drink)
            }
        }.asDriver(onErrorJustReturn: ())

        return Output(removedFromCart: removedFromCart)
    }
}
