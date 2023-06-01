//
//  CollectImageDemoViewController.swift
//  VGSShowDemoApp

import Foundation
import UIKit
import VGSCollectSDK

class CollectImageDemoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var stateLabel: UILabel!
    
    // MARK: - Properties
    private var pickerController: VGSFilePickerController?
    private var vgsForm = VGSCollect(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateLabel.text = "Pick an image you want to Upload!"
    }
    
    // MARK: - Actions
    @IBAction func selectImageAction(_ sender: UIButton) {
        selectImageFromSource()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        // Update info
        stateLabel.text = "Uploading file..."
        
        // Add extra data
        let extraData = ["image_holder": "Joe Business"]
        
        // Upload image
        vgsForm.sendFile(path: "/post", extraData: extraData) { [weak self] (response) in
            
            switch response {
            case .success(_, let data, _):
                if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("SUCCESS: \(jsonData)")
                    if let aliases = jsonData["json"] as? [String: Any],
                       let imageToken = aliases["image_file_data"] {
                        
                        let payload = ["image_file": imageToken]
                        
                        DemoAppConfig.shared.imageFilePayload = payload
                        self?.stateLabel.text = "\(payload)"
                        print(payload)
                    }
                }
                return
                
            case .failure(let code, _, _, let error):
                switch code {
                case 400..<499:
                    // Wrong request. This also can happend when your routes are not setup yet or your <vaultId> is wrong
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
    
    // MARK: - Private methods
    func selectImageFromSource() {
        
        let alert = UIAlertController(
            title: "Source Type",
            message: "Where is image you want to upload?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] (_) in
            self?.showPickerWithSource(.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (_) in
            self?.showPickerWithSource(.camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Show file picker for specific source type
    /// - Parameters:
    ///     - source: `VGSFileSource` source type to get the image from, it can be photo library or camera.
    func showPickerWithSource(_ source: VGSFileSource) {
        let filePickerConfig = VGSFilePickerConfiguration(
            collector: vgsForm,
            fieldName: "image_file_data",
            fileSource: source
        )
        pickerController = VGSFilePickerController(configuration: filePickerConfig)
        pickerController?.delegate = self
        pickerController?.presentFilePicker(on: self, animated: true, completion: nil)
    }
}

// MARK: - VGSFilePickerControllerDelegate implementation
extension CollectImageDemoViewController: VGSFilePickerControllerDelegate {
    
    func userDidPickFileWithInfo(_ info: VGSFileInfo) {
        self.stateLabel.text = """
        File info:
        - fileExtension: \(info.fileExtension ?? "unknown")
        - size: \(info.size)
        - sizeUnits: \(info.sizeUnits ?? "unknown")
        """
        
        pickerController?.dismissFilePicker(animated: true)
    }
    
    func userDidSCancelFilePicking() {
        pickerController?.dismissFilePicker(animated: true)
    }
    
    func filePickingFailedWithError(_ error: VGSError) {
        self.stateLabel.text = error.localizedDescription
        pickerController?.dismissFilePicker(animated: true)
    }
}
