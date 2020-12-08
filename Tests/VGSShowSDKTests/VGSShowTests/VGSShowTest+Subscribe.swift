//
//  VGSShowTest+Subscribe.swift
//  VGSShowTests
//
//  Created by Dima on 10.11.2020.
//

import XCTest
@testable import VGSShowSDK

extension VGSShowTests {
  
    func testSubscribeUnsubcribeLabels() {
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      
      let label1 = VGSLabel()
      label1.fieldName = "label1"
      vgsShow.subscribe(label1)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      XCTAssertTrue(vgsShow.subscribedViews.count == 1)
      
      let label2 = VGSLabel()
      label1.fieldName = "label2"
      vgsShow.subscribe(label2)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 2)
      XCTAssertTrue(vgsShow.subscribedViews.count == 2)
      
      /// test no dublicates
      vgsShow.subscribe(label2)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 2)
      XCTAssertTrue(vgsShow.subscribedViews.count == 2)
      
      vgsShow.unsubscribe(label2)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 1)
      XCTAssertTrue(vgsShow.subscribedViews.count == 1)
      
      vgsShow.unsubscribe(label1)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      XCTAssertTrue(vgsShow.subscribedViews.count == 0)
      
      vgsShow.subscribe(label1)
      vgsShow.subscribe(label2)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 2)
      XCTAssertTrue(vgsShow.subscribedViews.count == 2)
      
      vgsShow.unsubscribeAllViews()
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      XCTAssertTrue(vgsShow.subscribedViews.count == 0)
    }
  
    func testSubscribeExternalView() {
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      XCTAssertTrue(vgsShow.subscribedViews.count == 0)
      
      let customView = CustomView()
      vgsShow.subscribe(customView)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      XCTAssertTrue(vgsShow.subscribedViews.count == 0)
      
      vgsShow.unsubscribe(customView)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      XCTAssertTrue(vgsShow.subscribedViews.count == 0)
    }
  
    func testSubscribeDuplicateViews() {
      XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
      
      let label1 = VGSLabel()
      label1.fieldName = "label1"
      vgsShow.subscribe(label1)
      vgsShow.subscribe(label1)
      vgsShow.subscribe(label1)
      XCTAssertTrue(vgsShow.subscribedLabels.count == 1)
      XCTAssertTrue(vgsShow.subscribedViews.count == 1)
    }
  
  func testUnsubscribeFromEmptyArray() {
    XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
        
    /// test no crash when unsubscribe from empty array
    let label1 = VGSLabel()
    label1.fieldName = "label1"
    vgsShow.subscribe(label1)
    XCTAssertTrue(vgsShow.subscribedLabels.count == 1)
    
    vgsShow.unsubscribe(label1)
    XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
    
    vgsShow.unsubscribe(label1)
    XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
  }
}

/// Testable view that conforms to public VGSViewProtocol protocol
class CustomView: UIView, VGSViewProtocol {
  
  var fieldName: String! = "some_field"
  
}
