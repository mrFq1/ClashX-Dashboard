//
//  AppDelegate.swift
//  ClashX Dashboard
//
//

import Cocoa
import ClashX_Dashboard_Kit


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
		dashboardWindowController?.showWindow(nil)
		
		
		
	}

	
	func applicationWillTerminate(_ notification: Notification) {
		
	}
}
