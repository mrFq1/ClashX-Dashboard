//
//  LogsTableView.swift
//  
//
//

import Cocoa
import SwiftUI
import DifferenceKit

struct LogsTableView<Item: Hashable>: NSViewRepresentable {
	
	enum TableColumn: String, CaseIterable {
		case date = "Date"
		case level = "Level"
		case log = "Log"
	}
	
	var data: [Item]
	var filterString: String
	
	class NonRespondingScrollView: NSScrollView {
		override var acceptsFirstResponder: Bool { false }
	}

	class NonRespondingTableView: NSTableView {
		override var acceptsFirstResponder: Bool { false }
	}

	func makeNSView(context: Context) -> NSScrollView {
		
		let scrollView = NonRespondingScrollView()
		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = false
		scrollView.autohidesScrollers = true

		let tableView = NonRespondingTableView()
		tableView.usesAlternatingRowBackgroundColors = true
		
		tableView.delegate = context.coordinator
		tableView.dataSource = context.coordinator
		
		TableColumn.allCases.forEach {
			let tableColumn = NSTableColumn(identifier: .init($0.rawValue))
			tableColumn.title = $0.rawValue
			tableColumn.isEditable = false
			
			switch $0 {
			case .date:
				tableColumn.minWidth = 60
				tableColumn.maxWidth = 140
				tableColumn.width = 135
			case .level:
				tableColumn.minWidth = 40
				tableColumn.maxWidth = 65
			default:
				tableColumn.minWidth = 120
				tableColumn.maxWidth = .infinity
			}
			
			tableView.addTableColumn(tableColumn)
		}
		
		scrollView.documentView = tableView

		return scrollView
	}
	
	func updateNSView(_ nsView: NSScrollView, context: Context) {
		context.coordinator.parent = self
		guard let tableView = nsView.documentView as? NSTableView,
			  let data = data as? [ClashLogStorage.ClashLog] else {
			return
		}
		
		let target = updateSorts(data, tableView: tableView)
		
		let source = context.coordinator.logs
		let changeset = StagedChangeset(source: source, target: target)
		
	
		tableView.reload(using: changeset) { data in
			context.coordinator.logs = data
		}
	}
	
	func updateSorts(_ objects: [ClashLogStorage.ClashLog],
					 tableView: NSTableView) -> [ClashLogStorage.ClashLog] {
		var re = objects
		
		let filterKeys = [
			"levelString",
			"log",
		]
		
		re = re.filtered(filterString, for: filterKeys)
		
		return re
	}
	
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	
	class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {

		var parent: LogsTableView
		var logs = [ClashLogStorage.ClashLog]()
		
		let dateFormatter = {
			let df = DateFormatter()
			df.dateFormat = "MM/dd HH:mm:ss.SSS"
			return df
		}()

		
		init(parent: LogsTableView) {
			self.parent = parent
		}
		
		
		func numberOfRows(in tableView: NSTableView) -> Int {
			logs.count
		}

		
		func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			
			guard let cellView = tableView.createCellView(with: "LogsTableCellView"),
				  let s = tableColumn?.identifier.rawValue.split(separator: ".").last,
				  let tc = TableColumn(rawValue: String(s))
			else { return nil }
			
			let log = logs[row]
			let tf = cellView.textField
			
			switch tc {
			case .date:
				tf?.lineBreakMode = .byTruncatingHead
				tf?.textColor = .orange
				tf?.stringValue = dateFormatter.string(from: log.date)
			case .level:
				tf?.lineBreakMode = .byTruncatingTail
				tf?.textColor = log.levelColor
				tf?.stringValue = log.levelString
			case .log:
				tf?.lineBreakMode = .byTruncatingTail
				tf?.textColor = .labelColor
				tf?.stringValue = log.log
			}
			
			return cellView
		}
		
	}
}
