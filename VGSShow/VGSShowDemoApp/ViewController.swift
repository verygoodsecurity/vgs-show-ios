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
	/// Set proper jsonSelector here.
	vgsShow.request(path: DemoAppConfig.shared.path, method: .post, payload:
	DemoAppConfig.shared.payload, vgsShowType: .text,jsonSelector: "") { (requestResult) in
      switch requestResult {
      case .success(let code, let showData):
          print("vgsshow success, code: \(code)")
		switch showData {
		case .text(let rawText):
			break
		default:
			break
		}
      case .failure(let code, let error):
		print("vgsshow failed, code: \(code), error: \(error)")
      }
    }
  }
}
