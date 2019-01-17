//
//  RatesListViewModel.swift
//  Revolut
//
//  Created by Natalia Nikitina on 12/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Foundation

final class RatesListViewModel {
	private(set) var rates: [RateCellViewModel] = []

	var baseCode: String = "EUR"
	var amount: Double = 100

	var delegate: TableViewModelDelegate?

	func loadRates(completion: @escaping (_ result: Result) -> ()) {
		NetworkingManager.shared.request(router: RatesURLRouter(baseCode: baseCode)) { response in
			switch response.jsonData {
			case .value(let json):
				let ratesJSON = json["rates"].dictionaryValue
				if ratesJSON.isEmpty {
					completion(.error(CustomError(description: "No rates")))
				} else {
					let baseRate = RateCellViewModel(rate: Rate(code: self.baseCode, index: 1), amount: self.amount)
					let convertedRates: [RateCellViewModel] = ratesJSON.compactMap { rateJSON in
						let rate = Rate(code: rateJSON.key, index: rateJSON.value)
						return rate.map { RateCellViewModel(rate: $0, amount: self.amount) }
					}
					self.rates = [baseRate] + convertedRates
					completion(.success)
				}
			case .error(let error):
				completion(.error(error))
			}
		}
	}

	private func updateRates() {
		rates = rates.map { RateCellViewModel(rate: $0.rate, amount: self.amount) }
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

extension RatesListViewModel: RateCellDelegate {
	func amountChanged(_ amount: Double) {
		self.amount = amount
		updateRates()
		
		delegate?.setNeedsReload(indexPaths: Array(1..<rates.count).map { IndexPath(row: $0, section: 0) })
	}

	func cellSelected(indexPath: IndexPath) {
		let selectedRate = rates[indexPath.row]
		rates.remove(at: indexPath.row)
		rates.insert(selectedRate, at: 0)

		delegate?.move(at: indexPath, to: IndexPath(row: 0, section: 0))
	}
}
