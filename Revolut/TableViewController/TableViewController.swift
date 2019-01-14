//
//  TableViewController.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class TableViewController: NSObject {
	private var configurators: [String: CellConfigurator] = [:]
	private var model: TableViewModel

	let tableView = UITableView(frame: .zero, style: .plain)

	init(model: TableViewModel) {
		self.model = model

		super.init()

		tableView.dataSource = self
	}
}

// MARL: - Cell configurators registration
extension TableViewController {
	func register<Cell: UITableViewCell, Item>(configurator: GenericCellConfigurator<Cell, Item>) {
		registerConfigurator(configurator: configurator)
		registerCellClass(cellClass: Cell.self)
	}

	private func registerConfigurator<Cell, Item>(configurator: GenericCellConfigurator<Cell, Item>) {
		let itemType = String(describing: Item.self)
		configurators[itemType] = CellConfigurator(
			configureCell: { cell, item in
				guard let cell = cell as? Cell, let item = item as? Item else { return }
				configurator.configureCell(cell, item)
			},
			didSelect: { item in
				guard let item = item as? Item else { return }
				configurator.didSelect(item)
			},
			reuseIdentifier: configurator.reuseIdentifier
		)
	}

	private func registerCellClass(cellClass: AnyClass) {
		let cellClassName = String(describing: cellClass)
		tableView.register(cellClass, forCellReuseIdentifier: cellClassName)
	}
}

// MARK: UITableViewDataSource
extension TableViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return model.numberOfSections()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return model.numberOfItemsIn(section: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellViewModel = model.viewModelAt(indexPath: indexPath)
		let viewModelClassName = String(describing: type(of: cellViewModel))

		guard let configurator = configurators[viewModelClassName] else {
			fatalError("Configurator for \(viewModelClassName) is not registered")
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath)

		configurator.configureCell(cell, cellViewModel)

		return cell
	}
}
