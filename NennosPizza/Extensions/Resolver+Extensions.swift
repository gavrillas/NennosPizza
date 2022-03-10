//
//  Resolver+Extensions.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 12..
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerPizzaService()
        registerCartRepository()
        registerCartService()
    }

    private static func registerPizzaService() {
        register { PizzaService() as PizzaServiceUseCase }
    }

    private static func registerCartRepository() {
        register { CartRepository() as CartRepositoryUseCase }
    }

    private static func registerCartService() {
        register { CartService.shared as CartServiceUseCase }
    }
}
