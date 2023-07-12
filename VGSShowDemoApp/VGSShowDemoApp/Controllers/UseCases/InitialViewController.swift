//
//  InitialViewController.swift
//  VGSShowDemoApp

import Foundation
import UIKit

class InitialViewController: UITableViewController {
    
    @IBAction func setupVaultIdAction(_ sender: Any) {
        
        let alert = UIAlertController(
            title: "Set <vault id>",
            message: "Add your organization valut id here",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.clearButtonMode = .always
            textField.text = DemoAppConfig.shared.vaultId
        }
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Save",
                style: UIAlertAction.Style.default,
                handler: { (_) in
                    let vaultId = alert.textFields?.first?.text ?? "vaultId"
                    DemoAppConfig.shared.vaultId = vaultId
                }
            )
        )
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
