//
//  RatesLoadable.swift
//  Revolut
//
//  Created by Natalia Nikitina on 23/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

protocol RatesLoadable {
	func loadRates(baseRate: Rate, amount: Double, completion: @escaping (_ result: ValueResult<[RateCellViewModel]>) -> ())
}

final class RatesSource: RatesLoadable {
	private let networkingManager = NetworkingManager()

	func loadRates(baseRate: Rate, amount: Double, completion: @escaping (_ result: ValueResult<[RateCellViewModel]>) -> ()) {
		networkingManager.request(router: RatesURLRouter(baseCode: baseRate.code)) { response in
			let result: ValueResult<RatesData> = response.decode()
			switch result {
			case .value(let ratesData):
				if ratesData.rates.isEmpty {
					completion(.error(CustomError(description: "No rates")))
				} else {
					let baseRate = RateCellViewModel(rate: baseRate, amount: amount)
					let convertedRates = ratesData.rates.map { RateCellViewModel(rate: $0, amount: amount) }
					completion(.value([baseRate] + convertedRates))
				}
			case .error(let error):
				completion(.error(error))
			}
		}
	}

	private struct RatesData: Decodable {
		let base: String
		let date: String
		let rates: [Rate]

		enum Keys: String, CodingKey {
			case base = "base"
			case date = "date"
			case rates = "rates"
		}

		private init(base: String, date: String, rates: [Rate]) {
			self.base = base
			self.date = date
			self.rates = rates
		}

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: Keys.self)

			let base = try container.decode(String.self, forKey: .base)
			let date = try container.decode(String.self, forKey: .date)
			let ratesDictionary = try container.decode([String: Double].self, forKey: .rates)
			let rates = ratesDictionary.map { Rate(code: $0.key, index: $0.value) }

			self.init(base: base, date: date, rates: rates)
		}
	}
}
