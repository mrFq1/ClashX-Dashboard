//
//  ClearBackgroundList.swift
//  ClashX Dashboard
//
//

import Foundation
import SwiftUI

extension NSTableView {
	open override func viewWillMove(toWindow newWindow: NSWindow?) {
		super.viewDidMoveToWindow()
		backgroundColor = NSColor.clear
		enclosingScrollView!.drawsBackground = false
	}
}
