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

		rateTextField.font = .systemFont(ofSize: 32)
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
}

extension RateCell {
	static var configurator: CellConfigurator<RateCell, RateCellViewModel> {
		return CellConfigurator(
			configureCell: { cell, model in
				cell.configure(model: model)
			},
			didSelect: { _ in }
		)
	}
}

struct RateCellViewModel {
	let rate: Rate
	let amount: Double
}
