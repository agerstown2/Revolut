//
//  Currency.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import SwiftyJSON

struct Rate {
	let code: String
	let index: Double
	
	init?(code: String, index: JSON) {
		guard let index = index.double else { return nil }
		self.code = code
		self.index = index
	}
}
