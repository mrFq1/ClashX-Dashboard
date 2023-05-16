//
//  ProxyProviderGroupView.swift
//  ClashX Dashboard
//
//

import SwiftUI

//struct ProxyProviderGroupView: View {
//	@Binding var columnCount: Int
//	
//	@Binding var providerInfo: ClashProvider
//	
//	@State private var proxyItems: [ProxyItemData]
//	
//	@State private var trafficInfo: String
//	@State private var expireDate: String
//	@State private var updateAt: String
//	
//	
//	@State private var isListExpanded = false
//	@State private var isTesting = false
//	@State private var isUpdating = false
//	
//	@EnvironmentObject var searchString: ProxiesSearchString
//	
//	init(columnCount: Binding<Int>,
//		 providerInfo: Binding<ClashProvider>) {
//		self._columnCount = columnCount
//		self._providerInfo = providerInfo
//		
//		let info = providerInfo.wrappedValue
//		
//		self.proxyItems = info.proxies.map(ProxyItemData.init)
//		
//		if let info = info.subscriptionInfo {
//			let used = info.download + info.upload
//			let total = info.total
//			
//			let formatter = ByteCountFormatter()
//			
//			trafficInfo = formatter.string(fromByteCount: used)
//			+ " / "
//			+ formatter.string(fromByteCount: total)
//			+ " ( \(String(format: "%.2f", Double(used)/Double(total/100)))% )"
//			
//			
//			let expire = info.expire
//			
//			expireDate = "Expire: "
//			+ Date(timeIntervalSince1970: TimeInterval(expire))
//				.formatted()
//		} else {
//			trafficInfo = ""
//			expireDate = ""
//		}
//		
//		if let updatedAt = info.updatedAt {
//			let formatter = RelativeDateTimeFormatter()
//			self.updateAt = formatter.localizedString(for: updatedAt, relativeTo: .now)
//		} else {
//			self.updateAt = ""
//		}
//	}
//	
//
//    var body: some View {
//		Section {
//			providerListView
//				.background {
//					Rectangle()
//						.frame(width: 2, height: listHeight(columnCount))
//						.foregroundColor(.clear)
//				}
//				.show(isVisible: !isListExpanded)
//			
//		} header: {
//			providerInfoView
//		} footer: {
//			HStack {
//				Button {
//					update()
//				} label: {
//					Label("Update", systemImage: "arrow.clockwise")
//				}
//				
//				.disabled(isUpdating)
//				
//				Button {
//					startBenchmark()
//				} label: {
//					Label("Benchmark", systemImage: "bolt.fill")
//				}
//				.disabled(isTesting)
//			}
//		}
//    }
//	
//	var providerInfoView: some View {
//		VStack(alignment: .leading) {
//			HStack {
//				Text(providerInfo.name)
//					.font(.title)
//					.fontWeight(.medium)
//				Text(providerInfo.vehicleType.rawValue)
//					.fontWeight(.regular)
//				Text("\(providerInfo.proxies.count)")
//				Button() {
//					isListExpanded = !isListExpanded
//				} label: {
//					Image(systemName: isListExpanded ? "chevron.up" : "chevron.down")
//				}
//				Button() {
//					update()
//				} label: {
//					Image(systemName: "arrow.clockwise")
//				}
//				.disabled(isUpdating)
//				
//				Button() {
//					startBenchmark()
//				} label: {
//					Image(systemName: "bolt.fill")
//				}
//				.disabled(isTesting)
//			}
//			
//			HStack {
//				if trafficInfo != "" {
//					Text(trafficInfo)
//						.fontWeight(.regular)
//				}
//				if expireDate != "" {
//					Text(expireDate)
//						.fontWeight(.regular)
//				}
//			}
//			if updateAt != "" {
//				Text("Updated \(updateAt)")
//					.fontWeight(.regular)
//			}
//		}
//	}
//	
//	var providerListView: some View {
//		LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
//								 count: columnCount)) {
//			ForEach($proxyItems, id: \.id) { item in
//				ProxyItemView(
//					proxy: item,
//					selectable: false
//				)
//				.background(.white)
//				.cornerRadius(8)
////				.onTapGesture {
////					let item = item.wrappedValue
////					updateSelect(item.name)
////				}
//				.show(isVisible: {
//					if searchString.string.isEmpty {
//						return true
//					} else {
//						return item.wrappedValue.name.lowercased().contains(searchString.string.lowercased())
//					}
//				}())
//			}
//		}
//	}
//	
//	func listHeight(_ columnCount: Int) -> Double {
//		let lineCount = ceil(Double(providerInfo.proxies.count) / Double(columnCount))
//		return lineCount * 60 + (lineCount - 1) * 8
//	}
//	
//	func startBenchmark() {
//		isTesting = true
//		let name = providerInfo.name
//		ApiRequest.healthCheck(proxy: name) {
//			ApiRequest.requestProxyProviderList {
//				isTesting = false
//				
//				guard let provider = $0.allProviders[name] else { return }
//				self.proxyItems = provider.proxies.map(ProxyItemData.init)
//			}
//		}
//	}
//	
//	func update() {
//		isUpdating = true
//		let name = providerInfo.name
//		ApiRequest.updateProvider(for: .proxy, name: name) { _ in
//			ApiRequest.requestProxyProviderList {
//				isUpdating = false
//				guard let provider = $0.allProviders[name] else { return }
//				self.providerInfo = provider
//			}
//		}
//	}
//	
//	
//}

//struct ProviderGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderGroupView()
//    }
//}
