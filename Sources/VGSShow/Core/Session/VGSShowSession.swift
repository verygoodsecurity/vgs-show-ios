//
//  VGSShowSession.swift
//  VGSShow
//

import Foundation

/// Holds shared VGSShow session info.
public final class VGSShowSession {

	// MARK: - Public

	/// Shared session instance.
	public static let shared = VGSShowSession()

	/// Uniq id that should stay the same during application runtime.
	public let vgsShowSessionId = UUID().uuidString

	// MARK: - Initializer

	private init() {}

}
