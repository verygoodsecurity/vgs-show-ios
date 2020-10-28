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
    loadData()
  }
  
  private func configureUI() {
    cardNumberLabel.textColor = .black
    expDateLabel.textColor = .red
    stackView.addArrangedSubview(cardNumberLabel)
    stackView.addArrangedSubview(expDateLabel)
  }

  private func loadData() {

	// Set proper jsonSelector here.
	let jsonKeyPath = ""
	let revealModels = [VGSShowRevealModel(jsonKeyPath: jsonKeyPath, decoder: .text)]

	vgsShow.request(path: DemoAppConfig.shared.path, method: .post, payload:
	DemoAppConfig.shared.payload, revealModels: revealModels) { (requestResult) in
      switch requestResult {
      case .success(let code, let revealedData):
          print("vgsshow success, code: \(code)")

		for data in revealedData {
			print("jsonKeyPath: \(data.key)")
			switch data.value {
			case .text(let rawText):
				break
			default:
				break
			}
		}

		// Show unrevealed keys if smth not found.
		if revealedData.count != revealedData.count {
			let allJSONKeyPaths: [String] = revealModels.map({return $0.jsonKeyPath})
			let revealedJSONKeyPaths: [String] = revealedData.map({return $0.key})

			let unrevealedKeyPaths = allJSONKeyPaths.difference(from: revealedJSONKeyPaths)
			print("unrevealedKeyPaths: \(unrevealedKeyPaths)")
		}

      case .failure(let code, let error):
		print("vgsshow failed, code: \(code), error: \(error)")
      }
    }
  }
}

extension Array where Element: Hashable {
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
}
