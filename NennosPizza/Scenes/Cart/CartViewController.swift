//
//  CartViewController.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 21..
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CartViewController: UIViewController {
    enum Layout {
        static let checkoutButtonFont: CGFloat = 16
        static let checkoutButtonHeight: CGFloat = 50
        static let seactionFooterHeight: CGFloat = 23
    }

    enum Identifiers {
        static let itemCell = "ItemCell"
        static let totalCell = "TotalCell"
    }

    private let coordinator: Coordinator
    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.register(CartItemCell.self, forCellReuseIdentifier: Identifiers.itemCell)
        tableView.register(CartTotalCell.self, forCellReuseIdentifier: Identifiers.totalCell)
        return tableView
    }()

    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Txt.Cart.checkout, for: .normal)
        button.backgroundColor = Asset.Color.red.color
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Layout.checkoutButtonFont)
        return button
    }()

    private lazy var drinksButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Asset.Image.drinks.image
        return button
    }()

    init(viewModel: CartViewModel,coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        title = Txt.Cart.title
        navigationItem.rightBarButtonItem = drinksButton
        navigationItem.backButtonTitle = ""

        view.addSubview(checkoutButton)
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
        let drinksTrigger = drinksButton.rx.tap.asObservable()
        let checkoutTrigger = checkoutButton.rx.tap.asObservable()

        let input = CartViewModel.Input(drinksTrigger: drinksTrigger,
                                        chekoutTrigger: checkoutTrigger)

        let output = viewModel.transform(input: input)

        output.showDrinks
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.showDrinks()
            }).disposed(by: disposeBag)

        output.tableData
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.cartCheckedOut
            .drive()
            .disposed(by: disposeBag)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutCheckoutButton(),
            layoutTableView()
        ])
    }

    private func layoutCheckoutButton() -> [NSLayoutConstraint] {
        [
            checkoutButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutButton.heightAnchor.constraint(equalToConstant: Layout.checkoutButtonHeight)
        ]
    }

    private func layoutTableView() -> [NSLayoutConstraint] {
        [
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}

extension CartViewController {
    private var dataSource: RxTableViewSectionedReloadDataSource<CartViewModel.SectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<CartViewModel.SectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .cartItem(viewModel):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.itemCell, for: indexPath) as! CartItemCell
                    cell.config(with: viewModel)
                    return cell
                case let .total(viewModel):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.totalCell, for: indexPath) as! CartTotalCell
                    cell.config(with: viewModel)
                    return cell
                }
            })

        return dataSource
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Layout.seactionFooterHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}
