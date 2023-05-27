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
		.searchable(text: $searchString)
		.toolbar {
			ToolbarItem {
				Picker("", selection: $logLevel) {
					ForEach([
						ClashLogLevel.silent,
						.error,
						.warning,
						.info,
						.debug
					], id: \.self) {
						Text($0.rawValue.capitalized).tag($0)
					}
				}
				.pickerStyle(.menu)
				.onChange(of: logLevel) { newValue in
					guard newValue != ConfigManager.selectLoggingApiLevel else { return }
					logStorage.logs.removeAll()
					ConfigManager.selectLoggingApiLevel = newValue
					ApiRequest.shared.resetLogStreamApi()
				}
			}
		}
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
