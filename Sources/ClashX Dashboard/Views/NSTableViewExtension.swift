//
//  NSTableViewExtension.swift
//  
//

//

import Cocoa

extension NSTableView {
	func makeCellView(with identifier: String, owner: Any?) -> NSTableCellView? {
		// https://stackoverflow.com/a/27624927
		
		var cellView: NSTableCellView?
		if let spareView = makeView(withIdentifier: .init(identifier),
			owner: owner) as? NSTableCellView {

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
	
	
	func reloadData<C>(_ changes: CollectionDifference<C>, indexs: IndexSet) {
		beginUpdates()
		for change in changes {
			switch change {
			case .insert(let offset, _, _):
				insertRows(at: IndexSet(integer: offset))
			case .remove(let offset, _, _):
				removeRows(at: IndexSet(integer: offset))
			}
		}
		reloadData(forRowIndexes: indexs, columnIndexes: IndexSet(tableColumns.indices))
		endUpdates()
	}
}
