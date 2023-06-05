//
//  APISettingView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import Introspect

struct APISettingView: View {
	@State var baseURL: String = ""
	@State var secret: String = ""
	
	@State var connectInfo: String = ""
	
	@AppStorage("savedServers") var savedServers = SavedServersAppStorage()
	
    var body: some View {
		VStack(alignment: .center) {
			HStack {
				VStack(alignment: .leading) {
					Text("API Base URL")
					TextField("http://127.0.0.1:9090", text: $baseURL)
				}
				.frame(width: 250)
				
				VStack(alignment: .leading) {
					Text("Secret(optional)")
					TextField("", text: $secret)
				}
				.frame(width: 120)
			}
			
			HStack {
				Text(connectInfo)
				Spacer()
				Button("Add") {
					savedServers.append(.init(apiURL: baseURL, secret: secret))
					
					print(savedServers)
				}
			}
			
			List(savedServers, id: \.id) { server in
				APIServerItem(server: server.apiURL) {
					
					ConfigManager.shared.overrideApiURL = .init(string: server.apiURL)
					ConfigManager.shared.overrideSecret = server.secret

					ApiRequest.requestVersion { version in
						if let version {
							connectInfo = ""
							print(version)
							ConfigManager.shared.isRunning = true
						} else {
							connectInfo = "Failed to connect"
						}
					}
				} onDelete: {
					savedServers.removeAll {
						$0.id == server.id
					}
				}
			}
			.introspectTableView {
				$0.backgroundColor = NSColor.clear
				$0.enclosingScrollView?.drawsBackground = false
			}
		}
		.padding(.top)
		.fixedSize(horizontal: true, vertical: false)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
	
}

struct APISettingView_Previews: PreviewProvider {
    static var previews: some View {
        APISettingView()
    }
}
