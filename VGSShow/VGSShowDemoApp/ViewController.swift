//
//  ViewController.swift
//  VGSShowDemoApp
//
//  Created by Dima on 23.10.2020.
//

import UIKit
import VGSShow

class ViewController: UIViewController {

  @IBOutlet weak var stackView: UIStackView!
  
	let vgsShow = VGSShow(vaultId: DemoAppConfig.shared.vaultId, environment: .sandbox)
  let showLabel = VGSLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureUI()
    loadData()
  }
  
  private func configureUI() {
	showLabel.textColor = .black
    stackView.addArrangedSubview(showLabel)
  }

  private func loadData() {
	vgsShow.request(path: DemoAppConfig.shared.path, method: .post, payload: DemoAppConfig.shared.payload) { (requestResult) in
      switch requestResult {
      case .success(let code):
          print(code)
      case .failure(let code, let error):
        print(code, error)
      }
    }
  }
}
