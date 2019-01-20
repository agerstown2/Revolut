//
//  TableViewModel.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

protocol TableViewModel {
	func numberOfSections() -> Int
	func numberOfItemsIn(section: Int) -> Int
	func viewModelAt(indexPath: IndexPath) -> Any

	var delegate: TableViewModelDelegate? { get set }
}

extension TableViewModel {
	func numberOfSections() -> Int {
		return 1
	}
}
