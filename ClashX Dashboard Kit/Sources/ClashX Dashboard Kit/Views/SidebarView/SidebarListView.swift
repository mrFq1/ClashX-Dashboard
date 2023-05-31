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
						   tag: "Overview",
						   selection: $selectionName) {
				Label("Overview", systemImage: "chart.bar.xaxis")
			}
			
			NavigationLink(destination: ProxiesView(),
						   tag: "Proxies",
						   selection: $selectionName) {
				Label("Proxies", systemImage: "globe.asia.australia")
			}
			
			NavigationLink(destination: ProvidersView(),
						   tag: "Providers",
						   selection: $selectionName) {
				Label("Providers", systemImage: "link.icloud")
			}
			
			NavigationLink(destination: RulesView(),
						   tag: "Rules",
						   selection: $selectionName) {
				Label("Rules", systemImage: "waveform.and.magnifyingglass")
			}
			
			NavigationLink(destination: ConnectionsView(),
						   tag: "Conns",
						   selection: $selectionName) {
				Label("Conns", systemImage: "app.connected.to.app.below.fill")
			}
			
			NavigationLink(destination: ConfigView(),
						   tag: "Config",
						   selection: $selectionName) {
				Label("Config", systemImage: "slider.horizontal.3")
			}
			
			NavigationLink(destination: LogsView(),
						   tag: "Logs",
						   selection: $selectionName) {
				Label("Logs", systemImage: "wand.and.stars.inverse")
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
