//
//  VGSEnvironment.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Organization vault environment.
public enum VGSEnvironment: String {

    /// Sandbox environment for development and testing.
    ///
    /// Use this environment with test/mock data during development, QA, and integration testing.
    /// Sandbox vaults are isolated from production data.
    case sandbox

    /// Live production environment.
    ///
    /// Use this environment only in production builds with real sensitive data.
    /// Ensure thorough testing in `.sandbox` before switching to `.live`.
    case live
}
