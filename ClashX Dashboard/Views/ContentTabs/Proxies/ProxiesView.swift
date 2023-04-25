//
//  ProxiesView.swift
//  ClashX Dashboard
//
//

import SwiftUI

class ProxiesSearchString: ObservableObject, Identifiable {
	let id = UUID().uuidString
	@Published var string: String = ""
}

struct ProxiesView: View {
	
	@State var proxyInfo: ClashProxyResp?
	@State var proxyGroups = [ClashProxy]()
	
	@State var providerInfo: ClashProviderResp?
	@State var providers = [ClashProvider]()
	
//	@State var proxyProviderList
	
	@State private var searchString = ProxiesSearchString()
	@State private var isGlobalMode = false
	@State private var proxyListColumnCount = 3
	
    var body: some View {
		List() {
			Text("Proxies")
				.font(.title)
			ForEach(proxyGroups, id: \.id) { group in
				ProxyGroupView(columnCount: $proxyListColumnCount, proxyGroup: group, proxyInfo: proxyInfo!)
			}
			
			Text("Proxy Provider")
				.font(.title)
				.padding(.top)
			
			ForEach($providers, id: \.id) { provider in
				ProxyProviderGroupView(columnCount: $proxyListColumnCount, providerInfo: provider)
			}
		}
		.background {
			GeometryReader { geometry in
				Rectangle()
					.fill(.clear)
					.frame(height: 1)
					.onChange(of: geometry.size.width) { newValue in
						updateColumnCount(newValue)
					}
					.onAppear {
						updateColumnCount(geometry.size.width)
					}
			}.padding()
		}
		.searchable(text: $searchString.string)
		.environmentObject(searchString)
		.onAppear {
			
//			self.isGlobalMode = ConfigManager.shared.currentConfig?.mode == .global
			ApiRequest.getMergedProxyData {
				proxyInfo = $0
				proxyGroups = ($0?.proxyGroups ?? []).filter {
					isGlobalMode ? true : $0.name != "GLOBAL"
				}
				
				providerInfo = proxyInfo?.enclosingProviderResp
				providers = providerInfo?.providers.map {
					$0.value
				} ?? []
			}
		}
    }
	
	func updateColumnCount(_ width: Double) {
		let v = Int(Int(width) / 200)
		let new = v == 0 ? 1 : v
		
		if new != proxyListColumnCount {
			proxyListColumnCount = new
		}
	}
}

//struct ProxiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProxiesView()
//    }
//}
