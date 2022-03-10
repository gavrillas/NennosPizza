//
//  CartItemCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 23..
//

import UIKit
import RxSwift
import RxCocoa

class CartItemCell: ItemCell {
    var disposeBag = DisposeBag()

    func config(with viewModel: CartItemCellViewModel) {
        set(title: viewModel.name)
        set(price: viewModel.price)
        guard let image = UIImage(systemName: "xmark") else { return }
        set(image: image)

        let output = viewModel.transform(input: .init(removeFromCart: imageButtonTap))

        output.removedFromCart
            .drive()
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
