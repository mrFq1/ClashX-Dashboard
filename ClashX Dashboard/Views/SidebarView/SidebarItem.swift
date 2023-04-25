//
//  SidebarItem.swift
//  ClashX Dashboard
//
//

import Cocoa
import SwiftUI


class SidebarItems: ObservableObject, Identifiable {
	let id = UUID()
	@Published var items: [SidebarItem]
	@Published var selectedIndex = 0
	
	init(_ items: [SidebarItem]) {
		self.items = items
	}
}

class SidebarItem: ObservableObject {
	let id = UUID()
	let name: String
	let icon: String
	let view: AnyView
	
	
	init(name: String, icon: String, view: AnyView) {
		self.name = name
		self.icon = icon
		self.view = view
	}
}
