//
//  ProviderProxiesView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProviderProxiesView: View {
	
	@ObservedObject var provider: DBProxyProvider
	@EnvironmentObject var hideProxyNames: HideProxyNames
	@EnvironmentObject var searchString: ProxiesSearchString
	
	@State private var columnCount: Int = 3
	@State private var isTesting = false
	@State private var isUpdating = false
	
	var proxies: [DBProxy] {
		if searchString.string.isEmpty {
			return provider.proxies
		} else {
			return provider.proxies.filter {
				$0.name.lowercased().contains(searchString.string.lowercased())
			}
		}
	}
	
    var body: some View {
		ScrollView {
			Section {
				proxyListView
			} header: {
				HStack {
					ProxyProviderInfoView(provider: provider)
					buttonsView
				}
			}
			.padding()
		}
		.background {
			GeometryReader { geometry in
				Rectangle()
					.fill(.clear)
					.frame(height: 1)
					.onChange(of: geometry.size.width) { newValue in
						updateColumnCount(newValue)
					}
					.onAppear {
						updateColumnCount(geometry.size.width)
					}
			}.padding()
		}
    }
	
	func updateColumnCount(_ width: Double) {
		let v = Int(Int(width) / 180)
		let new = v == 0 ? 1 : v
		
		if new != columnCount {
			columnCount = new
		}
	}
	
	var proxyListView: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
								 count: columnCount)) {
			ForEach(proxies, id: \.id) { proxy in
				ProxyItemView(
					proxy: proxy,
					selectable: false
				)
				.background(.white)
				.cornerRadius(8)
			}
		}
	}
	

	
	var buttonsView: some View {
		VStack {
			Button() {
				startHealthCheck()
			} label: {
				HStack {
					if isTesting {
						ProgressView()
							.controlSize(.small)
							.frame(width: 12)
					} else {
						Image(systemName: "bolt.fill")
							.frame(width: 12)
					}
					Text(isTesting ? "Testing" : "Health Check")
						.frame(width: 90)
				}
				.foregroundColor(isTesting ? .gray : .blue)
			}
			.disabled(isTesting)
			
			Button() {
				startUpdate()
			} label: {
				HStack {
					if isUpdating {
						ProgressView()
							.controlSize(.small)
							.frame(width: 12)
					} else {
						Image(systemName: "arrow.clockwise")
							.frame(width: 12)
					}
					Text(isUpdating ? "Updating" : "Update")
						.frame(width: 90)
				}
				.foregroundColor(isUpdating ? .gray : .blue)
			}
			.disabled(isTesting)
		}
	}
	
	func startHealthCheck() {
		isTesting = true
		ApiRequest.healthCheck(proxy: provider.name) {
			updateProvider {
				isTesting = false
			}
		}
	}
	
	func startUpdate() {
		isUpdating = true
		ApiRequest.updateProvider(for: .proxy, name: provider.name) { _ in
			updateProvider {
				isUpdating = false
			}
		}
	}
	
	func updateProvider(_ completeHandler: (() -> Void)? = nil) {
		ApiRequest.requestProxyProviderList { resp in
			if let p = resp.allProviders[provider.name] {
				let new = DBProxyProvider(provider: p)
				provider.proxies = new.proxies
				provider.updatedAt = new.updatedAt
				provider.expireDate = new.expireDate
				provider.trafficInfo = new.trafficInfo
				provider.trafficPercentage = new.trafficPercentage
			}
			completeHandler?()
		}
	}
}

//struct ProviderProxiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderProxiesView()
//    }
//}
