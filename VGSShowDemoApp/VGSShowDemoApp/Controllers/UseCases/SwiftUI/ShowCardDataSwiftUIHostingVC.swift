//
//  ShowCardDataSwiftUIHostingVC.swift
//  VGSShowDemoApp
//


import Foundation
import SwiftUI

@available(iOS 14.0, *)
class ShowCardDataSwiftUIHostingVC: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let swiftUIView = ShowCardDataSwiftUIDemo()
    let hostingController = UIHostingController(rootView: swiftUIView)
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)

      NSLayoutConstraint.activate([
          hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
          hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

    hostingController.didMove(toParent: self)
  }
}
