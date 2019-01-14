//
//  RatesListViewModel.swift
//  Revolut
//
//  Created by Natalia Nikitina on 12/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

final class RatesListViewModel {
	private var baseCode: String = "EUR"
	private(set) var rates: [Rate] = []

	func loadRates(completion: @escaping (_ result: Result) -> ()) {
		NetworkingManager.shared.request(router: RatesURLRouter(baseCode: baseCode)) { response in
			switch response.jsonData {
			case .value(let json):
				let ratesJSON = json["rates"].dictionaryValue
				if ratesJSON.isEmpty {
					completion(.error(CustomError(description: "No rates")))
				} else {
					self.rates = ratesJSON.compactMap { rate in Rate(code: rate.key, index: rate.value) }
					completion(.success)
				}
			case .error(let error):
				completion(.error(error))
			}
		}
	}
}

extension RatesListViewModel: TableViewModel {
	func numberOfItemsIn(section: Int) -> Int {
		return rates.count
	}

	func viewModelAt(indexPath: IndexPath) -> Any {
		return rates[indexPath.row]
	}
}
