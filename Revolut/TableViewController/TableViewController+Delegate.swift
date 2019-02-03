//
//  TableViewController+TableViewModelDelegate.swift
//  Revolut
//
//  Created by Natalia Nikitina on 20/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation
import UIKit

extension TableViewController: TableViewModelDelegate {
	func setNeedsReload(indexPaths: [IndexPath], animated: Bool, visibleOnly: Bool) {
		func reloadRowsAtIndexPath(indexPaths: [IndexPath]) {
			if animated {
				tableView.reloadRows(at: indexPaths, with: .automatic)
			} else {
				UIView.performWithoutAnimation {
					tableView.reloadRows(at: indexPaths, with: .none)
				}
			}
		}

		if visibleOnly {
			let visibleIndexPaths = tableView.visibleCells.compactMap { tableView.indexPath(for: $0) }
			let filteredIndexPaths = visibleIndexPaths.filter { indexPaths.contains($0) }
			reloadRowsAtIndexPath(indexPaths: filteredIndexPaths)
		} else {
			reloadRowsAtIndexPath(indexPaths: indexPaths)
		}
	}

	func move(at: IndexPath, to: IndexPath) {
		tableView.moveRow(at: at, to: to)
	}

	func scrollToTop() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}
}
