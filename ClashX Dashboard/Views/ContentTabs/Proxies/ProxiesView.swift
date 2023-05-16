//
//  ProxiesView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import Introspect

class ProxiesSearchString: ObservableObject, Identifiable {
	let id = UUID().uuidString
	@Published var string: String = ""
}

struct ProxiesView: View {
	
	@ObservedObject var proxyStorage = DBProxyStorage()
	
	@State private var searchString = ProxiesSearchString()
	@State private var isGlobalMode = false
	
    var body: some View {
		NavigationView {
			List(proxyStorage.groups, id: \.id) { group in
				ProxyGroupRowView(proxyGroup: group)
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
			loadProxies()
		}
    }
	
	
	func loadProxies() {
//			self.isGlobalMode = ConfigManager.shared.currentConfig?.mode == .global
		ApiRequest.requestProxyGroupList {
			proxyStorage.groups = DBProxyStorage($0).groups.filter {
				isGlobalMode ? true : $0.name != "GLOBAL"
			}
		}
	}
}

//struct ProxiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProxiesView()
//    }
//}
