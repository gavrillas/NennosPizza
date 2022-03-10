//
//  ItemCell.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 23..
//
import UIKit
import RxSwift
import RxCocoa

class ItemCell: UITableViewCell {
    enum Layout {
        static let imageWidth: CGFloat = 18
        static let imageHeight: CGFloat = 15
        static let imagePadding: CGFloat = 15
        static let defaultPadding: CGFloat = 12
        static let seperatorHeight: CGFloat = 1
    }

    var imageIsHidden: Bool = false {
        didSet {
            imageButton.isHidden = imageIsHidden
        }
    }

    private lazy var imageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Asset.Color.red.color
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.Color.seperatorColor.color
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imageButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(seperatorView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String) {
        titleLabel.text = title
    }

    func set(price: Double) {
        priceLabel.text = Txt.Price.currency(price)
    }

    func set(image: UIImage) {
        imageButton.setImage(image, for: .normal)
    }

    func set(font: UIFont) {
        titleLabel.font = font
        priceLabel.font = font
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutRemoveButton(),
            layoutTitleLabel(),
            layoutPriceLabel(),
            layoutSeperatorView()
        ])
    }

    private func layoutRemoveButton() -> [NSLayoutConstraint] {
        [
            imageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.imagePadding),
            imageButton.heightAnchor.constraint(equalToConstant: Layout.imageHeight),
            imageButton.widthAnchor.constraint(equalToConstant: Layout.imageWidth),
            imageButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }

    private func layoutTitleLabel() -> [NSLayoutConstraint] {
        [
            titleLabel.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: Layout.imagePadding),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }

    private func layoutPriceLabel() -> [NSLayoutConstraint] {
        [
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Layout.defaultPadding),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.defaultPadding),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }

    private func layoutSeperatorView() -> [NSLayoutConstraint] {
        [
            seperatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: Layout.seperatorHeight)
        ]
    }
}

extension ItemCell {
    var imageButtonTap: Observable<Void> {
        imageButton.rx.tap.asObservable()
    }
}
