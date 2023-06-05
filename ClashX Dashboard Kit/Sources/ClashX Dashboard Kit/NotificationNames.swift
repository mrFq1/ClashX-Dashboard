//
//  NotificationNames.swift
//  
//
//

import Foundation

extension NSNotification.Name {
	static let reloadDashboard = NSNotification.Name("ReloadDashboard")
	static let sidebarItemChanged = NSNotification.Name("SidebarItemChanged")
	
	static let toolbarSearchString = NSNotification.Name("ToolbarSearchString")
	static let stopConns = NSNotification.Name("StopConns")
	static let hideNames = NSNotification.Name("HideNames")
	static let logLevelChanged = NSNotification.Name("LogLevelChanged")
}
