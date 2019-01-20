//
//  TableViewController+TableViewModelDelegate.swift
//  Revolut
//
//  Created by Natalia Nikitina on 20/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

extension TableViewController: TableViewModelDelegate {
	func setNeedsReload(indexPaths: [IndexPath]) {
		tableView.reloadRows(at: indexPaths, with: .none)
	}

	func move(at: IndexPath, to: IndexPath) {
		tableView.moveRow(at: at, to: to)
	}

	func scrollToTop() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}
}
