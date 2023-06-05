//
//  ClashX_DashboardApp.swift
//  ClashX Dashboard
//
//

import SwiftUI
import ClashX_Dashboard

//@main
struct ClashX_DashboardApp: App {
    var body: some Scene {
        WindowGroup {
			DashboardView()
        }
		.commands {
			SidebarCommands()
		}
    }
}
