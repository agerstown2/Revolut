//
//  RateInputValidator.swift
//  Revolut
//
//  Created by Natalia Nikitina on 02/02/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

final class RateInputValidator {
	static func validate(existingText: String, replacementString string: String) -> ValidationResult {
		// check for multiple zeros
		if (existingText.isEmpty || existingText == "0") && string.hasPrefix("0") {
			let trimmedString = string.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
			return .needsTextUpdate(text: trimmedString.isEmpty ? "0" : trimmedString)
		}

		// check for leading zero
		if existingText == "0" && string != "0" {
			return .needsTextUpdate(text: string)
		}

		// check for first dot
		if existingText.isEmpty && (string == "." || string == ",") {
			return .needsTextUpdate(text: "0\(string)")
		}

		// check for multiple dots
		let existingDotsNumber = existingText.contains(".") || existingText.contains(",") ? 1 : 0
		let addedDotsNumber = string.filter({ $0 == "." || $0 == "," }).count
		if existingDotsNumber + addedDotsNumber > 1 {
			return .invalid
		}

		// check for allowed characters
		let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
		if !string.isEmpty && !allowedCharacters.isSuperset(of: CharacterSet(charactersIn: string)) {
			return .invalid
		}

		return .valid
	}

	enum ValidationResult: Equatable {
		case invalid
		case valid
		case needsTextUpdate(text: String?)
	}
}
