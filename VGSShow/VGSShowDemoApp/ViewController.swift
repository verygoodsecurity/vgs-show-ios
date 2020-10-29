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
    vgsShow.bind(cardNumberLabel)
    vgsShow.bind(expDateLabel)
  }
  
  private func configureUI() {
    let padding = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    let textColor = UIColor.red
    let borderColor = UIColor.blue
    let font = UIFont.boldSystemFont(ofSize: 20)
    
    cardNumberLabel.textColor = textColor
    cardNumberLabel.padding = padding
    cardNumberLabel.borderColor = borderColor
    cardNumberLabel.font = font
    cardNumberLabel.fieldName = "json.account_number2"

    expDateLabel.textColor = textColor
    expDateLabel.padding = padding
    expDateLabel.borderColor = borderColor
    expDateLabel.font = font
    expDateLabel.fieldName = "json.exp_date"
    
    stackView.addArrangedSubview(cardNumberLabel)
    stackView.addArrangedSubview(expDateLabel)
  }

	private func loadData() {
  
    vgsShow.request(path: DemoAppConfig.shared.path,
                    method: .post,
                    payload: DemoAppConfig.shared.customPayload) { (requestResult) in
      
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
