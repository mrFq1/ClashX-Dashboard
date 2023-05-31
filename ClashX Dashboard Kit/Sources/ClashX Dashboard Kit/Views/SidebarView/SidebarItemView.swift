//
//  SidebarItemView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct SidebarItemView: View {
	
	@State var item: SidebarItem
	
	@Binding var selectionName: String?
	
    var body: some View {
		NavigationLink(destination: item.view, tag: item.name, selection: $selectionName) {
			Label(item.name, systemImage: item.icon)
		}
    }
}

//struct SidebarItemView_Previews: PreviewProvider {
//    static var previews: some View {
//		SidebarItemView(item: .init(name: "Overview",
//									icon: "chart.bar.xaxis",
//									view: AnyView(OverviewView())))
//    }
//}
