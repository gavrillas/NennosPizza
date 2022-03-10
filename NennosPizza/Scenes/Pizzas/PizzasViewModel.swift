//
//  PizzasViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 11..
//

import RxSwift
import struct RxCocoa.Driver
import Resolver

struct PizzasViewModel {
    typealias BasePrice = Int
    @Injected var pizzaService: PizzaServiceUseCase
    @Injected var cartService: CartServiceUseCase

    struct Input {
        let selectedIndex: Observable<Int>
        let addCustomPizza: Observable<Void>
        let cartTrigger: Observable<Void>
    }

    struct Output {
        let tableData: Driver<[PizzaCellViewModel]>
        let basePrice: Driver<BasePrice>
        let ingridients: Driver<[Ingridient]>
        let showPizzaDetails: Driver<PizzaDetailsViewModel>
        let showCart: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let pizzaResponse = pizzaService.getPizzas().asObservable().share()
        let ingridients = pizzaService.getIngridients().asObservable().share()

        let tableData = Observable.combineLatest(pizzaResponse, ingridients)
            .map { ($0.0, $0.1)}
            .map { pizzas, ingridients in
                pizzas.pizzas.map {
                    PizzaCellViewModel(basePrice: pizzas.basePrice, pizza: $0, ingridients: ingridients)
                }
            }.asDriver(onErrorJustReturn: [])

        let basePrice = pizzaResponse
            .map { response -> Int in
                cartService.pizzaBasePrice.accept(response.basePrice)
                return response.basePrice
            }
            .share()

        let selectedPizza = input.selectedIndex
            .withLatestFrom(pizzaResponse) { index, pizzaResponse in
                return pizzaResponse.pizzas[index]
            }

        let customPizzaViewmodel = input.addCustomPizza
            .withLatestFrom(basePrice)
            .withLatestFrom(ingridients) { PizzaDetailsViewModel(basePrice: $0, ingridients: $1) }

        let selectedPizzaViewModel = Observable.combineLatest(
            basePrice,
            ingridients,
            selectedPizza
        ).map { PizzaDetailsViewModel(basePrice: $0, ingridients: $1, pizza: $2)}

        let showPizzaDetails = Observable.merge(
            customPizzaViewmodel,
            selectedPizzaViewModel
        ).asDriver(onErrorJustReturn: PizzaDetailsViewModel(basePrice: 0, ingridients: []))

        let showCart = input.cartTrigger
            .asDriver(onErrorJustReturn: ())

        return Output(tableData: tableData,
                      basePrice: basePrice.asDriver(onErrorJustReturn: 0),
                      ingridients: ingridients.asDriver(onErrorJustReturn: []),
                      showPizzaDetails: showPizzaDetails,
                      showCart: showCart)
    }

}
