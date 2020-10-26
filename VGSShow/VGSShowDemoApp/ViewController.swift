//
//  ViewController.swift
//  VGSShowDemoApp
//
//  Created by Dima on 23.10.2020.
//

import UIKit
import VGSShow

final class DemoAppConfig {

	/// Add vault id here:
	static let vault = ""

	/// Add test payload here id here:
	static let payload: JsonData = [:]

	/// Add test path here:
	static let path = "post"
}

class ViewController: UIViewController {

  let vgsShow = VGSShow(id: DemoAppConfig.vault, environment: .sandbox)

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

	loadData()
  }

  private func loadData() {
	vgsShow.fetchData(path: DemoAppConfig.path, method: .post, payload: DemoAppConfig.payload) { (response) in
		print(response)
	}
  }
}
