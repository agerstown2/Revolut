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

	}

	private func layoutViews() {
		contentView.addSubview(codeLabel)
		codeLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
		codeLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

		contentView.addSubview(rateTextField)
		rateTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
		rateTextField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 16), excludingEdge: .leading)
		rateTextField.autoPinEdge(.leading, to: .trailing, of: codeLabel, withOffset: 16, relation: .greaterThanOrEqual)
	}

	private func configure(rate: Rate) {
		codeLabel.text = rate.code
		rateTextField.text = "\(rate.index)"
	}
}

extension RateCell {
	static var configurator: GenericCellConfigurator<RateCell, Rate> {
		return GenericCellConfigurator(
			configureCell: { cell, rate in
				cell.configure(rate: rate)
			},
			didSelect: { _ in }
		)
	}
}
