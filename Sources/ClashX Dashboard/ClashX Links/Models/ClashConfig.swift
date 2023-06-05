//
//  ClashConfig.swift
//  ClashX
//
//  Created by CYC on 2018/7/30.
//  Copyright © 2018年 yichengchen. All rights reserved.
//
import Foundation
import CocoaLumberjackSwift

enum ClashProxyMode: String, Codable {
    case rule
    case global
    case direct
}

extension ClashProxyMode {
    var name: String {
        switch self {
        case .rule: return NSLocalizedString("Rule", comment: "")
        case .global: return NSLocalizedString("Global", comment: "")
        case .direct: return NSLocalizedString("Direct", comment: "")
        }
    }
}

enum ClashLogLevel: String, Codable {
    case info
    case warning
    case error
    case debug
    case silent
    case unknow = "unknown"

    func toDDLogLevel() -> DDLogLevel {
        switch self {
        case .info:
            return .info
        case .warning:
            return .warning
        case .error:
            return .error
        case .debug:
            return .debug
        case .silent:
            return .off
        case .unknow:
            return .error
        }
    }
}

class ClashConfig: Codable {
    var port: Int
    var socksPort: Int
	var redirPort: Int
    var allowLan: Bool
    var mixedPort: Int
    var mode: ClashProxyMode
    var logLevel: ClashLogLevel

    var sniffing: Bool
	var ipv6: Bool
	
    var tun: Tun
	var interfaceName: String

    struct Tun: Codable {
        let enable: Bool
        let device: String
        let stack: String
//        let dns-hijack: [String]
//        let auto-route: Bool
//        let auto-detect-interface: Bool
    }

    var usedHttpPort: Int {
        if mixedPort > 0 {
            return mixedPort
        }
        return port
    }

    var usedSocksPort: Int {
        if mixedPort > 0 {
            return mixedPort
        }
        return socksPort
    }

    private enum CodingKeys: String, CodingKey {
        case port, socksPort = "socks-port", redirPort = "redir-port", mixedPort = "mixed-port", allowLan = "allow-lan", mode, logLevel = "log-level", sniffing, tun, interfaceName = "interface-name", ipv6
    }

    static func fromData(_ data: Data) -> ClashConfig? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(ClashConfig.self, from: data)
        } catch let err {
            Logger.log((err as NSError).description, level: .error)
            return nil
        }
    }

    func copy() -> ClashConfig? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let copy = try? JSONDecoder().decode(ClashConfig.self, from: data)
        return copy
    }
}
