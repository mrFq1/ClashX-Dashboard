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
				SidebarLabel(item: .overview, iconName: "chart.bar.xaxis")
			}
			
			NavigationLink(destination: ProxiesView(),
						   tag: SidebarItem.proxies,
						   selection: $selectionName) {
				SidebarLabel(item: .proxies, iconName: "globe.asia.australia")
			}
			
			NavigationLink(destination: ProvidersView(),
						   tag: SidebarItem.providers,
						   selection: $selectionName) {
				SidebarLabel(item: .providers, iconName: "link.icloud")
			}
			
			NavigationLink(destination: RulesView(),
						   tag: SidebarItem.rules,
						   selection: $selectionName) {
				SidebarLabel(item: .rules, iconName: "waveform.and.magnifyingglass")
			}
			
			NavigationLink(destination: ConnectionsView(),
						   tag: SidebarItem.conns,
						   selection: $selectionName) {
				SidebarLabel(item: .conns, iconName: "app.connected.to.app.below.fill")
			}
			
			NavigationLink(destination: ConfigView(),
						   tag: SidebarItem.config,
						   selection: $selectionName) {
				SidebarLabel(item: .config, iconName: "slider.horizontal.3")
			}
			
			NavigationLink(destination: LogsView(),
						   tag: SidebarItem.logs,
						   selection: $selectionName) {
				SidebarLabel(item: .logs, iconName: "wand.and.stars.inverse")
			}
			
		}
		.introspectTableView {
			$0.refusesFirstResponder = true
			
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
