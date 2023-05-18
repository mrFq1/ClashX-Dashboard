//
//  SidebarView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct SidebarView: View {
	
	@StateObject var clashApiDatasStorage = ClashApiDatasStorage()
	
	private let connsQueue = DispatchQueue(label: "thread-safe-connsQueue", attributes: .concurrent)
	private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
	
	@State private var sidebarSelectionName: String? = "Overview"
	
	@State private var sidebarItems = [
		SidebarItem(name: "Overview",
					icon: "chart.bar.xaxis",
					view: AnyView(OverviewView())),
		
		SidebarItem(name: "Proxies",
					icon: "globe.asia.australia",
					view: AnyView(ProxiesView())),
		
		SidebarItem(name: "Providers",
					icon: "link.icloud",
					view: AnyView(ProvidersView())),
		
		SidebarItem(name: "Rules",
					icon: "waveform.and.magnifyingglass",
					view: AnyView(RulesView())),
		
		SidebarItem(name: "Conns",
					icon: "app.connected.to.app.below.fill",
					view: AnyView(ConnectionsView())),
		
		SidebarItem(name: "Config",
					icon: "slider.horizontal.3",
					view: AnyView(ConfigView())),
		
		SidebarItem(name: "Logs",
					icon: "wand.and.stars.inverse",
					view: AnyView(LogsView()))
	]
	
    var body: some View {
		ScrollViewReader { scrollViewProxy in
			List(sidebarItems, id: \.id) { item in
				SidebarItemView(item: item, selectionName: $sidebarSelectionName)
			}
			.listStyle(.sidebar)
		}
		.environmentObject(clashApiDatasStorage.overviewData)
		.environmentObject(clashApiDatasStorage.logStorage)
		.environmentObject(clashApiDatasStorage.connsStorage)
		.onAppear {
			ConfigManager.selectLoggingApiLevel = .debug
			clashApiDatasStorage.resetStreamApi()
			
			connsQueue.sync {
				clashApiDatasStorage.connsStorage.conns
					.removeAll()
			}
			
			updateConnections()
		}
		.onReceive(timer, perform: { _ in
			updateConnections()
		})
	}
	
	func updateConnections() {
		ApiRequest.getConnections { snap in
			connsQueue.sync {
				clashApiDatasStorage.overviewData.upTotal = snap.uploadTotal
				clashApiDatasStorage.overviewData.downTotal = snap.downloadTotal
				clashApiDatasStorage.overviewData.activeConns = "\(snap.connections.count)"
				clashApiDatasStorage.connsStorage.conns = snap.connections
			}
		}
	}
}

//struct SidebarView_Previews: PreviewProvider {
//    static var previews: some View {
//		SidebarView()
//    }
//}
