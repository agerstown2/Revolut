//
//  RateInputValidatorTests.swift
//  RevolutTests
//
//  Created by Natalia Nikitina on 03/02/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import XCTest
@testable import Revolut

class RateInputValidatorTests: XCTestCase {

	private typealias ValidationResult = RateInputValidator.ValidationResult

	func testMultipleZerosAlreadyHaveLeadingZero() {
		let result = validate(existingText: "0", replacementString: "0")
		XCTAssertEqual(result, ValidationResult.needsTextUpdate(text: "0"))
	}

	func testMultipleZerosAddedMoreThanOneZero() {
		let result = validate(existingText: "", replacementString: "00")
		XCTAssertEqual(result, ValidationResult.needsTextUpdate(text: "0"))
	}

	func testMultipleZerosAlreadyHaveLeadingZeroAndAddedMoreThanOneZero() {
		let result = validate(existingText: "0", replacementString: "00")
		XCTAssertEqual(result, ValidationResult.needsTextUpdate(text: "0"))
	}

	func testLeadingZero() {
		let result = validate(existingText: "0", replacementString: "7")
		XCTAssertEqual(result, ValidationResult.needsTextUpdate(text: "7"))
	}

	func testLeadingDot() {
		let result = validate(existingText: "", replacementString: ".")
		XCTAssertEqual(result, ValidationResult.needsTextUpdate(text: "0."))
	}

	func testLeadingComma() {
		let result = validate(existingText: "", replacementString: ",")
		XCTAssertEqual(result, ValidationResult.needsTextUpdate(text: "0,"))
	}

	func testMultipleAddedDots() {
		let result = validate(existingText: "5", replacementString: "...")
		XCTAssertEqual(result, ValidationResult.invalid)
	}

	func testMultipleAddedCommas() {
		let result = validate(existingText: "5", replacementString: ",,,")
		XCTAssertEqual(result, ValidationResult.invalid)
	}

	func testMultipleTotalDots() {
		let result = validate(existingText: "5.6", replacementString: ".")
		XCTAssertEqual(result, ValidationResult.invalid)
	}

	func testMultipleTotalCommas() {
		let result = validate(existingText: "5,", replacementString: ",")
		XCTAssertEqual(result, ValidationResult.invalid)
	}

	func testMultipleDotsAndCommas() {
		let result = validate(existingText: "5,6", replacementString: ".")
		XCTAssertEqual(result, ValidationResult.invalid)
	}

	func testAllowedCharactersValid() {
		let result = validate(existingText: "5", replacementString: ".6")
		XCTAssertEqual(result, ValidationResult.valid)
	}

	func testAllowedCharactersInvalid() {
		let result = validate(existingText: "5", replacementString: "abc")
		XCTAssertEqual(result, ValidationResult.invalid)
	}

	private func validate(existingText: String, replacementString: String) -> ValidationResult {
		return RateInputValidator.validate(existingText: existingText, replacementString: replacementString)
	}

}
