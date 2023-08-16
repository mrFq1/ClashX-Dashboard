//
//  LogsView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct LogsView: View {
	
	@EnvironmentObject var logStorage: ClashLogStorage
	
	@State var searchString: String = ""
	@State var logLevel = ConfigManager.selectLoggingApiLevel
	
    var body: some View {
		Group {
			LogsTableView(data: logStorage.logs.reversed(), filterString: searchString)
		}
		.onReceive(NotificationCenter.default.publisher(for: .toolbarSearchString)) {
			guard let string = $0.userInfo?["String"] as? String else { return }
			searchString = string
		}
		.onReceive(NotificationCenter.default.publisher(for: .logLevelChanged)) {
			guard let level = $0.userInfo?["level"] as? ClashLogLevel else { return }
			logLevelChanged(level)
		}
    }
	
	func logLevelChanged(_ level: ClashLogLevel) {
		logStorage.logs.removeAll()
		ConfigManager.selectLoggingApiLevel = level
		ApiRequest.shared.resetLogStreamApi()
	}
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
