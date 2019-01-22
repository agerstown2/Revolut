//
//  Double+RateFormattingTests.swift
//  RevolutTests
//
//  Created by Natalia Nikitina on 22/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import XCTest
@testable import Revolut

class RateFormattingTests: XCTestCase {

	func testThreeFractionDigits() {
		let doubleValue = 1.555
		let string = doubleValue.rateFormatted()
		XCTAssertEqual(string, "1.555")
	}

	func testZeroesFractionDigits() {
		let doubleValue = 1.000
		let string = doubleValue.rateFormatted()
		XCTAssertEqual(string, "1")
	}

	func testMoreThanThreeFractionDigitsMoreThanHalf() {
		let doubleValue = 1.2556
		let string = doubleValue.rateFormatted()
		XCTAssertEqual(string, "1.256")
	}

	func testMoreThanThreeFractionDigitsLessThanHalf() {
		let doubleValue = 1.2554
		let string = doubleValue.rateFormatted()
		XCTAssertEqual(string, "1.255")
	}

	func testWholeNumber() {
		let doubleValue: Double = 2
		let string = doubleValue.rateFormatted()
		XCTAssertEqual(string, "2")
	}

}
