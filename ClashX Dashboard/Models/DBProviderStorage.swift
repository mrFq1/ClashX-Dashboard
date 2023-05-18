//
//  DBProviderStorage.swift
//  ClashX Dashboard
//
//

import Cocoa
import SwiftUI

class DBProviderStorage: ObservableObject {
	@Published var proxyProviders = [DBProxyProvider]()
	@Published var ruleProviders = [DBRuleProvider]()

	init() {}
	
}

class DBProxyProvider: ObservableObject, Identifiable {
	let id: String
	
	@Published var name: ClashProviderName
	@Published var proxies: [DBProxy]
	@Published var type: ClashProvider.ProviderType
	@Published var vehicleType: ClashProvider.ProviderVehicleType

	@Published var trafficInfo: String
	@Published var trafficPercentage: String
	@Published var expireDate: String
	@Published var updatedAt: String
	
	init(provider: ClashProvider) {
		id = provider.id
		
		name = provider.name
		proxies = provider.proxies.map(DBProxy.init)
		type = provider.type
		vehicleType = provider.vehicleType
		
		if let info = provider.subscriptionInfo {
			let used = info.download + info.upload
			let total = info.total
			
			let trafficRate = "\(String(format: "%.2f", Double(used)/Double(total/100)))%"
			
			let formatter = ByteCountFormatter()
			
			trafficInfo = formatter.string(fromByteCount: used)
			+ " / "
			+ formatter.string(fromByteCount: total)
			+ " ( \(trafficRate) )"
			
			let expire = info.expire
			
			expireDate = "Expire: "
			+ Date(timeIntervalSince1970: TimeInterval(expire))
				.formatted()
			self.trafficPercentage = trafficRate
		} else {
			trafficInfo = ""
			expireDate = ""
			trafficPercentage = "0.0%"
		}
		
		if let updatedAt = provider.updatedAt {
			let formatter = RelativeDateTimeFormatter()
			formatter.unitsStyle = .abbreviated
			self.updatedAt = formatter.localizedString(for: updatedAt, relativeTo: .now)
		} else {
			self.updatedAt = ""
		}
	}
}

class DBRuleProvider: ObservableObject, Identifiable {
	let id: String
	
	@Published var name: ClashProviderName
	@Published var ruleCount: Int
	@Published var behavior: String
	@Published var type: String
	@Published var updatedAt: Date?
	
	init(provider: ClashRuleProvider) {
		id = UUID().uuidString
		
		name = provider.name
		ruleCount = provider.ruleCount
		behavior = provider.behavior
		type = provider.type
		updatedAt = provider.updatedAt
	}
}
