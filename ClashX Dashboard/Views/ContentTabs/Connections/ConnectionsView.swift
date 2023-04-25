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
			.background(.white)
			.searchable(text: $searchString)


		
		
	}
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
    }
}
