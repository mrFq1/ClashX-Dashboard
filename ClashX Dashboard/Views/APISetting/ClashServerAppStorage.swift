//
//  ClashServerAppStorage.swift
//  ClashX Dashboard
//
//

import Foundation
import SwiftUI

typealias SavedServersAppStorage = [ClashServerAppStorage]

struct ClashServerAppStorage: Codable, Identifiable {
	var id = UUID().uuidString
	let apiURL: String
	let secret: String
}

extension SavedServersAppStorage: RawRepresentable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
			let result = try? JSONDecoder().decode(SavedServersAppStorage.self, from: data)
		else {
			return nil
		}
		self = result
	}

	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
			let result = String(data: data, encoding: .utf8)
		else {
			return "[]"
		}
		return result
	}
}
