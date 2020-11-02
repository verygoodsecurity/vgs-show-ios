//
//  VGSLabelModel.swift
//  VGSShow
//
//  Created by Dima on 29.10.2020.
//

import Foundation

internal protocol VGSShowElementModel {
  var jsonKeyPath: String { get set }
  var value: String? { get set }
  var decoder: VGSShowDecoderProtocol { get }
  func decode(_ data: Data?) -> VGSShowError?
}

internal class VGSLabelModel: VGSShowElementModel {

  private(set) var decoder: VGSShowDecoderProtocol = VGSShowTextDecoder()

  var jsonKeyPath: String = ""
  
  var decodingDataType: VGSShowDataDecoding = .text {
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
    let result = decoder.decodeDataPyPath(jsonKeyPath, data: data)
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

