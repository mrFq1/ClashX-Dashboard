//
//  ClashConnection.swift
//  ClashX
//
//  Created by yicheng on 2019/10/28.
//  Copyright © 2019 west2online. All rights reserved.
//

import Cocoa
import DifferenceKit

struct ClashConnectionSnapShot: Codable {
	let downloadTotal: Int
	let uploadTotal: Int
    let connections: [ClashConnection]
}

struct ClashConnection: Codable, Hashable {
	let id: String
	let chains: [String]
	let upload: Int64
	let download: Int64
	let start: Date
	let rule: String
	let rulePayload: String
	
	let metadata: MetaConnectionData
}

struct MetaConnectionData: Codable, Hashable {
	let uid: Int
	
	let network: String
	let type: String
	let sourceIP: String
	let destinationIP: String
	let sourcePort: String
	let destinationPort: String
	let inboundIP: String
	let inboundPort: String
	let inboundName: String
	let host: String
	let dnsMode: String
	let process: String
	let processPath: String
	let specialProxy: String
	let specialRules: String
	let remoteDestination: String
	let sniffHost: String
	
}


class ClashConnectionObject: NSObject, Differentiable {
	@objc let id: String
	@objc let host: String
	@objc let sniffHost: String
	@objc let process: String
	@objc let download: Int64
	@objc let upload: Int64
	let downloadString: String
	let uploadString: String
	let chains: [String]
	@objc let chainString: String
	@objc let ruleString: String
	@objc let startDate: Date
	let startString: String
	@objc let source: String
	@objc let destinationIP: String?
	@objc let type: String
	
	var differenceIdentifier: String {
		return id
	}
	
	func isContentEqual(to source: ClashConnectionObject) -> Bool {
		download == source.download &&
		upload == source.upload &&
		startString == source.startString
	}
	
	init(_ conn: ClashConnection) {
		let byteCountFormatter = ByteCountFormatter()
		let startFormatter = RelativeDateTimeFormatter()
		startFormatter.unitsStyle = .short
		
		let metadata = conn.metadata
		
		id = conn.id
		host = "\(metadata.host == "" ? metadata.destinationIP : metadata.host):\(metadata.destinationPort)"
		sniffHost = metadata.sniffHost == "" ? "-" : metadata.sniffHost
		process = metadata.process
		download = conn.download
		downloadString = byteCountFormatter.string(fromByteCount: conn.download)
		upload = conn.upload
		uploadString = byteCountFormatter.string(fromByteCount: conn.upload)
		chains = conn.chains
		chainString = conn.chains.reversed().joined(separator: "/")
		ruleString = conn.rulePayload == "" ? conn.rule : "\(conn.rule) :: \(conn.rulePayload)"
		startDate = conn.start
		startString = startFormatter.localizedString(for: conn.start, relativeTo: Date())
		source = "\(metadata.sourceIP):\(metadata.sourcePort)"
		destinationIP = [metadata.remoteDestination,
						 metadata.destinationIP,
						 metadata.host].first(where: { $0 != "" })
		
		type = "\(metadata.type)(\(metadata.network))"
	}
	
}
