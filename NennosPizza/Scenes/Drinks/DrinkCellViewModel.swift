//
//  DrinkCellViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 25..
//

import Resolver
import RxSwift
import struct RxCocoa.Driver

struct DrinkCellViewModel {
    @Injected private var cartService: CartServiceUseCase

    struct Input {
        let addToCart: Observable<Void>
    }

    struct Output {
        let addedToCart: Driver<Void>
    }

    private let drink: Drink
    let name: String
    let price: Double

    init(drink: Drink) {
        self.drink = drink
        name = drink.name
        price = drink.price
    }

    func transfrom(input: Input) -> Output {
        let addedToCart = input.addToCart.map { _ in
            cartService.addToCart(drink: drink)
        }.asDriver(onErrorJustReturn: ())

        return Output(addedToCart: addedToCart)
    }
}
