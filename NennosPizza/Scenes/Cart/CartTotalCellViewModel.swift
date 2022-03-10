//
//  CartTotalCellViewModel.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 31..
//

import Foundation

struct CartTotalCellViewModel {
    let totalPrice: Double

    init(viewModels: [CartItemCellViewModel]) {
        totalPrice = viewModels
            .map { $0.price }
            .reduce(0, { $0 + $1 })
    }
}
