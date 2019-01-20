//
//  UIEdgeInsets+Extensions.swift
//  Revolut
//
//  Created by Natalia Nikitina on 16/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	static func create(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
		return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}

	static func create(vertical: CGFloat = 0, horizontal: CGFloat = 0) -> UIEdgeInsets {
		return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
}
