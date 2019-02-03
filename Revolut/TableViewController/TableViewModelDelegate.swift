//
//  TableViewModelDelegate.swift
//  Revolut
//
//  Created by Natalia Nikitina on 20/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

protocol TableViewModelDelegate: class {
	func setNeedsReload(indexPaths: [IndexPath], animated: Bool, visibleOnly: Bool)
	func move(at: IndexPath, to: IndexPath)
	func scrollToTop()
}
