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

	var baseRate = Rate(code: "EUR", index: 1)
	var amount: Double = 100

	private weak var timer: Timer?
	private var lastUpdateTime = Date()

	private var indexPathsExceptFirst: [IndexPath] {
		return rates.count > 1 ? Array(1..<rates.count).map { IndexPath(row: $0, section: 0) } : []
	}

	weak var delegate: TableViewModelDelegate?

	private let ratesSource: RatesLoadable

	init(ratesSource: RatesLoadable = RatesSource()) {
		self.ratesSource = ratesSource
	}

	func loadRates(completion: @escaping (_ result: Result) -> ()) {
		ratesSource.loadRates(baseRate: baseRate, amount: amount) { result in
			switch result {
			case .value(let rates):
				self.rates = rates
				self.setupTimer()
				completion(.success)
			case .error(let error):
				completion(.error(error))
			}
		}
	}

	private func setupTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			let currentTime = Date()
			if currentTime.timeIntervalSince(self.lastUpdateTime) >= 1 {
				self.reloadRates()
				self.lastUpdateTime = currentTime
			}
		}
	}

	private func reloadRates() {
		loadRates { [weak self] result in
			guard case .success = result, let self = self else { return }
			self.delegate?.setNeedsReload(indexPaths: self.indexPathsExceptFirst)
		}
	}

	private func updateRates() {
		rates = rates.map { RateCellViewModel(rate: $0.rate, amount: self.amount) }
	}

	deinit {
		timer?.invalidate()
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
		
		delegate?.setNeedsReload(indexPaths: indexPathsExceptFirst)
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
