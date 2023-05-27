//
//  ConnectionsView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ConnectionsView: View {
	
	@EnvironmentObject var data: ClashConnsStorage
	
	@State private var searchString: String = ""
	
    var body: some View {

		CollectionsTableView(data: data.conns,
							 filterString: searchString)
			.background(Color(nsColor: .textBackgroundColor))
			.searchable(text: $searchString)
			.toolbar {
				ToolbarItem {
					Button {
						ApiRequest.closeAllConnection()
					} label: {
						Image(systemName: "stop.circle.fill")
					}
				}
			}
	}
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
    }
}
