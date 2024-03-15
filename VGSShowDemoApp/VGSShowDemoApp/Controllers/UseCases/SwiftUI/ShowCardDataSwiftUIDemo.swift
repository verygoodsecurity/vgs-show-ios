//
//  ShowCardDataSwiftUIDemo.swift
//  VGSShowDemoApp
//

import Foundation
import SwiftUI
import VGSShowSDK

@available(iOS 14.0, *)
struct ShowCardDataSwiftUIDemo: View {
    let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
    let labelPaddings = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
    @State private var holderLabelBorderColor: UIColor = .lightGray
    @State private var cardLabelBorderColor: UIColor = .lightGray
    @State private var expDateLabelBorderColor: UIColor = .lightGray
    @State private var responseState: String = "Waitin for revealed data..."
  
    var body: some View {
      /// Change raw card number format
      let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
      let template = "$1 $2 $3 $4"
      // swiftlint:disable:next force_try
      let regex = try! NSRegularExpression(pattern: cardNumberPattern, options: [])
      
      var placeholderStyle = VGSPlaceholderLabelStyle()
      placeholderStyle.color = .lightGray
      
      return VStack(spacing: 8) {
        VGSLabelRepresentable(vgsShow: vgsShow, contentPath: "json.payment_card_holder_name")
          .placeholder("XXXXXXXXXXXXXXXXXXXX")
          .placeholderStyle(placeholderStyle)
          .onContentDidChange({
            holderLabelBorderColor = .darkGray
            print("-card holder name label updated")
          })
          .onRevealError({ error in
            holderLabelBorderColor = .red
            print("-card holder name label error: \(error)")
          })
          .labelPaddings(labelPaddings)
          .border(color: holderLabelBorderColor, lineWidth: 1)
          .frame(height: 54)
        VGSLabelRepresentable(vgsShow: vgsShow, contentPath: "json.payment_card_number")
          .placeholder("XXXX XXXX XXXX XXXX")
          .placeholderStyle(placeholderStyle)
          .setSecureText(ranges: [VGSTextRange(start: 5, end: 8),
                                  VGSTextRange(start: 10, end: 13)])
          .addTransformationRegex(regex, template: template)
          .labelPaddings(labelPaddings)
          .border(color: cardLabelBorderColor, lineWidth: 1)
          .onContentDidChange({
            cardLabelBorderColor = .darkGray
            print("-card number label updated")
          })
          .onRevealError({ error in
            cardLabelBorderColor = .red
            print("-card number label error: \(error)")
          })
          .border(color: cardLabelBorderColor, lineWidth: 1)
          .frame(height: 54)
        VGSLabelRepresentable(vgsShow: vgsShow, contentPath: "json.payment_card_expiration_date")
          .labelPaddings(labelPaddings)
          .placeholder("XX/XX")
          .placeholderStyle(placeholderStyle)
          .onContentDidChange({
            expDateLabelBorderColor = .darkGray
            print("-card expDate label updated")
          }) 
          .onRevealError({ error in
            expDateLabelBorderColor = .red
            print("-card expDate label error: \(error)")
          })
          .border(color: expDateLabelBorderColor, lineWidth: 1)
          .frame(height: 54)
        Button(action: {
            // Reveal show data
            self.loadData()
          }) {
            Text("Reveal Data")
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
  
  private func loadData() {
    /// Reveal previously collected data.
    vgsShow.request(path: DemoAppConfig.shared.path,
                    method: .post, payload: DemoAppConfig.shared.collectPayload) { (requestResult) in
      
      switch requestResult {
      case .success(let code):
        responseState = "Success, code: \(code)."
        print("vgsshow success, code: \(code)")
      case .failure(let code, let error):
        responseState = "Reveal error, code: \(code)."
        print("vgsshow failed, code: \(code), error: \(String(describing: error))")
      }
    }
  }
}
