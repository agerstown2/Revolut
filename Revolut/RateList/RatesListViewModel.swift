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

	var baseRate = Rate(code: "EUR", index: Double(100))
	var amount: Double = 1

	var delegate: TableViewModelDelegate?

	func loadRates(completion: @escaping (_ result: Result) -> ()) {
		NetworkingManager.shared.request(router: RatesURLRouter(baseCode: baseRate.code)) { response in
			switch response.jsonData {
			case .value(let json):
				let ratesJSON = json["rates"].dictionaryValue
				if ratesJSON.isEmpty {
					completion(.error(CustomError(description: "No rates")))
				} else {
					let baseRate = RateCellViewModel(rate: self.baseRate, amount: self.amount)
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

// MARK: - TableViewModel
extension RatesListViewModel: TableViewModel {
	func numberOfItemsIn(section: Int) -> Int {
		return rates.count
	}

	func viewModelAt(indexPath: IndexPath) -> Any {
		return rates[indexPath.row]
	}
}

// MARK: - RateCellDelegate
extension RatesListViewModel: RateCellDelegate {
	func amountChanged(_ amount: Double) {
		self.amount = amount
		updateRates()
		
		delegate?.setNeedsReload(indexPaths: Array(1..<rates.count).map { IndexPath(row: $0, section: 0) })
	}

	func cellSelected(indexPath: IndexPath) {
		let selectedRate = rates[indexPath.row]

		amount = selectedRate.rate.index * amount
		baseRate = Rate(code: selectedRate.rate.code, index: 1)

		recalculateIndexes(baseIndex: selectedRate.rate.index)

		rates.remove(at: indexPath.row)
		rates.insert(selectedRate, at: 0)

		delegate?.move(at: indexPath, to: IndexPath(row: 0, section: 0))

		var indexes = Array(0..<rates.count)
		indexes.remove(at: indexPath.row)
		indexes.removeFirst()

		let indexPathsToReload = indexes.map { IndexPath(row: $0, section: 0)  }

		delegate?.setNeedsReload(indexPaths: indexPathsToReload)
		delegate?.scrollToTop()
	}

	private func recalculateIndexes(baseIndex: Double) {
		rates.forEach { model in
			model.rate = Rate(code: model.rate.code, index: model.rate.index / baseIndex)
			model.amount = amount
		}
	}
}
