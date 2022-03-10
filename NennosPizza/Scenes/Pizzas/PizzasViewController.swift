//
//  PizzasViewController.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 11..
//

import UIKit
import RxSwift
import RxCocoa

class PizzasViewController: UIViewController {
    private let viewModel: PizzasViewModel
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()

    private lazy var addedToCartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.Color.red.color
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 178
        tableView.estimatedRowHeight = 178
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.register(PizzaCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    private lazy var plusButton: UIBarButtonItem = {
        UIBarButtonItem(systemItem: .add)
    }()

    private lazy var cartButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Asset.Image.cartNavbar.image
        return button
    }()

    init(viewModel: PizzasViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        title = Txt.Home.title
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = cartButton
        navigationItem.backButtonTitle = ""

        view.addSubview(tableView)
        // view.addSubview(addedToCartView)

        setupConstraints()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // layoutAddedToCartView(),
            layoutTableView()
        ])
    }

    private func layoutAddedToCartView() -> [NSLayoutConstraint] {
        [
            addedToCartView.topAnchor.constraint(equalTo: view.topAnchor),
            addedToCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addedToCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addedToCartView.heightAnchor.constraint(equalToConstant: 50)
        ]
    }

    private func layoutTableView() -> [NSLayoutConstraint] {
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
    }

    private func bindViewModel() {

        let selectedIndex = tableView.rx.itemSelected.map { $0.item }.asObservable()
        let addCustomPizza = plusButton.rx.tap.asObservable()
        let cartTrigger = cartButton.rx.tap.asObservable()

        let input = PizzasViewModel.Input(selectedIndex: selectedIndex,
                                          addCustomPizza: addCustomPizza,
                                          cartTrigger: cartTrigger)

        let outputData = viewModel.transform(input: input)

        outputData.tableData
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: PizzaCell.self)) { (_, viewModel, cell) in
                cell.config(with: viewModel)
            }.disposed(by: disposeBag)

        outputData.showPizzaDetails.drive(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.coordinator.showPizzaDetails(viewModel: viewModel)
        }).disposed(by: disposeBag)

        outputData.showCart
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.showCart()
            }).disposed(by: disposeBag)
    }
}
