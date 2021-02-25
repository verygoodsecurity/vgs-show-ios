//
//  AppDelegate.swift
//  VGSShowDemoApp
//
//  Created by Dima on 23.10.2020.
//

import UIKit
import VGSShowSDK
import VGSCollectSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	/// App delegate initializer.
	override init() {
		super.init()

		// *Setup loggers in AppDelegate -init as the earliest app stage.

		// Enable loggers only for debug!
		#if DEBUG
		// Setup VGS Show loggers:
		// Show warnings and errors.
		VGSLogger.shared.configuration.level = .info

		// Show network session for reveal requests.
		VGSLogger.shared.configuration.isNetworkDebugEnabled = true

		// *You can stop all VGS Show loggers in app:
		// VGSLogger.shared.disableAllLoggers()

		// Setup VGS Collect loggers:
		// Show warnings and errors.
		VGSCollectLogger.shared.configuration.level = .info

		// Show network session for collect requests.
		VGSCollectLogger.shared.configuration.isNetworkDebugEnabled = true

		// *You can stop all VGS Collect loggers in app:
		// VGSCollectLogger.shared.disableAllLoggers()
		#endif
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		return true
	}
}
