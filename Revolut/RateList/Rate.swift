//
//  Currency.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

struct Rate: Equatable {
	let code: String
	let index: Double

	init(code: String, index: Double) {
		self.code = code
		self.index = index
	}
}
