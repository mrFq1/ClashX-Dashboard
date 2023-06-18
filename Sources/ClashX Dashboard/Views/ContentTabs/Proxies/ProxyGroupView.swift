//
//  ProxyView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProxyGroupView: View {
	
	@ObservedObject var proxyGroup: DBProxyGroup
	@EnvironmentObject var searchString: ProxiesSearchString
	
	@EnvironmentObject var hideProxyNames: HideProxyNames
	
	@State private var columnCount: Int = 3
	@State private var isUpdatingSelect = false
	@State private var selectable = false
	@State private var isTesting = false
	
	var proxies: [DBProxy] {
		if searchString.string.isEmpty {
			return proxyGroup.proxies
		} else {
			return proxyGroup.proxies.filter {
				$0.name.lowercased().contains(searchString.string.lowercased())
			}
		}
	}
	
	var body: some View {
		ScrollView {
			Section {
				proxyListView
			} header: {
				proxyInfoView
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
		.onAppear {
			self.selectable = [.select, .fallback].contains(proxyGroup.type)
		}
	}
	
	func updateColumnCount(_ width: Double) {
		let v = Int(Int(width) / 180)
		let new = v == 0 ? 1 : v
		
		if new != columnCount {
			columnCount = new
		}
	}
	
	
	var proxyInfoView: some View {
		HStack() {
			Text(hideProxyNames.hide
				 ? String(proxyGroup.id.prefix(8))
					: proxyGroup.name)
				.font(.system(size: 17))
			Text(proxyGroup.type.rawValue)
				.font(.system(size: 13))
				.foregroundColor(.secondary)
			Text("\(proxyGroup.proxies.count)")
				.font(.system(size: 11))
				.padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
				.background(Color.gray.opacity(0.5))
				.cornerRadius(4)
			
			Spacer()
			
			ProgressButton(
				title: proxyGroup.type == .urltest ? "Retest" : "Benchmark",
				title2: "Testing",
				iconName: "bolt.fill",
				inProgress: $isTesting) {
					startBenchmark()
				}
		}
	}
	
	var proxyListView: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
								 count: columnCount)) {
			ForEach(proxies, id: \.id) { proxy in
				ProxyItemView(
					proxy: proxy,
					selectable: [.select, .fallback].contains(proxyGroup.type)
				)
				.background(proxyGroup.now == proxy.name ? Color.pink.opacity(0.3) : Color(nsColor: .textBackgroundColor))
				.cornerRadius(8)
				.onTapGesture {
					let item = proxy
					updateSelect(item.name)
				}
			}
		}
	}

	func startBenchmark() {
		isTesting = true
		ApiRequest.getGroupDelay(groupName: proxyGroup.name) { delays in
			proxyGroup.proxies.enumerated().forEach {
				var delay = 0
				if let d = delays[$0.element.name], d != 0 {
					delay = d
				}
				guard $0.offset < proxyGroup.proxies.count,
					  proxyGroup.proxies[$0.offset].name == $0.element.name
				else { return }
				proxyGroup.proxies[$0.offset].delay = delay
				
				if proxyGroup.currentProxy?.name == $0.element.name {
					proxyGroup.currentProxy = proxyGroup.proxies[$0.offset]
				}
			}
			isTesting = false
		}
	}
	
	func updateSelect(_ name: String) {
		guard selectable, !isUpdatingSelect else { return }
		isUpdatingSelect = true
		ApiRequest.updateProxyGroup(group: proxyGroup.name, selectProxy: name) { success in
			isUpdatingSelect = false
			guard success else { return }
			proxyGroup.now = name
		}
	}
	
}

//struct ProxyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProxyGroupView()
//    }
//}
//
