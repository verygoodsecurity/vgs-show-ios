//
//  XCUIElement+Extensions.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

extension XCTestCase {

	enum TestWaitAction {
		/// Element exists in view hierarchy but can be invisible.
		case exists(Bool)

		/// Element is visible and hittable.
		case hittable(Bool)
	}

	/**
	Ckeck for `XCUIElement` wait action until timeout. Will fail if timeout is reached.

	- parameter element: `XCUIElement` element to check.
	- parameter action: `TestWaitAction` object to verify.
	- parameter timeout: the maximum time to wait for the action to be possible.
	*/
	func wait(for element: XCUIElement, action: TestWaitAction, timeout: TimeInterval) {
		let predicate: NSPredicate
		switch action {
		case .exists(let value):
			predicate = NSPredicate(format: "exists == %@", NSNumber(value: value))

		case .hittable(let value):
			predicate = NSPredicate(format: "isHittable == %@", NSNumber(value: value))
		}

		wait(for: element, predicate: predicate, timeout: timeout)
	}

	/**
	Wait for a certain predicate to be fulfilled for `XCUIElement`. Will fail if timeout is reached.

	- parameter for: `XCUIElement` to check.
	- parameter predicate: `NSPredicate` object.
	- parameter timeout: `TimeInterval` object, time to wait.
	*/
	func wait(for element: XCUIElement, predicate: NSPredicate, timeout: TimeInterval) {
		let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
		let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
		XCTAssert(result == .completed)
	}

	func wait( forElement element: XCUIElement, timeout: TimeInterval = 5) {
		wait(for: element, action: .exists(true), timeout: timeout)
	}

	func wait( elementToHide element: XCUIElement, timeout: TimeInterval = 5) {
		wait(for: element, action: .exists(true), timeout: timeout)
	}

	func wait(forTimeInterval: TimeInterval) {
		Thread.sleep(forTimeInterval: forTimeInterval)
	}
}
