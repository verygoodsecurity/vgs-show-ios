# SwiftUI Representables

Existing representables in the SDK:
- Sources/VGSShowSDK/UIElements/VGSLabel/VGSLabelRepresentable
- Sources/VGSShowSDK/UIElements/VGSImageView/VGSImageViewRepresentable
- Sources/VGSShowSDK/UIElements/VGSPDFView/VGSPDFViewRepresentable

Example usage:
- VGSLabelRepresentable(vgsShow: show, contentPath: "user.email")

When building custom wrappers:
- Subscribe in makeUIView and unsubscribe in dismantleUIView.
- Avoid storing raw revealed strings outside the managed view.
