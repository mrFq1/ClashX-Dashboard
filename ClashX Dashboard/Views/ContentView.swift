//
//  ContentView.swift
//  ClashX Dashboard
//
//

import SwiftUI

class HideProxyNames: ObservableObject, Identifiable {
	let id = UUID().uuidString
	@Published var hide = false
}

struct ContentView: View {
	
	private let runningState = NotificationCenter.default.publisher(for: .init("ClashRunningStateChanged"))
	@State private var isRunning = false
	
	var body: some View {
		Group {
			if !isRunning {
				APISettingView()

//					.presentedWindowToolbarStyle(.expanded)
			} else {
				NavigationView {
					SidebarView()
					EmptyView()
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .navigation) {
				Button {
					NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
				} label: {
					Image(systemName: "sidebar.left")
				}
				.help("Toggle Sidebar")
			}
		}
		.onReceive(runningState) { _ in
			isRunning = ConfigManager.shared.isRunning
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
