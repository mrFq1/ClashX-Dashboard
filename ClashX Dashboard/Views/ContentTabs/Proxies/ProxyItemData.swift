//
//  ProxyItemData.swift
//  ClashX Dashboard
//
//

import Cocoa
import SwiftUI

class ProxyItemData: NSObject, ObservableObject {
	let id: String
	@objc let name: ClashProxyName
	let type: ClashProxyType
	let udpString: String
	let tfo: Bool
	let all: [ClashProxyName]
	
	var delay: Int {
		didSet {
			switch delay {
			case 0:
				delayString = NSLocalizedString("fail", comment: "")
			default:
				delayString = "\(delay) ms"
			}
			
			let httpsTest = true
			
			switch delay {
			case 0:
				delayColor = .gray
			case ..<200 where !httpsTest:
				delayColor = .green
			case ..<800 where httpsTest:
				delayColor = .green
			case 200..<500 where !httpsTest:
				delayColor = .yellow
			case 800..<1500 where httpsTest:
				delayColor = .yellow
			default:
				delayColor = .orange
			}
		}
	}
	
	@Published var delayString = ""
	@Published var delayColor = Color.clear
	
	init(clashProxy: ClashProxy) {
		id = clashProxy.id
		name = clashProxy.name
		type = clashProxy.type
		tfo = clashProxy.tfo
		all = clashProxy.all ?? []
		
		
		udpString = {
			if clashProxy.udp {
				return "UDP"
			} else if clashProxy.xudp {
				return "XUDP"
			} else {
				return ""
			}
		}()
		
		delay = 0
		super.init()
		defer {
			delay = clashProxy.history.last?.meanDelay ?? clashProxy.history.last?.delay ?? 0
		}
		
		
	}
}
