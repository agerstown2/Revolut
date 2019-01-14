//
//  CellConfigurator.swift
//  Revolut
//
//  Created by Natalia Nikitina on 14/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class CellConfigurator {
	let configureCell: (UITableViewCell, Any) -> Void
	let didSelect: (Any) -> Void
	let reuseIdentifier: String

	init(configureCell: @escaping (UITableViewCell, Any) -> Void, didSelect: @escaping (Any) -> Void, reuseIdentifier: String) {
		self.configureCell = configureCell
		self.didSelect = didSelect
		self.reuseIdentifier = reuseIdentifier
	}
}

final class GenericCellConfigurator<Cell: UITableViewCell, Item> {
	let configureCell: (Cell, Item) -> Void
	let didSelect: (Item) -> Void
	let reuseIdentifier: String

	init(configureCell: @escaping (Cell, Item) -> Void, didSelect: @escaping (Item) -> Void) {
		self.configureCell = configureCell
		self.didSelect = didSelect
		self.reuseIdentifier = String(describing: Cell.self)
	}
}
