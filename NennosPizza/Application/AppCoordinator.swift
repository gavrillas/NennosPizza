//
//  AppCoordinator.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 11..
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()

    func showPizzaDetails(viewModel: PizzaDetailsViewModel)
    func showCart()
    func showDrinks()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = PizzasViewController(viewModel: .init(), coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPizzaDetails(viewModel: PizzaDetailsViewModel) {
        let viewController = PizzaDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCart() {
        let viewController = CartViewController(viewModel: .init(), coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDrinks() {
        let viewController = DrinksViewController(viewModel: .init())
        navigationController.pushViewController(viewController, animated: true)
    }
}
