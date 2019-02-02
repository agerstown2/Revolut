//
//  UIView+Constraints.swift
//  Revolut
//
//  Created by Natalia Nikitina on 02/02/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import UIKit

enum Edge: CaseIterable {
	case leading, top, trailing, bottom
}

enum Axis {
	case vertical, horizontal
}

enum Dimension {
	case height, width
}

extension UIView {
	private func xAxisAnchor(edge: Edge) -> NSLayoutAnchor<NSLayoutXAxisAnchor>? {
		switch edge {
		case .leading: return leadingAnchor
		case .trailing: return trailingAnchor
		default: return nil
		}
	}

	private func yAxisAnchor(edge: Edge) -> NSLayoutAnchor<NSLayoutYAxisAnchor>? {
		switch edge {
		case .top: return topAnchor
		case .bottom: return bottomAnchor
		default: return nil
		}
	}

	private func offset(_ offset: CGFloat, forEdge edge: Edge) -> CGFloat {
		switch edge {
		case .leading, .top: return offset
		case .trailing, .bottom: return -offset
		}
	}
}

extension UIView {
	func autoPinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero, excludingEdge edge: Edge? = nil) {
		Edge.allCases.filter { $0 != edge }.forEach { autoPinEdge(toSuperviewEdge: $0) }
	}

	@discardableResult
	func autoPinEdge(toSuperviewEdge edge: Edge, withInset inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
		guard let superview = superview else { return nil }

		return autoPinEdge(edge, to: edge, of: superview, withOffset: inset, relation: relation)
	}

	func autoCenterInSuperview() {
		autoAlignAxis(toSuperviewAxis: .vertical)
		autoAlignAxis(toSuperviewAxis: .horizontal)
	}

	func autoAlignAxis(toSuperviewAxis axis: Axis) {
		guard let superview = superview else { return }

		autoAlignAxis(axis, toSameAxisOf: superview)
	}
}

extension UIView {
	@discardableResult
	func autoPinEdge(_ edge: Edge, to otherViewEdge: Edge, of otherView: UIView, withOffset offset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
		translatesAutoresizingMaskIntoConstraints = false

		var constraint: NSLayoutConstraint?

		let realOffset = self.offset(offset, forEdge: edge)

		if let xAxisAnchor = xAxisAnchor(edge: edge), let superviewXAxisAnchor = otherView.xAxisAnchor(edge: otherViewEdge) {
			constraint = {
				switch relation {
				case .equal:
					return xAxisAnchor.constraint(equalTo: superviewXAxisAnchor, constant: realOffset)
				case .greaterThanOrEqual:
					return xAxisAnchor.constraint(greaterThanOrEqualTo: superviewXAxisAnchor, constant: realOffset)
				case .lessThanOrEqual:
					return xAxisAnchor.constraint(lessThanOrEqualTo: superviewXAxisAnchor, constant: realOffset)
				}
			}()
		}

		if let yAxisAnchor = yAxisAnchor(edge: edge), let superviewYAxisAnchor = otherView.yAxisAnchor(edge: otherViewEdge) {
			constraint = {
				switch relation {
				case .equal:
					return yAxisAnchor.constraint(equalTo: superviewYAxisAnchor, constant: realOffset)
				case .greaterThanOrEqual:
					return yAxisAnchor.constraint(greaterThanOrEqualTo: superviewYAxisAnchor, constant: realOffset)
				case .lessThanOrEqual:
					return yAxisAnchor.constraint(lessThanOrEqualTo: superviewYAxisAnchor, constant: realOffset)
				}
			}()
		}

		constraint?.isActive = true

		return constraint
	}

	func autoSetDimension(_ dimension: Dimension, toSize size: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false

		switch dimension {
		case .height:
			heightAnchor.constraint(equalToConstant: size).isActive = true
		case .width:
			widthAnchor.constraint(equalToConstant: size).isActive = true
		}
	}

	func autoAlignAxis(_ axis: Axis, toSameAxisOf otherView: UIView) {
		translatesAutoresizingMaskIntoConstraints = false

		switch axis {
		case .horizontal:
			centerYAnchor.constraint(equalTo: otherView.centerYAnchor).isActive = true
		case .vertical:
			centerXAnchor.constraint(equalTo: otherView.centerXAnchor).isActive = true
		}
	}

	func autoMatch(_ dimension: Dimension, of otherView: UIView, withOffset offset: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false

		switch dimension {
		case .height:
			heightAnchor.constraint(equalTo: otherView.heightAnchor, multiplier: 1, constant: offset).isActive = true
		case .width:
			widthAnchor.constraint(equalTo: otherView.widthAnchor, multiplier: 1, constant: offset).isActive = true
		}
	}
}
