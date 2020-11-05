//
//  VGSLabelModel.swift
//  VGSShow
//
//  Created by Dima on 29.10.2020.
//

import Foundation

/// Protocol describing VGS Show View ViewModel
internal protocol VGSShowViewModelProtocol {
  var decodingKeyPath: String { get set }
  var decoder: VGSShowDecoderProtocol { get }
	var responseFormat: VGSShowResponseDecodingFormat {get set}
  func decode(_ data: Data?) -> VGSShowError?
}

/// Protocol describing VGS Show Label ViewModel
internal protocol VGSLabelViewModelProtocol: VGSShowViewModelProtocol {
  var value: String? { get set }
  var onValueChanged: ((String?) -> Void)? { get set }
}

internal class VGSLabelModel: VGSLabelViewModelProtocol {

  private(set) var decoder: VGSShowDecoderProtocol = VGSShowTextDecoder()
  
  var decodingKeyPath: String = ""

	var responseFormat: VGSShowResponseDecodingFormat = .json

  var decodingDataType: VGSShowDecodingContentMode = .text {
    didSet {
      decoder = VGSDataDecoderFactory.provideDecorder(for: decodingDataType)
    }
  }
  
  var value: String? {
    didSet {
      onValueChanged?(value)
    }
  }
  
  var onValueChanged: ((String?) -> Void)?
  
  func decode(_ data: Data?) -> VGSShowError? {
		let result = decoder.decodeDataPyPath(decodingKeyPath, responseFormat: responseFormat, data: data)
    switch result {
    case .success(let data):
      switch data {
      case .text(let text):
        self.value = text
        return nil
      default:
        #warning("not supported data format")
        /// TODO:  send specific error
      return nil
      }
    case .failure(let error):
      return error
    }
    return nil
  }
}

