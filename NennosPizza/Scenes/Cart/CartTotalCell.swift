//
//  CartTotalCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 31..
//

import UIKit

class CartTotalCell: ItemCell {

    func config(with viewModel: CartTotalCellViewModel) {
        imageIsHidden = true
        set(title: Txt.Cart.total)
        set(price: viewModel.totalPrice)
        set(font: UIFont.boldSystemFont(ofSize: 17))
    }
}
