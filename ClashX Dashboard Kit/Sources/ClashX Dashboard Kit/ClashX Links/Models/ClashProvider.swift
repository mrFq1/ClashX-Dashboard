//
//  ClashProvider.swift
//  ClashX
//
//  Created by yichengchen on 2019/12/14.
//  Copyright © 2019 west2online. All rights reserved.
//

import Cocoa

class ClashProviderResp: Codable {
    let allProviders: [ClashProxyName: ClashProvider]
    lazy var providers: [ClashProxyName: ClashProvider] = {
        return allProviders.filter({ $0.value.vehicleType != .Compatible })
    }()

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

class ClashProvider: Codable {
    enum ProviderType: String, Codable {
        case Proxy
        case String
    }

    enum ProviderVehicleType: String, Codable {
        case HTTP
        case File
        case Compatible
        case Unknown
    }

    let name: ClashProviderName
    let proxies: [ClashProxy]
    let type: ProviderType
    let vehicleType: ProviderVehicleType
    let updatedAt: Date?

    let subscriptionInfo: ClashProviderSubInfo?
}

class ClashProviderSubInfo: Codable {
    let upload: Int64
    let download: Int64
    let total: Int64
    let expire: Int

    private enum CodingKeys: String, CodingKey {
        case upload = "Upload",
             download = "Download",
             total = "Total",
             expire = "Expire"
    }
}
