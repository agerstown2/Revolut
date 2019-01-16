//
//  Double+Rate.swift
//  Revolut
//
//  Created by Natalia Nikitina on 16/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

extension Double {
	func rateFormatted() -> String {
		let formatter = NumberFormatter()
		let number = NSNumber(value: self)
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 3
		return String(formatter.string(from: number) ?? "")
	}
}
