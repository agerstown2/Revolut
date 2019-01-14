//
//  RatesListViewController.swift
//  Revolut
//
//  Created by Natalia Nikitina on 12/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit
import PureLayout

final class RatesListViewController: UIViewController {
	private let model = RatesListViewModel()
	private var tableViewController: TableViewController!

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
		tableViewController.register(configurator: RateCell.configurator)
	}

	private func layoutViews() {
		view.addSubview(tableView)
		tableView.autoPinEdgesToSuperviewSafeArea()
	}

	private func loadData() {
		model.loadRates() { [weak self] result in
			switch result {
			case .success:
				self?.tableView.reloadData()
			case .error(_): ()
			}
		}
	}
}

