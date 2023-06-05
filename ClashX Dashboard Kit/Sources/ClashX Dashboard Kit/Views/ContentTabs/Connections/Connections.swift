//
//  Connections.swift
//  ClashX Dashboard
//
//

import Cocoa

class Connections: ObservableObject, Identifiable {
	let id = UUID()
	@Published var items: [ConnectionItem]
	
	init(_ items: [ConnectionItem]) {
		self.items = items
	}
}


class ConnectionItem: ObservableObject, Decodable {
	let id: String
	
	let host: String
	let sniffHost: String
	let process: String
	let dl: String
	let ul: String
	let dlSpeed: String
	let ulSpeed: String
	let chains: String
	let rule: String
	let time: String
	let source: String
	let destinationIP: String
	let type: String
	
	
}
