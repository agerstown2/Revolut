//
//  RatesListViewController.swift
//  Revolut
//
//  Created by Natalia Nikitina on 12/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit
import PureLayout

final class RatesListViewController: UIViewController, Loadable {
	private let model = RatesListViewModel()
	private var tableViewController: TableViewController!
	private var keyboardOffsetController: KeyboardOffsetController?

	private lazy var errorManager = ErrorManager(
		view: view,
		message: "Something went wrong",
		retry: { [weak self] in self?.loadData() }
	)

	private var tableView: UITableView {
		return tableViewController.tableView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableViewController = TableViewController(model: model)

		setupViews()
		layoutViews()

		loadData()
	}

	private func setupViews() {
		tableView.contentInset = .create(bottom: 16)
		tableViewController.register(configurator: RateCell.configurator)
	}

	private func layoutViews() {
		view.addSubview(tableView)
		tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
		let bottomConstraint = tableView.autoPinEdge(toSuperviewEdge: .bottom)
		keyboardOffsetController = KeyboardOffsetController(view: view, constraint: bottomConstraint)
	}

	private func loadData() {
		showLoader()
		model.loadRates() { [weak self] result in
			guard let self = self else { return }
			self.hideLoader()
			switch result {
			case .success:
				self.tableView.reloadData()
			case .error(_):
				self.errorManager.showError()
			}
		}
	}
}
