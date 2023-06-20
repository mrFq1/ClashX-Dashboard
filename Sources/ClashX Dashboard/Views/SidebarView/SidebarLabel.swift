//
//  SwiftUIView.swift
//  
//
//

import SwiftUI

struct SidebarLabel: View {
	@State var item: SidebarItem
	@State var iconName: String
	
    var body: some View {
		HStack {
			Image(systemName: iconName)
				.foregroundColor(.accentColor)
			Text(item.rawValue)
		}
    }
}

struct SidebarLabel_Previews: PreviewProvider {
    static var previews: some View {
		SidebarLabel(item: .overview, iconName: "chart.bar.xaxis")
    }
}
