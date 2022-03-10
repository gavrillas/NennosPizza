//
//  PizzaImageCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 16..
//

import UIKit

class PizzaIngridientCell: ItemCell {
    func config(with viewModel: PizzaIngridientViewModel) {
        set(title: viewModel.name)
        set(price: viewModel.price)
        imageIsHidden = !viewModel.isSelected
        guard let image = UIImage(systemName: "checkmark") else { return }
        set(image: image)
    }
}
