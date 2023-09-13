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
		Label {
			Text(item.rawValue)
		} icon: {
			Image(systemName: iconName)
				.foregroundColor(.accentColor)
		}
    }
}

struct SidebarLabel_Previews: PreviewProvider {
    static var previews: some View {
		SidebarLabel(item: .overview, iconName: "chart.bar.xaxis")
    }
}
