//
//  CustomError.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

final class CustomError: LocalizedError {
	private let description: String

	init(description: String) {
		self.description = description
	}

	var errorDescription: String? {
		return description
	}
}
