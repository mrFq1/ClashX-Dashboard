//
//  ProvidersView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import SwiftUIIntrospect

struct ProvidersView: View {
	@ObservedObject var providerStorage = DBProviderStorage()
	
	@State private var searchString = ProxiesSearchString()
	
	@StateObject private var hideProxyNames = HideProxyNames()
	
    var body: some View {
        
		NavigationView {
			listView
			EmptyView()
		}
		.onReceive(NotificationCenter.default.publisher(for: .toolbarSearchString)) {
			guard let string = $0.userInfo?["String"] as? String else { return }
			searchString.string = string
		}
		.onReceive(NotificationCenter.default.publisher(for: .hideNames)) {
			guard let hide = $0.userInfo?["hide"] as? Bool else { return }
			hideProxyNames.hide = hide
		}
		.environmentObject(searchString)
		.onAppear {
			loadProviders()
		}
		.environmentObject(hideProxyNames)
    }
	
	var listView: some View {
		List {
			if providerStorage.proxyProviders.isEmpty,
			   providerStorage.ruleProviders.isEmpty {
				Text("Empty")
					.padding()
			} else {
				Section("Providers") {
					if !providerStorage.proxyProviders.isEmpty {
						ProxyProvidersRowView(providerStorage: providerStorage)
					}
					if !providerStorage.ruleProviders.isEmpty {
						RuleProvidersRowView(providerStorage: providerStorage)
					}
				}
			}
			
			if !providerStorage.proxyProviders.isEmpty {
				Text("")
				
				Section("Proxy Provider") {
					ForEach(providerStorage.proxyProviders,id: \.id) {
						ProviderRowView(proxyProvider: $0)
					}
				}
			}
		}
		.introspect(.table, on: .macOS(.v12, .v13, .v14)) {
			$0.refusesFirstResponder = true
			$0.doubleAction = nil
		}
		.listStyle(.plain)
	}
	
	func loadProviders() {
		ApiRequest.requestProxyProviderList { resp in
			providerStorage.proxyProviders = 		resp.allProviders.values.filter {
				$0.vehicleType == .HTTP
			}.sorted {
				$0.name < $1.name
			}
			.map(DBProxyProvider.init)
		}
		ApiRequest.requestRuleProviderList { resp in
			providerStorage.ruleProviders = resp.allProviders.values.sorted {
					$0.name < $1.name
				}
				.map(DBRuleProvider.init)
		}
	}
	
}

//struct ProvidersView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProvidersView()
//    }
//}
