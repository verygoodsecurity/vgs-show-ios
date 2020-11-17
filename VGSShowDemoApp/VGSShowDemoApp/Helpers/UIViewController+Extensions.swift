//
//  UIViewController+Extensions.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 16.11.2020.
//

import Foundation
import UIKit

extension UIViewController {
	static func show(message: String, controller: UIViewController) {
		let toastContainer = UIView(frame: .zero)
		toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		toastContainer.alpha = 0.0
		toastContainer.layer.cornerRadius = 20;
		toastContainer.clipsToBounds  =  true
		
		let toastLabel = UILabel(frame: CGRect())
		toastLabel.textColor = UIColor.white
		toastLabel.textAlignment = .center;
		toastLabel.font.withSize(12.0)
		toastLabel.text = message
		toastLabel.clipsToBounds  =  true
		toastLabel.numberOfLines = 0
		
		toastContainer.addSubview(toastLabel)
		controller.view.addSubview(toastContainer)
		
		toastLabel.translatesAutoresizingMaskIntoConstraints = false
		toastContainer.translatesAutoresizingMaskIntoConstraints = false
		
		let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
		let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
		let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
		let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
		toastContainer.addConstraints([a1, a2, a3, a4])
		
		let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
		let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
		let c3 = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 20)
		controller.view.addConstraints([c1, c2, c3])
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
			toastContainer.alpha = 1.0
		}, completion: { _ in
			UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
				toastContainer.alpha = 0.0
			}, completion: {_ in
				toastContainer.removeFromSuperview()
			})
		})
	}
}
