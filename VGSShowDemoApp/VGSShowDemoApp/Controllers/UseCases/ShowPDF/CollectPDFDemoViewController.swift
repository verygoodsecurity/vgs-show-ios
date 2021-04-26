//
//  CollectPDFDemoViewController.swift
//  VGSShowDemoApp
//

import Foundation
import UIKit
import VGSCollectSDK

/// A class that demonstrates how to use VGSFilePicker for uploading files to VGS
class CollectPDFDemoViewController: UIViewController {

		@IBOutlet weak var stateLabel: UILabel!

		// Create strong reference of VGSFilePickerController instance
		var pickerController: VGSFilePickerController?

		// Init VGS Collector
	  var vgsForm = VGSCollect(id: DemoAppConfig.shared.vaultId, environment: .sandbox)

		override func viewDidLoad() {
				super.viewDidLoad()

				stateLabel.text = "Pick a file that you want to Upload!"
		}

		@IBAction func selectFileAction(_ sender: UIButton) {
				selectFileFromSource()
		}

		@IBAction func submitAction(_ sender: Any) {
				stateLabel.text = "Uploading file..."
				let extraData = ["document_holder": "Joe Business"]

			/// New send file  request func
			vgsForm.sendFile(path: "/post", extraData: extraData) { [weak self](response) in
				switch response {
				case .success(_, let data, _):
					if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						// swiftlint:disable force_try
						self?.stateLabel.text = (String(data: try! JSONSerialization.data(withJSONObject: jsonData["json"]!, options: .prettyPrinted), encoding: .utf8)!)

						if let pdfJson = jsonData["json"] as? [String: Any],
							 let pdfFileToken = pdfJson["pdf_file_data"] as? String {
							DemoAppConfig.shared.pdfFilePayload["pdf_file"] = pdfFileToken
						}

						//print(String(data: try! JSONSerialization.data(withJSONObject: jsonData["json"]!, options: .prettyPrinted), encoding: .utf8)!)
						// swiftlint:enable force_try
					}
					return
				case .failure(let code, _, _, let error):
					switch code {
					case 400..<499:
						// Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
						self?.stateLabel.text = "Wrong Request Error: \(code)"
					case VGSErrorType.inputFileSizeExceedsTheLimit.rawValue:
						if let error = error as? VGSError {
							self?.stateLabel.text = "Input file size exceeds the limits. Details:\n \(error)"
						}
					default:
						self?.stateLabel.text = "Something went wrong. Code: \(code)"
					}
				print("Submit request error: \(code), \(String(describing: error))")
				return
				}
			}
		}

		// Show file picker for specific source type
		func showPickerWithSource(_ source: VGSFileSource) {
				let fieldName = source == .documentsDirectory ? "pdf_file_data" : "card_image"
				let filePickerConfig = VGSFilePickerConfiguration(collector: vgsForm, fieldName: fieldName, fileSource: source)
				pickerController = VGSFilePickerController(configuration: filePickerConfig)
				pickerController?.delegate = self
				pickerController?.presentFilePicker(on: self, animated: true, completion: nil)
		}

		// Add UI to select source type
		private func selectFileFromSource() {
				let alert = UIAlertController(title: "Source Type", message: "Where is file you need to upload?", preferredStyle: .actionSheet)

				alert.addAction(UIAlertAction(title: "Documents Directory", style: .default, handler: { [weak self] (_)in
						self?.showPickerWithSource(.documentsDirectory)
				}))

				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

				if let popoverController = alert.popoverPresentationController {
					popoverController.sourceView = self.view //to set the source of your alert
					popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
					popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
				}

				present(alert, animated: true, completion: nil)
		}
}

extension CollectPDFDemoViewController: VGSFilePickerControllerDelegate {
		// Check file info, selected by user
		func userDidPickFileWithInfo(_ info: VGSFileInfo) {
				self.stateLabel.text = """
																File info:
																- fileExtension: \(info.fileExtension ?? "unknown")
																- size: \(info.size)
																- sizeUnits: \(info.sizeUnits ?? "unknown")
																"""
				pickerController?.dismissFilePicker(animated: true)
		}

		// Handle cancel file selection
		func userDidSCancelFilePicking() {
				pickerController?.dismissFilePicker(animated: true)
		}

		// Handle errors on picking the file
		func filePickingFailedWithError(_ error: VGSError) {
				self.stateLabel.text = error.localizedDescription
				pickerController?.dismissFilePicker(animated: true)
		}
}
