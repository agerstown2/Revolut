//
//  RatesListViewModelTests.swift
//  RevolutTests
//
//  Created by Natalia Nikitina on 22/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import XCTest
@testable import Revolut

class RatesListViewModelTests: XCTestCase {

    func testInitialValues() {
        let model = RatesListViewModel()
		XCTAssertEqual(model.amount, 100)
		XCTAssertEqual(model.baseRate, Rate(code: "EUR", doubleIndex: 1))
    }

	func testLoadEmptyRates() {
		let model = RatesListViewModel(ratesSource: MockRatesSource(result: .value([])))
		model.loadRates { result in
			XCTAssertTrue(model.rates.isEmpty)
			guard case .success = result else { return XCTFail("Result should be .success") }
		}
	}

	func testLoadSomeRates() {
		let rates = [
			RateCellViewModel(rate: Rate(code: "EUR", doubleIndex: 2), amount: 10),
			RateCellViewModel(rate: Rate(code: "RUB", doubleIndex: 5), amount: 10)
		]
		let model = RatesListViewModel(ratesSource: MockRatesSource(result: .value(rates)))
		model.loadRates { result in
			XCTAssertEqual(model.rates, rates)
			guard case .success = result else { return XCTFail("Result should be .success") }
		}
	}

	func testLoadWithError() {
		let error = CustomError(description: "Oh no")
		let model = RatesListViewModel(ratesSource: MockRatesSource(result: .error(error)))
		model.loadRates { result in
			XCTAssertTrue(model.rates.isEmpty)
			guard case let .error(e) = result else { return XCTFail("Result should be .error") }
			XCTAssertEqual(error.localizedDescription, e.localizedDescription)
		}
	}

	final class MockRatesSource: RatesLoadable {
		private let result: ValueResult<[RateCellViewModel]>

		init(result: ValueResult<[RateCellViewModel]>) {
			self.result = result
		}

		func loadRates(baseRate: Rate, amount: Double, completion: @escaping (ValueResult<[RateCellViewModel]>) -> ()) {
			completion(result)
		}
	}

}
