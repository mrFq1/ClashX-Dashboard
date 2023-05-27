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
	
    var body: some View {
		ScrollViewReader { scrollViewProxy in
			SidebarListView(selectionName: $sidebarSelectionName)
		}
		.environmentObject(clashApiDatasStorage.overviewData)
		.environmentObject(clashApiDatasStorage.logStorage)
		.environmentObject(clashApiDatasStorage.connsStorage)
		.onAppear {
			if ConfigManager.selectLoggingApiLevel == .unknow {
				ConfigManager.selectLoggingApiLevel = .info
			}
			
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
