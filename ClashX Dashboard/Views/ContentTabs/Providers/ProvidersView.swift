//
//  ProvidersView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProvidersView: View {
	@ObservedObject var providerStorage = DBProviderStorage()
	
	@State private var searchString = ProxiesSearchString()
	
	@StateObject private var hideProxyNames = HideProxyNames()
	
    var body: some View {
        
		NavigationView {
			List {
				Section("Providers") {
					ProxyProvidersRowView(providerStorage: providerStorage)
					RuleProvidersRowView(providerStorage: providerStorage)
				}
			
				Text("")
				
				Section("Proxy Provider") {
					ForEach(providerStorage.proxyProviders,id: \.id) {
						ProviderRowView(proxyProvider: $0)
					}
				}
			}
			.introspectTableView {
				$0.refusesFirstResponder = true
				$0.doubleAction = nil
			}
			.listStyle(.plain)
			EmptyView()
		}
		.searchable(text: $searchString.string)
		.environmentObject(searchString)
		.onAppear {
			loadProviders()
		}
		.environmentObject(hideProxyNames)
		.toolbar {
			ToolbarItem {
				Button {
					hideProxyNames.hide = !hideProxyNames.hide
				} label: {
					Image(systemName: hideProxyNames.hide ? "eyeglasses" : "wand.and.stars")
				}
			}
		}
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
