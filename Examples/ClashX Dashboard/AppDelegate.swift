//
//  AppDelegate.swift
//  ClashX Dashboard
//
//

import Cocoa
import ClashX_Dashboard


@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var dashboardWindowController: DashboardWindowController?
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		
		if dashboardWindowController == nil {
			dashboardWindowController = DashboardWindowController.create()
			dashboardWindowController?.onWindowClose = {
				[weak self] in
				self?.dashboardWindowController = nil
			}
		}
		
		dashboardWindowController?.set("http://127.0.0.1:9021")
		dashboardWindowController?.showWindow(nil)
	}

	
	func applicationWillTerminate(_ notification: Notification) {
		
	}
}
