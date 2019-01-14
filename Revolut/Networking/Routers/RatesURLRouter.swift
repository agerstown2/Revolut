//
//  RatesURLRouter.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

struct RatesURLRouter: URLRouter {
	private let baseCode: String

	init(baseCode: String) {
		self.baseCode = baseCode
	}

	var path: String {
		return "latest?base=\(baseCode)"
	}
}
