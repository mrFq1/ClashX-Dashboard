//
//  ClashApiDatasStorage.swift
//  ClashX Dashboard
//
//

import Cocoa
import SwiftUI
import CocoaLumberjackSwift

class ClashApiDatasStorage: NSObject, ObservableObject {
	
	@Published var overviewData = ClashOverviewData()
	
	@Published var logStorage = ClashLogStorage()
	@Published var connsStorage = ClashConnsStorage()
	
	func resetStreamApi() {
		ApiRequest.shared.delegate = self
		ApiRequest.shared.resetStreamApis()
	}
}

extension ClashApiDatasStorage: ApiRequestStreamDelegate {
	func streamStatusChanged() {
		print("streamStatusChanged", ConfigManager.shared.isRunning)
		
	}

	func didUpdateTraffic(up: Int, down: Int) {
		overviewData.down = down
		overviewData.up = up
	}
	
	func didGetLog(log: String, level: String) {
		DispatchQueue.main.async {
			self.logStorage.logs.append(.init(level: level, log: log))
			
			if self.logStorage.logs.count > 1000 {
				self.logStorage.logs.removeFirst(100)
			}
		}
	}
	
	func didUpdateMemory(memory: Int64) {
		let v = ByteCountFormatter().string(fromByteCount: memory)
		
		if overviewData.memory != v {
			overviewData.memory = v
		}
	}
	
}

fileprivate let TrafficHistoryLimit = 120

class ClashOverviewData: ObservableObject, Identifiable {
	let id = UUID().uuidString
	
	@Published var uploadString = "N/A"
	@Published var downloadString = "N/A"
	
	@Published var downloadTotal = "N/A"
	@Published var uploadTotal = "N/A"
	
	@Published var activeConns = "0"
	
	@Published var memory = "0 MB"
	
	@Published var downloadHistories = [CGFloat](repeating: 0, count: TrafficHistoryLimit)
	@Published var uploadHistories = [CGFloat](repeating: 0, count: TrafficHistoryLimit)
	
	var down: Int = 0 {
		didSet {
			downloadString = getSpeedString(for: down)
			downloadHistories.append(CGFloat(down))
			
			if downloadHistories.count > 120 {
				downloadHistories.removeFirst()
			}
		}
	}
	
	var up: Int = 0 {
		didSet {
			uploadString = getSpeedString(for: up)
			uploadHistories.append(CGFloat(up))
			
			if uploadHistories.count > 120 {
				uploadHistories.removeFirst()
			}
		}
	}
	
	var downTotal: Int = 0 {
		didSet {
			downloadTotal = getSpeedString(for: downTotal).replacingOccurrences(of: "/s", with: "")
		}
	}
	
	var upTotal: Int = 0 {
		didSet {
			uploadTotal = getSpeedString(for: upTotal).replacingOccurrences(of: "/s", with: "")
		}
	}
	
	func getSpeedString(for byte: Int) -> String {
		let kb = byte / 1000
		if kb < 1000 {
			return  "\(kb)KB/s"
		} else {
			let mb = Double(kb) / 1000
			if mb >= 100 {
				if mb >= 1000 {
					return String(format: "%.1fGB/s", mb/1000)
				}
				return String(format: "%.1fMB/s", mb)
			} else {
				return String(format: "%.2fMB/s", mb)
			}
		}
	}
}

class ClashLogStorage: ObservableObject {
	@Published var logs = [ClashLog]()
	
	class ClashLog: NSObject, ObservableObject {
		let id: String
		
		let date: Date
		let level: ClashLogLevel
		@objc let log: String
		
		let levelColor: NSColor
		@objc let levelString: String
		
		init(level: String, log: String) {
			id = UUID().uuidString
			date = Date()
			
			self.level = .init(rawValue: level) ?? .unknow
			self.log = log
			
			self.levelString = level
			switch self.level {
			case .info:
				levelColor = .systemBlue
			case .warning:
				levelColor = .systemYellow
			case .error:
				levelColor = .systemRed
			case .debug:
				levelColor = .systemGreen
			default:
				levelColor = .white
			}
		}
	}
}

class ClashConnsStorage: ObservableObject {
	@Published var conns = [DBConnection]()
}
