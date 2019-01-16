//
//  CellConfigurator.swift
//  Revolut
//
//  Created by Natalia Nikitina on 14/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class CellConfigurator<Cell: UITableViewCell, Item> {
	let configureCell: (Cell, Item) -> Void
	let didSelect: (Item) -> Void
	let reuseIdentifier: String

	init(configureCell: @escaping (Cell, Item) -> Void, didSelect: @escaping (Item) -> Void) {
		self.configureCell = configureCell
		self.didSelect = didSelect
		self.reuseIdentifier = String(describing: Cell.self)
	}
}
