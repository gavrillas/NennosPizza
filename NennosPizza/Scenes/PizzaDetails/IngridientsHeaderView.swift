//
//  IngridientsHeaderView.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 20..
//

import UIKit

class IngridientsHeaderView: UITableViewHeaderFooterView {
    enum Layout {
        static let defaultPadding: CGFloat = 12
        static let defaultFont: CGFloat = 24
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Layout.defaultFont)
        label.textColor = Asset.Color.textColor.color
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(text: String) {
        titleLabel.text = text
    }

    func setFontSize(size: CGFloat) {
        titleLabel.font = UIFont.boldSystemFont(ofSize: size)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
           layoutTitleLabel()
        ])
    }

    private func layoutTitleLabel() -> [NSLayoutConstraint] {
        [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.defaultPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
    }

}
