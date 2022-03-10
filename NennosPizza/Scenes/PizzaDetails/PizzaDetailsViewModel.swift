//
//  PizzaDetailsViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 15..
//

import Foundation
import RxSwift
import RxDataSources
import struct RxCocoa.Driver
import Resolver

struct PizzaDetailsViewModel {
    struct Input {
        let selectIndex: Observable<Int>
        let addToCart: Observable<Void>
    }

    struct Output {
        let pizzaName: Driver<String>
        let buttonTitle: Driver<String>
        let tableData: Driver<[SectionModel]>
        let ingridientSelected: Driver<Void>
        let pizzaAddedToCart: Driver<Void>
    }

    @Injected private var cartService: CartServiceUseCase
    private let pizzaSubject = BehaviorSubject<Pizza>(value: .init(ingredients: [], name: Txt.PizzaDetails.customPizza, imageURL: nil))
    private let ingridients: [Ingridient]
    private let basePrice: Int

    init(basePrice: Int, ingridients: [Ingridient], pizza: Pizza? = nil) {
        if let pizza = pizza {
            pizzaSubject.onNext(pizza)
        }
        self.ingridients = ingridients
        self.basePrice = basePrice
    }

    func transform(input: Input) -> Output {
        let pizzaName = pizzaSubject
            .take(2)
            .map { $0.name.uppercased() }
            .asDriver(onErrorJustReturn: Txt.PizzaDetails.customPizza)

        let buttonTitle = pizzaSubject.map { pizza in
            self.ingridients.filter {
                pizza.ingredients.contains($0.id)
            }.map { $0.price }
            .reduce(0, { $0 + $1 }) + Double(basePrice)
        }.map { Txt.PizzaDetails.addToCart($0) }
            .asDriver(onErrorJustReturn: Txt.PizzaDetails.addToCart(basePrice))

        let ingridientSelected = input.selectIndex
            .withLatestFrom(pizzaSubject) { index, pizza in
                let ingridientId = ingridients[index].id
                var pizzaIngridients = pizza.ingredients
                if pizzaIngridients.contains(ingridientId) {
                    pizzaIngridients.removeAll { $0 == ingridientId }
                } else {
                    pizzaIngridients.append(ingridientId)
                }
                pizzaSubject.onNext(Pizza(ingredients: pizzaIngridients, name: pizza.name, imageURL: pizza.imageURL))
            }.asDriver(onErrorJustReturn: ())

        let tableData = createTableData()

        let pizzaAddedToCart = input.addToCart
            .withLatestFrom(pizzaSubject)
            .debug()
            .map(cartService.addToCart(pizza:))
            .asDriver(onErrorJustReturn: ())

        return Output(pizzaName: pizzaName,
                      buttonTitle: buttonTitle,
                      tableData: tableData,
                      ingridientSelected: ingridientSelected,
                      pizzaAddedToCart: pizzaAddedToCart)
    }

    private func createTableData() -> Driver<[SectionModel]> {
        pizzaSubject.map { pizza in

            let pizzaImageSection = SectionModel(identity: DetailsSection.image.rawValue,
                                                 items: [.pizzaImage(imageUrl: pizza.imageURL)])
            var sectionModels: [SectionModel] = [pizzaImageSection]

            let viewModelItems = self.ingridients.map {
                PizzaIngridientViewModel(ingridient: $0, pizzaIngrideints: pizza.ingredients)
            }.map { SectionModel.Item.ingridient(viewModel: $0)}

            let ingridientsSections = SectionModel(identity: DetailsSection.image.rawValue,
                                                   items: viewModelItems)

            sectionModels.append(ingridientsSections)
            return sectionModels
        }.asDriver(onErrorJustReturn: [])
    }

}

extension PizzaDetailsViewModel {
    struct SectionModel {
        let identity: Int
        var items: [SectionItem]
    }

    enum SectionItem {
        case pizzaImage(imageUrl: String?)
        case ingridient(viewModel: PizzaIngridientViewModel)
    }

    enum DetailsSection: Int {
        case image
        case ingridients
    }
}

extension PizzaDetailsViewModel.SectionModel: AnimatableSectionModelType {
    typealias Item = PizzaDetailsViewModel.SectionItem
    typealias Identity = Int

    init(original: PizzaDetailsViewModel.SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

extension PizzaDetailsViewModel.SectionItem: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        switch self {
        case .pizzaImage:
            return PizzaDetailsViewModel.DetailsSection.image.rawValue
        case .ingridient:
            return PizzaDetailsViewModel.DetailsSection.ingridients.rawValue
        }
    }
}

extension PizzaDetailsViewModel.SectionItem: Equatable {
    static func == (lhs: PizzaDetailsViewModel.SectionItem, rhs: PizzaDetailsViewModel.SectionItem) -> Bool {
        lhs.identity == rhs.identity
    }
}
