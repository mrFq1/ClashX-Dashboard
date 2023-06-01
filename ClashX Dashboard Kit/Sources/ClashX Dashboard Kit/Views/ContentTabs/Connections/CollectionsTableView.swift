//
//  CollectionsTableView.swift
//  ClashX Dashboard
//
//
import SwiftUI
import AppKit
import DifferenceKit

struct CollectionsTableView<Item: Hashable>: NSViewRepresentable {

	enum TableColumn: String, CaseIterable {
		case host = "Host"
		case sniffHost = "Sniff Host"
		case process = "Process"
		case dl = "DL"
		case ul = "UL"
		case chain = "Chain"
		case rule = "Rule"
		case time = "Time"
		case source = "Source"
		case destinationIP = "Destination IP"
		case type = "Type"
	}
	
	
	var data: [Item]
	var filterString: String
	
	var startFormatter: RelativeDateTimeFormatter = {
		let startFormatter = RelativeDateTimeFormatter()
		startFormatter.unitsStyle = .short
		return startFormatter
	}()
	
	var byteCountFormatter = ByteCountFormatter()

	class NonRespondingScrollView: NSScrollView {
		override var acceptsFirstResponder: Bool { false }
	}

	class NonRespondingTableView: NSTableView {
		override var acceptsFirstResponder: Bool { false }
	}

	func makeNSView(context: Context) -> NSScrollView {
		
		let scrollView = NonRespondingScrollView()
		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = true

		let tableView = NonRespondingTableView()
		tableView.usesAlternatingRowBackgroundColors = true
		
		tableView.delegate = context.coordinator
		tableView.dataSource = context.coordinator
		
		TableColumn.allCases.forEach {
			let tableColumn = NSTableColumn(identifier: .init($0.rawValue))
			tableColumn.title = $0.rawValue
			tableColumn.isEditable = false
			
			tableColumn.minWidth = 50
			tableColumn.maxWidth = .infinity
			
			
			tableView.addTableColumn(tableColumn)
			
			var sort: NSSortDescriptor?
			
			switch $0 {
			case .host:
				sort = .init(keyPath: \DBConnectionObject.host, ascending: true)
			case .sniffHost:
				sort = .init(keyPath: \DBConnectionObject.sniffHost, ascending: true)
			case .process:
				sort = .init(keyPath: \DBConnectionObject.process, ascending: true)
			case .dl:
				sort = .init(keyPath: \DBConnectionObject.download, ascending: true)
			case .ul:
				sort = .init(keyPath: \DBConnectionObject.upload, ascending: true)
			case .chain:
				sort = .init(keyPath: \DBConnectionObject.chainString, ascending: true)
			case .rule:
				sort = .init(keyPath: \DBConnectionObject.ruleString, ascending: true)
			case .time:
				sort = .init(keyPath: \DBConnectionObject.startDate, ascending: true)
			case .source:
				sort = .init(keyPath: \DBConnectionObject.source, ascending: true)
			case .destinationIP:
				sort = .init(keyPath: \DBConnectionObject.destinationIP, ascending: true)
			case .type:
				sort = .init(keyPath: \DBConnectionObject.type, ascending: true)
			default:
				sort = nil
			}
			
			tableColumn.sortDescriptorPrototype = sort
		}
		
		
		if let sort = tableView.tableColumns.first?.sortDescriptorPrototype {
			tableView.sortDescriptors = [sort]
		}
		
		
		scrollView.documentView = tableView

		return scrollView
	}

	func updateNSView(_ nsView: NSScrollView, context: Context) {
		context.coordinator.parent = self
		guard let tableView = nsView.documentView as? NSTableView,
			  let data = data as? [DBConnection] else {
			return
		}
		
		let target = updateSorts(data.map(DBConnectionObject.init), tableView: tableView)
		
		let source = context.coordinator.conns
		let changeset = StagedChangeset(source: source, target: target)
		
	
		tableView.reload(using: changeset) { data in
			context.coordinator.conns = data
		}
	}
	
