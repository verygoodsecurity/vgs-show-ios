//
//  VGSPDFViewRepresentable.swift
//  VGSShowSDK
//

import SwiftUI
import PDFKit

@available(iOS 14.0, *)
/// A View that displays revealed PDF data.
public struct VGSPDFViewRepresentable: VGSViewRepresentableProtocol, VGSViewRepresentableCallbacksProtocol {
    weak var vgsShow: VGSShow?
    /// Name that will be associated with `VGSPDFViewRepresentable` and used as a decoding `contentPath` on request response with revealed data from your organization vault.
    var contentPath: String
    /// PDF display mode, default is `.singlePageContinuous`.
    var pdfDisplayMode: PDFDisplayMode = PDFDisplayMode.singlePageContinuous
    /// PDF layout direction, either vertical or horizontal for the given display mode, default is `.vertical`.
    var pdfDisplayDirection: PDFDisplayDirection = PDFDisplayDirection.vertical
    /// A boolean value indicating whether pdf is autoscaling, default is `true`.
    var pdfAutoScales: Bool = true
    /// A Boolean value determines whether the view will display the first page as a book cover (meaningful only when the document is in two-up or two-up continuous display mode).
    var displayAsBook: Bool = false
    /// Background color of PDF viewer.
    var pdfBackgroundColor: UIColor =  UIColor.gray.withAlphaComponent(0)
    /// Determines if shadows should be drawn around page borders in a PDF View, default is `true`.
    var pageShadowsEnabled: Bool = true
  
    // MARK: - VGSPDFViewRepresentable interaction callbacks
    /// Tells when PDF View  content did changed.
    var onContentDidChange: (() -> Void)?
    /// Tells  when reveal data operation was failed for the PSD View.
    /// - Parameter error: `VGSShowError` object.
    var onRevealError: ((VGSShowError) -> Void)?
  
    // MARK: - Initialization
    /// Initialization
    ///
    /// - Parameters:
    ///   - contentPath: `String` path in reveal request response with revealed data that should be displayed in VGSPDFViewRepresentable .
    public init(vgsShow: VGSShow, contentPath: String) {
      self.vgsShow = vgsShow
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
        vgsShow?.subscribe(vgsPDFView)
        return vgsPDFView
    }
  
    public func updateUIView(_ uiView: VGSPDFView, context: Context) {
        uiView.pdfDisplayMode = pdfDisplayMode
        uiView.pdfDisplayDirection = pdfDisplayDirection
        uiView.pdfAutoScales = pdfAutoScales
        uiView.displayAsBook = displayAsBook
        uiView.pdfBackgroundColor = pdfBackgroundColor
        uiView.pageShadowsEnabled = pageShadowsEnabled
    }
    /// Name that will be associated with `VGSPDFViewRepresentable` and used as a decoding `contentPath` on request response with revealed data from your organization vault.
    public func contentPath(_ path: String) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.contentPath = path
      return newRepresentable
    }
    /// Set PDF display mode, default is `.singlePageContinuous`.
    public func pdfDisplayMode(_ mode: PDFDisplayMode) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfDisplayMode = mode
      return newRepresentable
    }
    /// Set PDF layout direction, either vertical or horizontal for the given display mode, default is `.vertical`.
    public func pdfDisplayDirection(_ direction: PDFDisplayDirection) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfDisplayDirection = direction
      return newRepresentable
    }
    /// Set whether pdf is autoscaling, default is `true`.
    public func pdfAutoScales(_ scale: Bool) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfAutoScales = scale
      return newRepresentable
    }
    /// Set  whether the view will display the first page as a book cover (meaningful only when the document is in two-up or two-up continuous display mode).
    public func displayAsBook(_ bookDisplay: Bool) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.displayAsBook = bookDisplay
      return newRepresentable
    }
    /// Set background color of PDF viewer.
    public func pdfBackgroundColor(_ color: UIColor) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pdfBackgroundColor = color
      return newRepresentable
    }
    /// Set if shadows should be drawn around page borders in a PDF View, default is `true`.
    public func pageShadowsEnabled(_ enabled: Bool) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.pageShadowsEnabled = enabled
      return newRepresentable
    }
  
    // MARK: - Handle PDF View events
    /// Tells when PDF View content did changed.
    public func onContentDidChange(_ action: (() -> Void)?) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.onContentDidChange = action
      return newRepresentable
    }
  
    /// Tells  when reveal  operation was failed for the PDF View.
    ///   - action: `VGSShowError` object.
    public func onRevealError(_ action: ((VGSShowError) -> Void)?) -> VGSPDFViewRepresentable {
      var newRepresentable = self
      newRepresentable.onRevealError = action
      return newRepresentable
    }
  
    // MARK: - Coordinator
    public func makeCoordinator() -> Coordinator {
      return Coordinator(self)
    }
    
    public class Coordinator: NSObject, VGSPDFViewDelegate {
      var parent: VGSPDFViewRepresentable

      init(_ parent: VGSPDFViewRepresentable) {
          self.parent = parent
      }
      
      public func documentDidChange(in pdfView: VGSPDFView) {
        parent.onContentDidChange?()
      }

      public func pdfView(_ pdfView: VGSPDFView, didFailWithError error: VGSShowError) {
        parent.onRevealError?(error)
      }
    }
}
