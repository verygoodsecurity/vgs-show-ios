//
//  VGSImageViewRepresentable.swift
//  VGSShowSDK
//
import SwiftUI

@available(iOS 14.0, *)
public struct VGSImageViewRepresentable: UIViewRepresentable {

    var contentPath: String
  
    var imageContentMode: UIView.ContentMode = .scaleToFill
  
    var onImageChange: (() -> Void)?
  
    var onRevealImageDidFail: ((VGSShowError) -> Void)?
  
  
    public init(contentPath: String) {
      self.contentPath = contentPath
    }
    
    public func makeUIView(context: Context) -> VGSImageView {
        let vgsImageView = VGSImageView()
        vgsImageView.contentPath = contentPath
        vgsImageView.imageContentMode = imageContentMode
        return vgsImageView
    }

//    /// A Boolean value determines whether the view has image.
//    public var hasImage: Bool {
//        return baseImageView.secureImage != nil
//    }
//
//    /// Remove previously reveled image
//    public func clear() {
//        baseImageView.secureImage = nil
//    }
  
    public func updateUIView(_ uiView: VGSImageView, context: Context) {
      
    }
   
    public func contentPath(_ path: String) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.contentPath = path
      return newRepresentable
    }

    public func onImageChange(_ action: (() -> Void)?) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.onImageChange = action
      return newRepresentable
    }
  
    /// Tells  when reveal image operation was failed for the image view.
    ///   - action: `VGSShowError` object.
    public func onRevealDataDidFail(_ action: ((VGSShowError) -> Void)?) -> VGSImageViewRepresentable {
      var newRepresentable = self
      newRepresentable.onRevealImageDidFail = action
      return newRepresentable
    }
  
    public func makeCoordinator() -> Coordinator {
      return Coordinator(self)
    }
    
    public class Coordinator: NSObject, VGSImageViewDelegate {
      var parent: VGSImageViewRepresentable

      init(_ parent: VGSImageViewRepresentable) {
          self.parent = parent
      }
      
      public func imageDidChange(in imageView: VGSImageView) {
        parent.onImageChange?()
      }
      
      public func imageView(_ imageView: VGSImageView, didFailWithError error: VGSShowError) {
        parent.onRevealImageDidFail?(error)
      }
    }
}
