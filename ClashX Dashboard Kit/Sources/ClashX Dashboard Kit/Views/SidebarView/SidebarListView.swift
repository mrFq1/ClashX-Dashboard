//
//  SidebarListView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import Introspect

struct SidebarListView: View {
	
	@Binding var selectionName: SidebarItem?
	
	@State private var reloadID = UUID().uuidString
	
	
    var body: some View {
		List {
			NavigationLink(destination: OverviewView(),
						   tag: SidebarItem.overview,
						   selection: $selectionName) {
				Label(SidebarItem.overview.rawValue, systemImage: "chart.bar.xaxis")
			}
			
			NavigationLink(destination: ProxiesView(),
						   tag: SidebarItem.proxies,
						   selection: $selectionName) {
				Label(SidebarItem.proxies.rawValue, systemImage: "globe.asia.australia")
			}
			
			NavigationLink(destination: ProvidersView(),
						   tag: SidebarItem.providers,
						   selection: $selectionName) {
				Label(SidebarItem.providers.rawValue, systemImage: "link.icloud")
			}
			
			NavigationLink(destination: RulesView(),
						   tag: SidebarItem.rules,
						   selection: $selectionName) {
				Label(SidebarItem.rules.rawValue, systemImage: "waveform.and.magnifyingglass")
			}
			
			NavigationLink(destination: ConnectionsView(),
						   tag: SidebarItem.conns,
						   selection: $selectionName) {
				Label(SidebarItem.conns.rawValue, systemImage: "app.connected.to.app.below.fill")
			}
			
			NavigationLink(destination: ConfigView(),
						   tag: SidebarItem.config,
						   selection: $selectionName) {
				Label(SidebarItem.config.rawValue, systemImage: "slider.horizontal.3")
			}
			
			NavigationLink(destination: LogsView(),
						   tag: SidebarItem.logs,
						   selection: $selectionName) {
				Label(SidebarItem.logs.rawValue, systemImage: "wand.and.stars.inverse")
			}
			
		}
		.introspectTableView {
			if selectionName == nil {
				selectionName = SidebarItem.overview
				$0.allowsEmptySelection = false
				if $0.selectedRow == -1 {
					$0.selectRowIndexes(.init(integer: 0), byExtendingSelection: false)
				}
			}
		}
		.listStyle(.sidebar)
		.id(reloadID)
		.onReceive(NotificationCenter.default.publisher(for: .reloadDashboard)) { _ in
			reloadID = UUID().uuidString
		}
    }
}

//struct SidebarListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarListView()
//    }
//}
