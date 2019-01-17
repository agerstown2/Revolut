//
//  TableViewController.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class TableViewController: NSObject {
	private var configurators: [String: GeneralCellConfigurator] = [:]
	private var model: TableViewModel

	let tableView = UITableView(frame: .zero, style: .plain)

	init(model: TableViewModel) {
		self.model = model

		super.init()

		self.model.delegate = self

		tableView.separatorStyle = .none

		tableView.dataSource = self
		tableView.delegate = self
	}
}

// MARK: - TableViewModelDelegate
extension TableViewController: TableViewModelDelegate {
	func setNeedsReload(indexPaths: [IndexPath]) {
		tableView.reloadRows(at: indexPaths, with: .none)
	}

	func move(at: IndexPath, to: IndexPath) {
		tableView.moveRow(at: at, to: to)
	}
}

// MARL: - Cell configurators registration
extension TableViewController {
	func register<Cell: UITableViewCell, Item, TableModel: TableViewModel>(configurator: CellConfigurator<Cell, Item, TableModel>) {
		registerConfigurator(configurator: configurator)
		registerCellClass(cellClass: Cell.self)
	}

	private func registerConfigurator<Cell, Item, TableModel: TableViewModel>(configurator: CellConfigurator<Cell, Item, TableModel>) {
		let itemType = String(describing: Item.self)
		configurators[itemType] = GeneralCellConfigurator(
			configureCell: { [weak self] cell, item in
				guard let self = self, let cell = cell as? Cell, let item = item as? Item, let model = self.model as? TableModel else { return }
				configurator.configureCell(cell, item, model)
			},
			didSelect: { cell, indexPath in
				guard let cell = cell as? Cell else { return }
				configurator.didSelect(cell, indexPath)
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

extension TableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let cellViewModel = model.viewModelAt(indexPath: indexPath)
		let viewModelClassName = String(describing: type(of: cellViewModel))

		guard let configurator = configurators[viewModelClassName] else {
			fatalError("Configurator for \(viewModelClassName) is not registered")
		}

		guard let cell = tableView.cellForRow(at: indexPath) else { return }

		configurator.didSelect(cell, indexPath)
	}
}

fileprivate final class GeneralCellConfigurator {
	let configureCell: (UITableViewCell, Any) -> Void
	let didSelect: (UITableViewCell, IndexPath) -> Void
	let reuseIdentifier: String

	init(configureCell: @escaping (UITableViewCell, Any) -> Void, didSelect: @escaping (UITableViewCell, IndexPath) -> Void, reuseIdentifier: String) {
		self.configureCell = configureCell
		self.didSelect = didSelect
		self.reuseIdentifier = reuseIdentifier
	}
}
