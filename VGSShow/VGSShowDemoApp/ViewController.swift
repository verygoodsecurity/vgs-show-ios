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
  let cardNumberLabel = VGSLabel()
  let expDateLabel = VGSLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureUI()
    cardNumberLabel.fieldName = "json.account_number2"
    vgsShow.bind(cardNumberLabel)
    vgsShow.bind(expDateLabel)
  }
  
  private func configureUI() {
    cardNumberLabel.textColor = .black
    cardNumberLabel.padding = .init(top: 8, left: 8, bottom: 8, right: 8)
    cardNumberLabel.borderColor = .blue
    cardNumberLabel.textColor = .red
    
    expDateLabel.textColor = .red
    stackView.addArrangedSubview(cardNumberLabel)
    stackView.addArrangedSubview(expDateLabel)
  }

	private func loadData() {
    vgsShow.request(path: DemoAppConfig.shared.path,
                    method: .post,
                    payload: DemoAppConfig.shared.payload) { (requestResult) in
      
          switch requestResult {
          case .success(let code):
            print("vgsshow success, code: \(code)")
          case .failure(let code, let error):
            print("vgsshow failed, code: \(code), error: \(error)")
          }
    }
  }
  
  
  @IBAction func revealButtonAction(_ sender: Any) {
    loadData()
  }
}

extension Array where Element: Hashable {
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
}
