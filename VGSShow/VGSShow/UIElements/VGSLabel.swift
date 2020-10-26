//
//  VGSLabel.swift
//  VGSShow
//
//  Created by Dima on 26.10.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

public final class VGSLabel: UIView {
  internal var label = MaskedLabel(frame: .zero)
  internal let fieldType: VGSShowDataType = .text
  internal var horizontalConstraints = [NSLayoutConstraint]()
  internal var verticalConstraint = [NSLayoutConstraint]()

  private(set) weak var vgsShow: VGSShow?
  
  public var fieldName: String!
  
  /// `UIEdgeInsets` for text and placeholder inside `VGSTextField`.
  public var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
      didSet { setMainPaddings() }
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
      super.init(frame: frame)
      mainInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      mainInitialization()
  }
  
  @objc
  func mainInitialization() {
      // set main style for view
      mainStyle()
      // add UI elements
      buildTextFieldUI()
  }

  @objc
  func buildTextFieldUI() {
      label.translatesAutoresizingMaskIntoConstraints = false
      addSubview(label)
      setMainPaddings()
  }

  @objc
  func setMainPaddings() {
    NSLayoutConstraint.deactivate(verticalConstraint)
    NSLayoutConstraint.deactivate(horizontalConstraints)
    
    let views = ["view": self, "label": label]
      
    horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(padding.left)-[label]-\(padding.right)-|",
                                                                 options: .alignAllCenterY,
                                                                 metrics: nil,
                                                                 views: views)
    NSLayoutConstraint.activate(horizontalConstraints)
      
    verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding.top)-[label]-\(padding.bottom)-|",
                                                              options: .alignAllCenterX,
                                                              metrics: nil,
                                                              views: views)
    NSLayoutConstraint.activate(verticalConstraint)
    self.layoutIfNeeded()
  }
  
  func mainStyle() {
      clipsToBounds = true
      layer.borderColor = UIColor.lightGray.cgColor
      layer.borderWidth = 1
      layer.cornerRadius = 4
  }

}

class MaskedLabel: UILabel { }
