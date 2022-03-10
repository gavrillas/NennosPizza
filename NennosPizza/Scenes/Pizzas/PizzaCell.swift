//
//  PizzaCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 12..
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class PizzaCell: UITableViewCell {
    enum Layout {
        static let pizzaVerticalPadding: CGFloat = 0
        static let pizzaHorizontalPadding: CGFloat = 20
        static let defaultPadding: CGFloat = 12
        static let priceButtonCornerRadius: CGFloat = 5
        static let priceButtonWidth: CGFloat = 88
        static let priceButtonHeight: CGFloat = 32
        static let labelsTrailing: CGFloat = 55
    }

    private var disposeBag = DisposeBag()

    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: Asset.Image.background.image)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var pizzaImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.image = Asset.Image.cartButton.image
            config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            config.baseBackgroundColor = Asset.Color.orange.color
            config.baseForegroundColor = .white
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            button.setImage(Asset.Image.cartButton.image, for: .normal)
            button.layer.cornerRadius = Layout.priceButtonCornerRadius
            button.tintColor = .white
            button.backgroundColor = Asset.Color.orange.color
        }
        return button
    }()

    private lazy var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.Color.blurBackground.color.withAlphaComponent(0.95)
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()

    private let ingridientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(backgroundImage)
        contentView.addSubview(pizzaImage)
        contentView.addSubview(blurView)
        contentView.addSubview(priceButton)
        contentView.addSubview(ingridientsLabel)
        contentView.addSubview(nameLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func config(with viewModel: PizzaCellViewModel) {
        if let imageUrl = viewModel.imageUrl {
            let url = URL(string: imageUrl)
            pizzaImage.kf.setImage(with: url)
        }
        priceButton.setTitle(Txt.Price.currency(viewModel.price), for: .normal)
        ingridientsLabel.text = viewModel.ingridientsText
        nameLabel.text = viewModel.name

        let addToCart = priceButton.rx.tap.asObservable()

        let input = PizzaCellViewModel.Input(addToCart: addToCart)

        let output = viewModel.transform(input: input)

        output.addedToCart
            .drive()
            .disposed(by: disposeBag)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutBackgroundImage(),
            layoutPizzaImage(),
            layoutBlurView(),
            layoutPriceButton(),
            layoutIngridientsLabel(),
            layoutNameLabel()
        ])
    }

    private func layoutBackgroundImage() -> [NSLayoutConstraint] {
        [
            backgroundImage.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            backgroundImage.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.bottomAnchor
            ),
            backgroundImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            backgroundImage.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor
            )
        ]
    }

    private func layoutPizzaImage() -> [NSLayoutConstraint] {
        [
            pizzaImage.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: Layout.pizzaVerticalPadding),
            pizzaImage.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -Layout.pizzaVerticalPadding),
            pizzaImage.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: Layout.pizzaHorizontalPadding),
            pizzaImage.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -Layout.pizzaHorizontalPadding)
        ]
    }

    private func layoutBlurView() -> [NSLayoutConstraint] {
        [
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -Layout.defaultPadding)
        ]
    }

    private func layoutPriceButton() -> [NSLayoutConstraint] {
        [
            priceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.defaultPadding),
            priceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.defaultPadding),
            priceButton.widthAnchor.constraint(equalToConstant: Layout.priceButtonWidth),
            priceButton.heightAnchor.constraint(equalToConstant: Layout.priceButtonHeight)
        ]
    }

    private func layoutIngridientsLabel() -> [NSLayoutConstraint] {
        [
            ingridientsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.defaultPadding),
            ingridientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.defaultPadding),
            ingridientsLabel.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: -Layout.labelsTrailing)
        ]
    }

    private func layoutNameLabel() -> [NSLayoutConstraint] {
        [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.defaultPadding),
            nameLabel.bottomAnchor.constraint(equalTo: ingridientsLabel.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: -Layout.labelsTrailing)
        ]
    }
}
