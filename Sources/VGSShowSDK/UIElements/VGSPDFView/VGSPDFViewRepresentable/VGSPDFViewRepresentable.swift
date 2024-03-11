//
//  VGSPDFViewRepresentable.swift
//  VGSShowSDK
//


import SwiftUI
import PDFKit

@available(iOS 14.0, *)
public struct VGSPDFViewRepresentable: UIViewRepresentable {

    var contentPath: String
  
    var pdfDisplayMode: PDFDisplayMode = PDFDisplayMode.singlePageContinuous
  
    var pdfDisplayDirection: PDFDisplayDirection = PDFDisplayDirection.vertical
  
    var pdfAutoScales: Bool = true
  
    var displayAsBook: Bool = false
  
    var pdfBackgroundColor: UIColor =  UIColor.gray.withAlphaComponent(0)
  
    var pageShadowsEnabled: Bool = true
  
    var onDocumentChange: (() -> Void)?
  
    var onRevealPDFDidFail: ((VGSShowError) -> Void)?
  
//  public var hasDocument: Bool {
//    return maskedPdfView.secureDocument != nil
//  }
  
  
    public init(contentPath: String) {
      self.contentPath = contentPath
    }
    
    public func makeUIView(context: Context) -> VGSPDFView {
        let vgsPDFView = VGSPDFView()
        vgsPDFView.contentPath = contentPath
        vgsPDFView.pdfDisplayMode = pdfDisplayMode
        vgsPDFView.pdfDisplayDirection = pdfDisplayDirection
        vgsPDFView.pdfAutoScales = pdfAutoScales
        vgsPDFView.displayAsBook = displayAsBook
        vgsPDFView.pdfBackgroundColor = pdfBackgroundColor
        vgsPDFView.pageShadowsEnabled = pageShadowsEnabled
      
        return vgsPDFView
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
  
    public func updateUIView(_ uiView: VGSPDFView, context: Context) {
      
    }
   
    public func contentPath(_ path: String) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.contentPath = path
      return newRepresentable
    }
  
    public func pdfDisplayMode(_ mode: PDFDisplayMode) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfDisplayMode = mode
      return newRepresentable
    }
  
    public func pdfDisplayDirection(_ direction: PDFDisplayDirection) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfDisplayDirection = direction
      return newRepresentable
    }
  
    public func pdfAutoScales(_ scale: Bool) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfAutoScales = scale
      return newRepresentable
    }
  
    public func displayAsBook(_ bookDisplay: Bool) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.displayAsBook = bookDisplay
      return newRepresentable
    }
  
    public func pdfBackgroundColor(_ color: UIColor) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfBackgroundColor = color
      return newRepresentable
    }
  
    public func pageShadowsEnabled(_ enabled: Bool) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pageShadowsEnabled = enabled
      return newRepresentable
    }
  

    public func onDocumentChange(_ action: (() -> Void)?) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.onDocumentChange = action
      return newRepresentable
    }
  
  
    /// Tells  when reveal image operation was failed for the image view.
    ///   - action: `VGSShowError` object.
    public func onRevealDataDidFail(_ action: ((VGSShowError) -> Void)?) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.onRevealPDFDidFail = action
      return newRepresentable
    }
  
    public func makeCoordinator() -> Coordinator {
      return Coordinator(self)
    }
    
    public class Coordinator: NSObject, VGSPDFViewDelegate {
      var parent: VGSPDFViewRepresentable

      init(_ parent: VGSPDFViewRepresentable) {
          self.parent = parent
      }
      
      public func documentDidChange(in pdfView: VGSPDFView) {
        parent.onDocumentChange?()
      }

      public func pdfView(_ pdfView: VGSPDFView, didFailWithError error: VGSShowError) {
        parent.onRevealPDFDidFail?(error)
      }
    }
}

