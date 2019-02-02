//
//  ErrorManager.swift
//  Revolut
//
//  Created by Natalia Nikitina on 16/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

final class ErrorManager {
	private weak var view: UIView?
	private let errorView: ErrorView

	init(view: UIView, message: String, retry: @escaping () -> ()) {
		self.view = view
		self.errorView = ErrorView(message: message, retry: retry)
	}

	func showError() {
		view?.addSubview(errorView)
		errorView.autoPinEdgesToSuperviewEdges()
	}
}

final class ErrorView: UIView {
	private let messageLabel = UILabel()
	private let retryButton = UIButton()

	private let retryButtonHeight: CGFloat = 32

	private let retry: () -> ()

	init(message: String, retry: @escaping () -> ()) {
		self.retry = retry

		super.init(frame: .zero)

		setupViews()
		layoutViews()

		messageLabel.text = message
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		messageLabel.numberOfLines = 0
		messageLabel.font = .systemFont(ofSize: 20)
		messageLabel.textAlignment = .center

		retryButton.backgroundColor = UIColor.blue.withAlphaComponent(0.3)

		retryButton.contentEdgeInsets = .create(horizontal: 16)
		retryButton.layer.cornerRadius = retryButtonHeight / 2

		retryButton.setTitle("Retry", for: .normal)
		retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
	}

	private func layoutViews() {
		let retryButtonWrapper = UIView()
		retryButtonWrapper.addSubview(retryButton)
		retryButton.autoPinEdge(toSuperviewEdge: .top)
		retryButton.autoPinEdge(toSuperviewEdge: .bottom)
		retryButton.autoAlignAxis(toSuperviewAxis: .vertical)

		let stackView = UIStackView(arrangedSubviews: [messageLabel, retryButtonWrapper])
		stackView.axis = .vertical
		stackView.spacing = 16

		addSubview(stackView)
		stackView.autoCenterInSuperview()
		stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
		stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)

		retryButton.autoSetDimension(.height, toSize: retryButtonHeight)
	}

	@objc private func retryButtonTapped() {
		removeFromSuperview()
		retry()
	}
}
