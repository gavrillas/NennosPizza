//
//  DrinksViewController.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 21..
//

import UIKit
import RxSwift
import RxCocoa

class DrinksViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: DrinksViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.register(DrinkCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    init(viewModel: DrinksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        title = Txt.Drinks.title

        view.addSubview(tableView)

        setupConstraints()

        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init())

        output.tableData
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: DrinkCell.self)) { (_, viewModel, cell) in
                cell.config(with: viewModel)
            }.disposed(by: disposeBag)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            layoutTableView()
        ])
    }

    private func layoutTableView() -> [NSLayoutConstraint] {
        [
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}
