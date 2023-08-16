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

		ConnectionsTableView(data: data.conns,
							 filterString: searchString)
			.background(Color(nsColor: .textBackgroundColor))
			.onReceive(NotificationCenter.default.publisher(for: .toolbarSearchString)) {
				guard let string = $0.userInfo?["String"] as? String else { return }
				searchString = string
			}
			.onReceive(NotificationCenter.default.publisher(for: .stopConns)) { _ in
				stopConns()
			}
	}
	
	func stopConns() {
		ApiRequest.closeAllConnection()
	}
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
    }
}
