//
//  RateCell.swift
//  Revolut
//
//  Created by Natalia Nikitina on 12/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class RateCell: UITableViewCell {
	private let codeLabel = UILabel()
	private let rateTextView = UITextView()

	var delegate: RateCellDelegate?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupViews()
		layoutViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		codeLabel.font = .systemFont(ofSize: 24)
		codeLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
		codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

		rateTextView.font = .systemFont(ofSize: 30)
		rateTextView.keyboardType = .decimalPad
		rateTextView.isScrollEnabled = false
		rateTextView.delegate = self
	}

	private func layoutViews() {
		contentView.addSubview(codeLabel)
		codeLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
		codeLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

		contentView.addSubview(rateTextView)
		rateTextView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
		rateTextView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
		rateTextView.autoPinEdge(.leading, to: .trailing, of: codeLabel, withOffset: 16, relation: .greaterThanOrEqual)

		let underlineView = UIView()
		underlineView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
		let underlineHeight: CGFloat = 4
		underlineView.autoSetDimension(.height, toSize: underlineHeight)
		underlineView.layer.cornerRadius = underlineHeight / 2
		contentView.addSubview(underlineView)
		underlineView.autoMatch(.width, of: rateTextView, withOffset: 8)
		underlineView.autoAlignAxis(.vertical, toSameAxisOf: rateTextView)
		underlineView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
		underlineView.autoPinEdge(.top, to: .bottom, of: rateTextView, withOffset: 4)
	}

	private func configure(model: RateCellViewModel) {
		codeLabel.text = model.rate.code
		let value = model.rate.index * model.amount
		rateTextView.text = value.rateFormatted()
	}
}

// MARK: - CellConfigurator
extension RateCell {
	static var configurator: CellConfigurator<RateCell, RateCellViewModel, RatesListViewModel> {
		return CellConfigurator(
			configureCell: { cell, model, tableViewModel in
				cell.configure(model: model)
				cell.rateTextView.isUserInteractionEnabled = false
				cell.delegate = tableViewModel
			},
			didSelect: { cell, indexPath in
				cell.rateTextView.isUserInteractionEnabled = true
				cell.rateTextView.becomeFirstResponder()
				cell.delegate?.cellSelected(indexPath: indexPath)
			}
		)
	}
}

// MARK: - UITextViewDelegate
extension RateCell: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		let amount = rateTextView.text.map { Double($0) ?? 0 } ?? 0
		delegate?.amountChanged(amount)
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		switch RateInputValidator.validate(existingText: textView.text, replacementString: text) {
		case .invalid:
			return false
		case .valid: ()
		case .needsTextUpdate(let text):
			textView.text = text
			delegate?.amountChanged(text.map { Double($0) ?? 0 } ?? 0)
			return false
		}

		let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
		return text.isEmpty || allowedCharacters.isSuperset(of: CharacterSet(charactersIn: text))
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		textView.isUserInteractionEnabled = false
	}
}

final class RateCellViewModel {
	var rate: Rate
	var amount: Double

	init(rate: Rate, amount: Double) {
		self.rate = rate
		self.amount = amount
	}
}

extension RateCellViewModel: Equatable {
	static func == (lhs: RateCellViewModel, rhs: RateCellViewModel) -> Bool {
		return lhs.rate == rhs.rate && lhs.amount == rhs.amount
	}
}

protocol RateCellDelegate {
	func amountChanged(_ amount: Double)
	func cellSelected(indexPath: IndexPath)
}
