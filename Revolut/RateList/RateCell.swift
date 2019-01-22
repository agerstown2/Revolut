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
	private let rateTextField = UITextField()

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

		rateTextField.font = .systemFont(ofSize: 30)
		rateTextField.keyboardType = .decimalPad
		rateTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		rateTextField.delegate = self
	}

	private func layoutViews() {
		contentView.addSubview(codeLabel)
		codeLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
		codeLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

		contentView.addSubview(rateTextField)
		rateTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
		rateTextField.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
		rateTextField.autoPinEdge(.leading, to: .trailing, of: codeLabel, withOffset: 16, relation: .greaterThanOrEqual)

		let underlineView = UIView()
		underlineView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
		let underlineHeight: CGFloat = 4
		underlineView.autoSetDimension(.height, toSize: underlineHeight)
		underlineView.layer.cornerRadius = underlineHeight / 2
		contentView.addSubview(underlineView)
		underlineView.autoMatch(.width, to: .width, of: rateTextField, withOffset: 8)
		underlineView.autoAlignAxis(.vertical, toSameAxisOf: rateTextField)
		underlineView.autoPinEdge(toSuperviewEdge: .bottom)
		underlineView.autoPinEdge(.top, to: .bottom, of: rateTextField, withOffset: 4)
	}

	private func configure(model: RateCellViewModel) {
		codeLabel.text = model.rate.code
		let value = model.rate.index * model.amount
		rateTextField.text = value.rateFormatted()
	}

	@objc private func textFieldDidChange() {
		let amount = rateTextField.text.map { Double($0) ?? 0 } ?? 0
		delegate?.amountChanged(amount)
	}
}

// MARK: - CellConfigurator
extension RateCell {
	static var configurator: CellConfigurator<RateCell, RateCellViewModel, RatesListViewModel> {
		return CellConfigurator(
			configureCell: { cell, model, tableViewModel in
				cell.configure(model: model)
				cell.rateTextField.isUserInteractionEnabled = false
				cell.delegate = tableViewModel
			},
			didSelect: { cell, indexPath in
				cell.rateTextField.isUserInteractionEnabled = true
				cell.rateTextField.becomeFirstResponder()
				cell.delegate?.cellSelected(indexPath: indexPath)
			}
		)
	}
}

// MARK: - UITextFieldDelegate
extension RateCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let text = textField.text {
			if text == "0" && string == "0" {
				return false
			}

			if text == "0" && string != "0" {
				textField.text = ""
			}
		}

		let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
		let hasAllowedCharsOnly = allowedCharacters.isSuperset(of: CharacterSet(charactersIn: string))
		return string.isEmpty || textField.text.map { $0.count < 6 } ?? true && hasAllowedCharsOnly
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.isUserInteractionEnabled = false
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