	func updateSorts(_ objects: [DBConnectionObject],
					 tableView: NSTableView) -> [DBConnectionObject] {
		var re = objects
		
		var sortDescriptors = tableView.sortDescriptors
		sortDescriptors.append(.init(keyPath: \DBConnectionObject.id, ascending: true))
		re = re.sorted(descriptors: sortDescriptors)
		
		let filterKeys = [
			"host",
			"process",
			"chainString",
			"ruleString",
			"source",
			"destinationIP",
			"type",
		]
		
		re = re.filtered(filterString, for: filterKeys)
		
		return re
	}
	

	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {

		var parent: CollectionsTableView
		
		var conns = [DBConnectionObject]()

		init(parent: CollectionsTableView) {
			self.parent = parent
		}
		
		
		func numberOfRows(in tableView: NSTableView) -> Int {
			conns.count
		}

		
		func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			
			guard let cellView = tableView.createCellView(with: "ConnsTableCellView"),
				  let s = tableColumn?.identifier.rawValue.split(separator: ".").last,
				  let tc = TableColumn(rawValue: String(s))
			else { return nil }
			
			let conn = conns[row]
			
			cellView.textField?.objectValue = {
				switch tc {
				case .host:
					return conn.host
				case .sniffHost:
					return conn.sniffHost
				case .process:
					return conn.process
				case .dl:
					return conn.downloadString
				case .ul:
					return conn.uploadString
				case .chain:
					return conn.chainString
				case .rule:
					return conn.ruleString
				case .time:
					return conn.startString
				case .source:
					return conn.source
				case .destinationIP:
					return conn.destinationIP
				case .type:
					return conn.type
				}
			}()
			
			return cellView
		}
		
		func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
			conns = parent.updateSorts(conns, tableView: tableView)
			tableView.reloadData()
		}
		

	}
}


extension NSTableView {
	/// Applies multiple animated updates in stages using `StagedChangeset`.
	///
	/// - Note: There are combination of changes that crash when applied simultaneously in `performBatchUpdates`.
	///         Assumes that `StagedChangeset` has a minimum staged changesets to avoid it.
	///         The data of the data-source needs to be updated synchronously before `performBatchUpdates` in every stages.
	///
	/// - Parameters:
	///   - stagedChangeset: A staged set of changes.
	///   - interrupt: A closure that takes an changeset as its argument and returns `true` if the animated
	///                updates should be stopped and performed reloadData. Default is nil.
	///   - setData: A closure that takes the collection as a parameter.
	///              The collection should be set to data-source of NSTableView.
	
	func reload<C>(
		using stagedChangeset: StagedChangeset<C>,
		interrupt: ((Changeset<C>) -> Bool)? = nil,
		setData: (C) -> Void
	) {
		if case .none = window, let data = stagedChangeset.last?.data {
			setData(data)
			return reloadData()
		}
		
		for changeset in stagedChangeset {
			if let interrupt = interrupt, interrupt(changeset), let data = stagedChangeset.last?.data {
				setData(data)
				return reloadData()
			}
			
			beginUpdates()
			setData(changeset.data)
			
			if !changeset.elementDeleted.isEmpty {
				removeRows(at: IndexSet(changeset.elementDeleted.map { $0.element }))
			}
			
			if !changeset.elementUpdated.isEmpty {
				reloadData(forRowIndexes: IndexSet(changeset.elementUpdated.map { $0.element }), columnIndexes: IndexSet(0..<tableColumns.count))
			}
			
			if !changeset.elementInserted.isEmpty {
				insertRows(at: IndexSet(changeset.elementInserted.map { $0.element }))
			}
			endUpdates()
		}
	}
	
	
	func createCellView(with identifier: String) -> NSTableCellView? {
		// https://stackoverflow.com/a/27624927
		
		var cellView: NSTableCellView?
		if let spareView = makeView(withIdentifier: .init(identifier),
			owner: self) as? NSTableCellView {

			// We can use an old cell - no need to do anything.
			cellView = spareView

		} else {

			// Create a text field for the cell
			let textField = NSTextField()
			textField.backgroundColor = NSColor.clear
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.isBordered = false
			textField.font = .systemFont(ofSize: 13)
			textField.lineBreakMode = .byTruncatingTail

			// Create a cell
			let newCell = NSTableCellView()
			newCell.identifier = .init(identifier)
			newCell.addSubview(textField)
			newCell.textField = textField

			// Constrain the text field within the cell
			newCell.addConstraints(
				NSLayoutConstraint.constraints(withVisualFormat: "H:|[textField]|",
					options: [],
					metrics: nil,
					views: ["textField" : textField]))

			newCell.addConstraint(.init(item: textField, attribute: .centerY, relatedBy: .equal, toItem: newCell, attribute: .centerY, multiplier: 1, constant: 0))
			

			textField.bind(NSBindingName.value,
						   to: newCell,
				withKeyPath: "objectValue",
				options: nil)

			cellView = newCell
		}
		
		return cellView
	}
	
}
