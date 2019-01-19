//
//  KeyboardOffsetController.swift
//  Revolut
//
//  Created by Natalia Nikitina on 19/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit
import NotificationCenter

final class KeyboardOffsetController {

	private weak var view: UIView?
	private weak var constraint: NSLayoutConstraint?

	init(view: UIView, constraint: NSLayoutConstraint?) {
		self.view = view
		self.constraint = constraint

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillChangeFrame(notification:)),
			name: UIResponder.keyboardWillChangeFrameNotification,
			object: nil
		)
	}

	@objc private func keyboardWillChangeFrame(notification: Notification) {
		guard let view = view, let info = notification.userInfo,
			let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
			let animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

		constraint?.constant = keyboardFrame.origin.y - view.frame.height
		UIView.animate(withDuration: animationDuration) {
			view.layoutIfNeeded()
		}
	}
}
