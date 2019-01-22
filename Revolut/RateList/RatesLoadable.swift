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
	func loadRates(baseRate: Rate, amount: Double, completion: @escaping (_ result: ValueResult<[RateCellViewModel]>) -> ()) {
		NetworkingManager.shared.request(router: RatesURLRouter(baseCode: baseRate.code)) { response in
			switch response.jsonData {
			case .value(let json):
				let ratesJSON = json["rates"].dictionaryValue
				if ratesJSON.isEmpty {
					completion(.error(CustomError(description: "No rates")))
				} else {
					let baseRate = RateCellViewModel(rate: baseRate, amount: amount)
					let convertedRates: [RateCellViewModel] = ratesJSON.compactMap { rateJSON in
						let rate = Rate(code: rateJSON.key, index: rateJSON.value)
						return rate.map { RateCellViewModel(rate: $0, amount: amount) }
					}
					completion(.value([baseRate] + convertedRates))
				}
			case .error(let error):
				completion(.error(error))
			}
		}
	}
}
