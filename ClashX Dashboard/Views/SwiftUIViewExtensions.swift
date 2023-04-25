//
//  SwiftUIViewExtensions.swift
//  ClashX Dashboard
//
//

import Foundation
import SwiftUI

struct Show: ViewModifier {
	let isVisible: Bool

	@ViewBuilder
	func body(content: Content) -> some View {
		if isVisible {
			content
		} else {
			EmptyView()
		}
	}
}

extension View {
	func show(isVisible: Bool) -> some View {
		ModifiedContent(content: self, modifier: Show(isVisible: isVisible))
	}
}
