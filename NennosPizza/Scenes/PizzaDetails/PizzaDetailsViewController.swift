//
//  PizzaDetailsViewController.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 15..
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftUI

class PizzaDetailsViewController: UIViewController {
    enum Layout {
        static let addToCartButtonHeight: CGFloat = 50
        static let pizzaImageCellHeight: CGFloat = 300
        static let ingridientCellHeight: CGFloat = 44
        static let sectionHeaderHeight: CGFloat = 65
        static let addToCartButtonFont: CGFloat = 16
    }

    enum Identifiers {
        static let pizzaImageCell = "PizzaImageCell"
        static let ingridientCell = "IngridientCell"
        static let ingridientHeader = "IngridientHeader"
    }

    private let viewModel: PizzaDetailsViewModel
    private let disposeBag = DisposeBag()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Asset.Color.orange.color
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Layout.addToCartButtonFont)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.register(PizzaImageCell.self, forCellReuseIdentifier: Identifiers.pizzaImageCell)
        tableView.register(PizzaIngridientCell.self, forCellReuseIdentifier: Identifiers.ingridientCell)
        tableView.register(IngridientsHeaderView.self, forHeaderFooterViewReuseIdentifier: Identifiers.ingridientHeader)
        return tableView
    }()

    init(viewModel: PizzaDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        navigationItem.backButtonTitle = ""

        view.addSubview(addToCartButton)
        view.addSubview(tableView)

        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)

        setupConstraints()

        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {

        let selectedIndex = tableView.rx.itemSelected
            .asObservable()
            .filter {
                $0.section > 0
            }
            .map { $0.row }

        let addToCart = addToCartButton.rx.tap.asObservable()

        let input = PizzaDetailsViewModel.Input(selectIndex: selectedIndex,
                                                addToCart: addToCart)

        let output = viewModel.transform(input: input)

        output.buttonTitle
            .drive(addToCartButton.rx.title())
            .disposed(by: disposeBag)

        output.pizzaName
            .drive(rx.title)
            .disposed(by: disposeBag)

        output.tableData
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.ingridientSelected
            .drive()
            .disposed(by: disposeBag)

        output.pizzaAddedToCart
            .drive()
            .disposed(by: disposeBag)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutAddToCartButton(),
            layoutTableView()
        ])
    }

    private func layoutAddToCartButton() -> [NSLayoutConstraint] {
        [
            addToCartButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: Layout.addToCartButtonHeight)
        ]
    }

    private func layoutTableView() -> [NSLayoutConstraint] {
        [
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}

extension PizzaDetailsViewController {
    private var dataSource: RxTableViewSectionedReloadDataSource<PizzaDetailsViewModel.SectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<PizzaDetailsViewModel.SectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .pizzaImage(imageUrl):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.pizzaImageCell, for: indexPath) as! PizzaImageCell
                    cell.config(with: imageUrl)
                    return cell
                case let .ingridient(viewModel):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ingridientCell, for: indexPath) as! PizzaIngridientCell
                    cell.config(with: viewModel)
                    return cell
                }
            })

        return dataSource
    }
}

extension PizzaDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            return Layout.pizzaImageCellHeight
        default:
            return Layout.ingridientCellHeight
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: Identifiers.ingridientHeader) as! IngridientsHeaderView
        view.setTitle(text: Txt.PizzaDetails.ingridientsHeader)

        switch section {
        case 1:
            return view
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return Layout.sectionHeaderHeight
        default:
            return 0
        }
    }
}
