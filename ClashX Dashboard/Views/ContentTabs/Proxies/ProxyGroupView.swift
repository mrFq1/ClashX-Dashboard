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
			
			Button() {
				startBenchmark()
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
					Text(isTesting ? "Testing" : (proxyGroup.type == .urltest ? "Retest" : "Benchmark"))
						.frame(width: 70)
				}
				.foregroundColor(isTesting ? .gray : .blue)
			}
			.disabled(isTesting)
		}
	}
	
	var proxyListView: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
								 count: columnCount)) {
			ForEach($proxyGroup.proxies, id: \.id) { proxy in
				ProxyItemView(
					proxy: proxy,
					selectable: selectable
				)
				.background(proxyGroup.now == proxy.wrappedValue.name ? Color.teal : Color.white)
				.cornerRadius(8)
				.onTapGesture {
					let item = proxy.wrappedValue
					updateSelect(item.name)
				}
				.show(isVisible: {
					if searchString.string.isEmpty {
						return true
					} else {
						return proxy.wrappedValue.name.lowercased().contains(searchString.string.lowercased())
					}
				}())
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
