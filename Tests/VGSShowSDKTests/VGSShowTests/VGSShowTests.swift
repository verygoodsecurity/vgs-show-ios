//
//  VGSShowTests.swift
//  VGSShowTests
//
//  Created by Dima on 23.10.2020.
//

import XCTest
@testable import VGSShowSDK

class VGSShowTests: VGSShowBaseTestCase {
    var vgsShow: VGSShow!
    
    override func setUp() {
			super.setUp()

      vgsShow = VGSShow(id: "test")
    }

    override func tearDown() {
			super.tearDown()

      vgsShow = nil
    }

    func testEnvByDefault() {
        let host = vgsShow.apiClient.baseURL?.host ?? ""
        XCTAssertTrue(host.contains("sandbox"))
    }
  
    func testSandboxEnvironmentReturnsTrue() {
      var liveForm = VGSShow(id: "testID", environment: .sandbox)
      var host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.sandbox.verygoodproxy.com")
    
      liveForm = VGSShow(id: "testID", environment: .sandbox, dataRegion: "")
      host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.sandbox.verygoodproxy.com")
    
      liveForm = VGSShow(id: "testID", environment: .sandbox, dataRegion: "ua-0505")
      host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.sandbox-ua-0505.verygoodproxy.com")
    }
    
    func testLiveEnvironmentReturnsTrue() {
      var liveForm = VGSShow(id: "testID", environment: .live)
      var host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.live.verygoodproxy.com")
    
      liveForm = VGSShow(id: "testID", environment: .live, dataRegion: "")
      host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.live.verygoodproxy.com")
    
      liveForm = VGSShow(id: "testID", environment: .live, dataRegion: "ua-0505")
      host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.live-ua-0505.verygoodproxy.com")
    }
  
    func testRegionalEnvironmentReturnsTrue() {
      var liveForm = VGSShow(id: "testID", environment: "live")
      var host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.live.verygoodproxy.com")
    
      liveForm = VGSShow(id: "testID", environment: "live-eu1")
      host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.live-eu1.verygoodproxy.com")
    
      liveForm = VGSShow(id: "testID", environment: "live-ua-0505")
      host = liveForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.live-ua-0505.verygoodproxy.com")
      
      var sandboxForm = VGSShow(id: "testID", environment: "sandbox")
      host = sandboxForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.sandbox.verygoodproxy.com")
      
      sandboxForm = VGSShow(id: "testID", environment: "sandbox-ua5")
      host = sandboxForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.sandbox-ua5.verygoodproxy.com")
    
      sandboxForm = VGSShow(id: "testID", environment: "sandbox-ua-0505")
      host = sandboxForm.apiClient.baseURL?.host ?? ""
      XCTAssertTrue(host == "testID.sandbox-ua-0505.verygoodproxy.com")
    }
  
    func testGenerateRegionalEnvironmentStringReturnsFalse() {
      let notValidEnvStrings = ["liv", "random-ua1", "random-ua-0505",
                                "live-", "live.com", "live/eu",
                                "sandox/us-5050", "sanbox?web=google.com", "", " "]
      
      for env in notValidEnvStrings {
        XCTAssertFalse(VGSShow.regionalEnironmentStringValid(env))
      }
    }
  
    func testRegionStringValidation() {
      XCTAssertTrue(VGSShow.regionValid("ua-0505"))
      XCTAssertTrue(VGSShow.regionValid("ua0505"))
      
      XCTAssertFalse(VGSShow.regionValid("ua_0505"))
      XCTAssertFalse(VGSShow.regionValid("ua:0505"))
      XCTAssertFalse(VGSShow.regionValid("ua-0505/verygoodsecurity.com"))
      XCTAssertFalse(VGSShow.regionValid("ua-0505?param=val"))
      XCTAssertFalse(VGSShow.regionValid("ua-0505#val,id=ua-0505&env=1"))
    }
    
    func testCustomHeader() {
        let headerKey = "costom-header"
        let headerValue = "custom header value"
        
        vgsShow.customHeaders = [
            headerKey: headerValue
        ]
        
        XCTAssertNotNil(vgsShow.customHeaders)
        XCTAssert(vgsShow.customHeaders![headerKey] == headerValue)
    }

		func testCustomHTTPMethod() {
			vgsShow.request(path: "post",
											method: .get, payload: nil) { (requestResult) in

				switch requestResult {
				case .success:
					break
				case .failure:
					break
				}
			}

			vgsShow.apiClient.urlSession.getAllTasks { (tasks) in
				for task in tasks {
					XCTAssertTrue(tasks.count == 1)
					XCTAssert(task.currentRequest?.httpMethod == "GET")
					XCTAssertFalse(task.currentRequest?.httpMethod == "POST")
				}
			}
		}
}
