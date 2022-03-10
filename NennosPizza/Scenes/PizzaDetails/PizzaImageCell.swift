//
//  PizzaImageCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 16..
//

import UIKit
import Kingfisher

class PizzaImageCell: UITableViewCell {

    enum Layout {
        static let pizzaVerticalPadding: CGFloat = 20
        static let pizzaHorizontalPadding: CGFloat = 40
    }

    let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: Asset.Image.background.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let pizzaImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(backgroundImage)
        contentView.addSubview(pizzaImage)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        let url = URL(string: imageUrl)
        pizzaImage.kf.setImage(with: url)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutBackgroundImage(),
            layoutPizzaImage()
        ])
    }

    private func layoutBackgroundImage() -> [NSLayoutConstraint] {
        [
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
    }

    private func layoutPizzaImage() -> [NSLayoutConstraint] {
        [
            pizzaImage.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor,
                                                constant: Layout.pizzaHorizontalPadding),
            pizzaImage.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor,
                                                 constant: -Layout.pizzaHorizontalPadding),
            pizzaImage.topAnchor.constraint(equalTo: backgroundImage.topAnchor,
                                            constant: Layout.pizzaVerticalPadding),
            pizzaImage.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor,
                                               constant: -Layout.pizzaVerticalPadding)
        ]
    }
}
