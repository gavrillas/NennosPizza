//
//  CartViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 21..
//

import RxSwift
import RxDataSources
import struct RxCocoa.Driver
import Resolver

struct CartViewModel {
    typealias ViewModel = CartItemCellViewModel
    @Injected private var pizzaService: PizzaServiceUseCase
    @Injected private var cartService: CartServiceUseCase

    struct Input {
        let drinksTrigger: Observable<Void>
        let chekoutTrigger: Observable<Void>
    }

    struct Output {
        let showDrinks: Driver<Void>
        let tableData: Driver<[SectionModel]>
        let cartCheckedOut: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let showDrinks = input.drinksTrigger
            .asDriver(onErrorJustReturn: ())

        let ingridients = pizzaService.getIngridients()
            .asObservable()
            .share(replay: 1, scope: .whileConnected)

        let tableData = Observable.combineLatest(cartService.cart,
                                                 ingridients,
                                                 cartService.pizzaBasePrice) { cart, ingridients, basePrice -> [SectionModel] in

            let pizzaViewModels = cart.pizzas
                .sorted(by: { $0.name < $1.name }).map { pizza in
                ViewModel(item: .pizza(pizza: pizza),
                                      basePrice: basePrice,
                                      ingridients: ingridients)}

            let drinkViewModels = cart.drinks
                .sorted(by: { $0.id < $1.id })
                .map { ViewModel(item: .drink(drink: $0))}

            let items = (pizzaViewModels + drinkViewModels).map { viewModel in
                SectionItem.cartItem(viewModel: viewModel)
            }

            let itemSection = SectionModel(identity: DetailsSection.cartItem.rawValue,
                                            items: items)

            let totalSection = SectionModel(identity: DetailsSection.total.rawValue,
                                            items: [.total(viewModel: .init(viewModels: pizzaViewModels + drinkViewModels))])
            return [itemSection, totalSection]
        }.asDriver(onErrorJustReturn: [])

        let cartCheckedOut = input.chekoutTrigger.map { _ in
            cartService.deleteCart()
        }.asDriver(onErrorJustReturn: ())

        return Output(showDrinks: showDrinks,
                      tableData: tableData,
                      cartCheckedOut: cartCheckedOut)
    }
}

extension CartViewModel {
    struct SectionModel {
        let identity: Int
        var items: [SectionItem]
    }

    enum SectionItem {
        case cartItem(viewModel: CartItemCellViewModel)
        case total(viewModel: CartTotalCellViewModel)
    }

    enum DetailsSection: Int {
        case cartItem
        case total
    }
}

extension CartViewModel.SectionModel: AnimatableSectionModelType {
    typealias Item = CartViewModel.SectionItem
    typealias Identity = Int

    init(original: CartViewModel.SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

extension CartViewModel.SectionItem: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        switch self {
        case .cartItem:
            return CartViewModel.DetailsSection.cartItem.rawValue
        case .total:
            return CartViewModel.DetailsSection.total.rawValue
        }
    }
}

extension CartViewModel.SectionItem: Equatable {
    static func == (lhs: CartViewModel.SectionItem, rhs: CartViewModel.SectionItem) -> Bool {
        lhs.identity == rhs.identity
    }
}
