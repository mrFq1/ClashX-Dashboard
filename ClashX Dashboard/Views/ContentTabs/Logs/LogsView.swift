//
//  LogsView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct LogsView: View {
	
	@EnvironmentObject var logStorage: ClashLogStorage
	
	@State var searchString: String = ""
	
	var logs: [ClashLogStorage.ClashLog] {
		let logs: [ClashLogStorage.ClashLog] = logStorage.logs.reversed()
		if searchString.isEmpty {
			return logs
		} else {
			return logs.filtered(searchString, for: ["log", "levelString"])
		}
	}
	
    var body: some View {
		Table(logs) {
			TableColumn("Date") {
				Text($0.date.formatted(
					Date.FormatStyle()
						.year(.twoDigits)
						.month(.twoDigits)
						.day(.twoDigits)
						.hour(.twoDigits(amPM: .omitted))
						.minute(.twoDigits)
						.second(.twoDigits)
				))
					.foregroundColor(.orange)
					.truncationMode(.head)
			}
			.width(min: 60, max: 130)
			TableColumn("Level") {
				Text("[\($0.level.rawValue)]")
					.foregroundColor($0.levelColor)
			}
			.width(min: 40, max: 65)
			TableColumn("", value: \.log)
		}
		.background(.white)
		.searchable(text: $searchString)
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
