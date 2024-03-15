//
//  CardDataCollectionSwiftUI.swift
//  demoapp
//

import Foundation
import SwiftUI
import VGSCollectSDK

struct CardDataCollectionSwiftUI: View {
    let vgsCollect = VGSCollect(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
  
    // MARK: - State
    @State private var holderTextFieldState: VGSTextFieldState?
    @State private var cardTextFieldState: VGSCardState?
    @State private var expDateTextFieldState: VGSTextFieldState?
    @State private var responseState: String = "Waiting for response..."

    // MARK: - Textfield UI attributes
    let paddings = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    let validColor = UIColor.lightGray
    let invalidColor = UIColor.red
        
    // MARK: - Build View
    var body: some View {
      
      // MARK: - Textfield Configuration
      var holderNameConfiguration: VGSConfiguration {
        let config = VGSConfiguration(collector: vgsCollect, fieldName: "card_holderName")
        config.type = .cardHolderName
        config.isRequiredValidOnly = true
        return config
      }
      
      var cardNumConfiguration: VGSConfiguration {
        let config = VGSConfiguration(collector: vgsCollect, fieldName: "card_number")
        config.type = .cardNumber
        config.isRequiredValidOnly = true
        return config
      }
      
      var expDateConfiguration: VGSExpDateConfiguration {
        let config = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "card_expirationDate")
        config.type = .expDate
        // Default .expDate format is "##/##"
        config.formatPattern = "##/####"
        // Update validation rules
        config.validationRules = VGSValidationRuleSet(rules: [
          VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
        ])
        config.isRequiredValidOnly = true
        return config
      }

      return VStack(spacing: 8) {
        VGSTextFieldRepresentable(configuration: holderNameConfiguration)
          .placeholder("Cardholder name")
          .textFieldPadding(paddings)
          .border(color: (holderTextFieldState?.isValid ?? true) ? validColor : invalidColor, lineWidth: 1)
          .frame(height: 54)
        VGSCardTextFieldRepresentable(configuration: cardNumConfiguration)
          .placeholder("4111 1111 1111 1111")
          .onStateChange { newState in
            cardTextFieldState = newState
          }
          .cardIconSize(CGSize(width: 40, height: 20))
          .cardIconLocation(.right)
          .textFieldPadding(paddings)
          .border(color: (cardTextFieldState?.isValid ?? true) ? validColor : invalidColor, lineWidth: 1)
          .frame(height: 54)
        VGSExpDateTextFieldRepresentable(configuration: expDateConfiguration)
          .placeholder("10/2025")
          .monthPickerFormat(.longSymbols)
          .textFieldPadding(paddings)
          .border(color: (expDateTextFieldState?.isValid ?? true) ? validColor : invalidColor, lineWidth: 1)
          .frame(height: 54)
        Button(action: {
          UIApplication.shared.endEditing()
          sendData()
        }) {
            Text("Send data")
                .padding()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }.padding(.top, 50)
        Text(responseState).padding(.top, 50)
      }.padding(.leading, 20)
       .padding(.trailing, 20)
  }
  
  private func sendData() {
    /// send extra data
    var extraData = [String: Any]()
    extraData["customKey"] = "Custom Value"

    // Send Request func
    vgsCollect.sendData(path: "/post", extraData: extraData) { (response) in
      
      switch response {
      case .success(_, let data, _):
        if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
          print("SUCCESS: \(jsonData)")
          if let aliases = jsonData["json"] as? [String: Any],
             let cardNumber = aliases["card_number"],
             let expDate = aliases["card_expirationDate"],
             let cardHolderName = aliases["card_holderName"] {
            
            print("""
            card_namber: \(cardNumber)\n
            expiration_date: \(expDate)
            """)
            let payload = ["payment_card_holder_name": cardHolderName,
                           "payment_card_number": cardNumber,
                           "payment_card_expiration_date": expDate]
            
            DemoAppConfig.shared.collectPayload = payload
            responseState = "\(payload)"
            print(payload)
          }
        }
        return
      case .failure(let code, _, _, let error):
        responseState = "Response Error: \(code)"
        print("Error \(code)")
        switch code {
        case 400..<499:
          // Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
          print("Error: Wrong Request, code: \(code)")
        case VGSErrorType.inputDataIsNotValid.rawValue:
          if let error = error as? VGSError {
            print("Error: Input data is not valid. Details:\n \(error)")
          }
        default:
          print("Error: Something went wrong. Code: \(code)")
        }
        print("Submit request error: \(code), \(String(describing: error))")
        return
      }
    }
  }
}
