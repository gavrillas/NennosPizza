//
//  DrinksViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 21..
//

import Foundation
import RxSwift
import struct RxCocoa.Driver
import Resolver

struct DrinksViewModel {
    @Injected var pizzaService: PizzaServiceUseCase

    struct Input {

    }

    struct Output {
        let tableData: Driver<[DrinkCellViewModel]>
    }

    func transform(input: Input) -> Output {
        let tableData = pizzaService.getDrinks()
            .map { drinks in
                drinks.map { DrinkCellViewModel(drink: $0) }
            }
            .asDriver(onErrorJustReturn: [])

        return Output(tableData: tableData)
    }
}
