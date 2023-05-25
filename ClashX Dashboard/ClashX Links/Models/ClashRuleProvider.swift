//
//  ClashRuleProvider.swift
//  ClashX Meta

import Foundation

class ClashRuleProviderResp: Codable {
    let allProviders: [ClashProxyName: ClashRuleProvider]

    init() {
        allProviders = [:]
    }

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.js)
        return decoder
    }

    private enum CodingKeys: String, CodingKey {
        case allProviders = "providers"
    }
}

class ClashRuleProvider: NSObject, Codable {
    @objc let name: ClashProviderName
    let ruleCount: Int
	@objc let behavior: String
	@objc let type: String
    let updatedAt: Date?
}
