//
//  DrinkCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 21..
//

import UIKit
import RxSwift
import RxCocoa

class DrinkCell: ItemCell {
    typealias Input = DrinkCellViewModel.Input
    var disposeBag = DisposeBag()

    func config(with viewModel: DrinkCellViewModel) {
        set(title: viewModel.name)
        set(price: viewModel.price)
        guard let image = UIImage(systemName: "plus") else { return }
        set(image: image)

        let input = Input(addToCart: imageButtonTap)
        let output = viewModel.transfrom(input: input)

        output.addedToCart
            .drive()
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
