//
//  Loadable.swift
//  Revolut
//
//  Created by Natalia Nikitina on 16/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

protocol Loadable {
	func showLoader()
	func hideLoader()
}

extension Loadable where Self: UIViewController {
	func showLoader() {
		let loader = UIActivityIndicatorView(style: .gray)
		view.addSubview(loader)
		loader.autoCenterInSuperview()
		loader.startAnimating()
	}

	func hideLoader() {
		view.subviews.filter { $0 is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
	}
}
