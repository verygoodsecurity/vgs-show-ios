//
//  UIViewController+Extensions.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 16.11.2020.
//

import Foundation
import UIKit

extension UIViewController {
	// swiftlint:disable
	static func show(message: String, controller: UIViewController) {
		let toastView = UIView(frame: .zero)
		toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		toastView.alpha = 0.0
		toastView.layer.cornerRadius = 20
		toastView.clipsToBounds  =  true
		
		let toastLabel = UILabel(frame: CGRect())
		toastLabel.textColor = UIColor.white
		toastLabel.textAlignment = .center
		toastLabel.font.withSize(12.0)
		toastLabel.text = message
		toastLabel.clipsToBounds  =  true
		toastLabel.numberOfLines = 0
		
		toastView.addSubview(toastLabel)
		controller.view.addSubview(toastView)
		
		toastLabel.translatesAutoresizingMaskIntoConstraints = false
		toastView.translatesAutoresizingMaskIntoConstraints = false
		
		let labelConstraint1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastView, attribute: .leading, multiplier: 1, constant: 15)
		let labelConstraint2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastView, attribute: .trailing, multiplier: 1, constant: -15)
		let labelConstraint3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastView, attribute: .bottom, multiplier: 1, constant: -15)
		let labelConstraint4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastView, attribute: .top, multiplier: 1, constant: 15)
		toastView.addConstraints([labelConstraint1, labelConstraint2, labelConstraint3, labelConstraint4])
		
		let toastConstraint1 = NSLayoutConstraint(item: toastView, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
		let toastConstraint2 = NSLayoutConstraint(item: toastView, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)

		let toastConstraint3: NSLayoutConstraint
		if #available(iOS 11.0, *) {
			toastConstraint3 = NSLayoutConstraint(item: toastView, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 20)
		} else {
			toastConstraint3 = NSLayoutConstraint(item: toastView, attribute: .top, relatedBy: .equal, toItem: controller.view, attribute: .top, multiplier: 1, constant: 20)
		}
		controller.view.addConstraints([toastConstraint1, toastConstraint2, toastConstraint3])
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
			toastView.alpha = 1.0
		}, completion: { _ in
			UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
				toastView.alpha = 0.0
			}, completion: {_ in
				toastView.removeFromSuperview()
			})
		})
	}

	func enforceLoadView() {
		_ = self.view
	}
}
