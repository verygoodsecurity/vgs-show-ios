//
//  VGSImageViewRepresentable.swift
//  VGSShowSDK
//
import SwiftUI

@available(iOS 14.0, *)
/// An object that displays revealed image data.
public struct VGSImageViewRepresentable: VGSViewRepresentableProtocol, VGSViewRepresentableCallbacksProtocol {
    /// Name that will be associated with `VGSImageViewRepresentable` and used as a decoding `contentPath` on request response with revealed data from your organization vault.
    var contentPath: String
    /// Image content mode, default is `.scaleToFill`.
    var imageContentMode: UIView.ContentMode = .scaleToFill
  
    // MARK: - VGSImageViewRepresentable interaction callbacks
    /// Tells when Image View  content did changed.
    var onContentChanged: (() -> Void)?
    /// Tells  when reveal data operation was failed for the Image View.
    /// - Parameter error: `VGSShowError` object.
    var onRevealError: ((VGSShowError) -> Void)?
  
    // MARK: - Initialization
    /// Initialization
    ///
    /// - Parameters:
    ///   - contentPath: `String` path in reveal request response with revealed data that should be displayed in VGSImageViewRepresentable .
    public init(contentPath: String) {
      self.contentPath = contentPath
    }
    
    public func makeUIView(context: Context) -> VGSImageView {
        let vgsImageView = VGSImageView()
        vgsImageView.contentPath = contentPath
        vgsImageView.imageContentMode = imageContentMode
        return vgsImageView
    }
  
    public func updateUIView(_ uiView: VGSImageView, context: Context) {
      
    }
    /// Name that will be associated with `VGSImageViewRepresentable` and used as a decoding `contentPath` on request response with revealed data from your organization vault.
    public func contentPath(_ path: String) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.contentPath = path
      return newRepresentable
    }
    /// Set mage content mode, default is `.scaleToFill`.
    public func imageContentMode(_ mode: UIView.ContentMode) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.imageContentMode = mode
      return newRepresentable
    }

    // MARK: - Handle Image View events
    public func onContentChanged(_ action: (() -> Void)?) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.onContentChanged = action
      return newRepresentable
    }
  
    /// Tells  when reveal image operation was failed for the image view.
    ///   - action: `VGSShowError` object.
    public func onRevealError(_ action: ((VGSShowError) -> Void)?) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.onRevealError = action
      return newRepresentable
    }
  
    // MARK: - Coordinator
    public func makeCoordinator() -> Coordinator {
      return Coordinator(self)
    }
    
    public class Coordinator: NSObject, VGSImageViewDelegate {
      var parent: VGSImageViewRepresentable

      init(_ parent: VGSImageViewRepresentable) {
          self.parent = parent
      }
      
      public func imageDidChange(in imageView: VGSImageView) {
        parent.onContentChanged?()
      }
      
      public func imageView(_ imageView: VGSImageView, didFailWithError error: VGSShowError) {
        parent.onRevealError?(error)
      }
    }
}
