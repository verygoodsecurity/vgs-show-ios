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
	static let vaultId = "valutId"

	/// Add test payload here id here:
	static let payload: JsonData = [:]

	/// Add test path here:
	static let path = "post"
}

class ViewController: UIViewController {

  @IBOutlet weak var stackView: UIStackView!
  
	let vgsShow = VGSShow(vaultId: DemoAppConfig.vaultId, environment: .sandbox)
  let showLabel = VGSLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureUI()
    loadData()
  }
  
  private func configureUI() {
    showLabel.textColeo
    stackView.addArrangedSubview(showLabel)
  }

  private func loadData() {
    vgsShow.request(path: DemoAppConfig.path, method: .post, payload: DemoAppConfig.payload) { (requestResult) in
      switch requestResult {
      case .success(let code):
          print(code)
      case .failure(let code, let error):
        print(code, error)
      }
    }
  }
}
