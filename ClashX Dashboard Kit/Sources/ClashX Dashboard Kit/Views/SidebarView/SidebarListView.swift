//
//  SidebarListView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct SidebarListView: View {
	
	@Binding var selectionName: String?
	
    var body: some View {
		List {
			
			NavigationLink(destination: OverviewView(),
						   tag: SidebarItem.overview.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.overview.rawValue, systemImage: "chart.bar.xaxis")
			}
			
			NavigationLink(destination: ProxiesView(),
						   tag: SidebarItem.proxies.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.proxies.rawValue, systemImage: "globe.asia.australia")
			}
			
			NavigationLink(destination: ProvidersView(),
						   tag: SidebarItem.providers.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.providers.rawValue, systemImage: "link.icloud")
			}
			
			NavigationLink(destination: RulesView(),
						   tag: SidebarItem.rules.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.rules.rawValue, systemImage: "waveform.and.magnifyingglass")
			}
			
			NavigationLink(destination: ConnectionsView(),
						   tag: SidebarItem.conns.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.conns.rawValue, systemImage: "app.connected.to.app.below.fill")
			}
			
			NavigationLink(destination: ConfigView(),
						   tag: SidebarItem.config.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.config.rawValue, systemImage: "slider.horizontal.3")
			}
			
			NavigationLink(destination: LogsView(),
						   tag: SidebarItem.logs.rawValue,
						   selection: $selectionName) {
				Label(SidebarItem.logs.rawValue, systemImage: "wand.and.stars.inverse")
			}
			
			
		}
		.listStyle(.sidebar)
    }
}

//struct SidebarListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarListView()
//    }
//}
