//
//  VGSShowAnalyticsSession.swift
//  VGSShow
//

import Foundation

/// :nodoc:  Holds shared VGSShow analytics session info.
public final class VGSShowAnalyticsSession {

	// MARK: - Public

	/// Shared session instance.
	public static let shared = VGSShowAnalyticsSession()

	/// Uniq id that should stay the same during application runtime.
	public let vgsShowSessionId = UUID().uuidString

	// MARK: - Initializer

	private init() {}

}
