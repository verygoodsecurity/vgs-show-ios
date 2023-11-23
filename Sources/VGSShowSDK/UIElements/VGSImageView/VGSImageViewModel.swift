//
//  VGSImageViewModel.swift
//  VGSShowSDK

import Foundation

/// Protocol describing VGS Show Image ViewModel.
internal protocol VGSImageViewModelProtocol: VGSViewModelProtocol {
    /// Value.
    var value: VGSShowImageContent? { get set }

    /// Change value completion block.
    var onValueChanged: ((VGSShowImageContent?) -> Void)? { get set }

    /// Error completion block.
    var onError: ((VGSShowError) -> Void)? { get set }
}

/// `VGSImageViewModel` holds image view model logic.
internal class VGSImageViewModel: VGSImageViewModelProtocol {

    /// View type.
    var viewType: VGSShowViewType = .image

    /// Reference to the binded view.
    weak var view: VGSBaseViewProtocol?

    /// Decoding path.
    var decodingContentPath: String = ""

    /// Decoding content mode.
    var decodingContentMode: VGSShowDecodingContentMode = .image(.rawData(.base64))

    /// Value.
    var value: VGSShowImageContent? {
        didSet {
            onValueChanged?(value)
        }
    }

    /// Completion to call on value change.
    var onValueChanged: ((VGSShowImageContent?) -> Void)?

    /// Completion to call on error.
    var onError: ((VGSShowError) -> Void)?

    /// Handle decoding result.
    /// - Parameter result: `VGSShowDecodingResult` object, decoding result to handle.
    func handleDecodingResult(_ result: VGSShowDecodingResult) {
        switch result {
        case .success(let content):
            switch content {
            case .rawData(let data):
                value = .rawData(data)
            default:
                assertionFailure("VGS Show error! Decode unsupported type in ImageView Model")
            }
        case .failure(let error):
            onError?(error)
        }
    }
}
