//
//  CellConfigurator.swift
//  Revolut
//
//  Created by Natalia Nikitina on 14/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class CellConfigurator<Cell: UITableViewCell, Item, TableModel: TableViewModel> {
	let configureCell: (Cell, Item, TableModel) -> Void
	let didSelect: (Cell, IndexPath) -> Void
	let reuseIdentifier: String

	init(configureCell: @escaping (Cell, Item, TableModel) -> Void, didSelect: @escaping (Cell, IndexPath) -> Void) {
		self.configureCell = configureCell
		self.didSelect = didSelect
		self.reuseIdentifier = String(describing: Cell.self)
	}
}
