//
//  ClashX_DashboardApp.swift
//  ClashX Dashboard
//
//

import SwiftUI

@main
struct ClashX_DashboardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.commands {
			SidebarCommands()
		}
    }
}
