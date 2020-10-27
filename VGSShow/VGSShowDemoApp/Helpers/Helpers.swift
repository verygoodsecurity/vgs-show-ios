//
//  Helpers.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 27.10.2020.
//

import Foundation

func environmentStringVar(_ name: String) -> String? {
	return ProcessInfo.processInfo.environment[name] 
}
