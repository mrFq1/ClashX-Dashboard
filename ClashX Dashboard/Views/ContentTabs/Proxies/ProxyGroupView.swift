//
//  ProxyView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProxyGroupView: View {
	
	@Binding var columnCount: Int
	
	@State var proxyGroup: ClashProxy
	@State var proxyInfo: ClashProxyResp
	@State private var proxyItems: [ProxyItemData]
	@State private var currentProxy: ClashProxyName
	@State private var isUpdatingSelect = false
	@State private var selectable = false
	
	@State private var isListExpanded = false
	@State private var isTesting = false
	
	@EnvironmentObject var searchString: ProxiesSearchString
	
	init(columnCount: Binding<Int>,
		 proxyGroup: ClashProxy,
		 proxyInfo: ClashProxyResp) {
		
		self._columnCount = columnCount
		self.proxyGroup = proxyGroup
		self.proxyInfo = proxyInfo
		self.currentProxy = proxyGroup.now ?? ""
		self.selectable = [.select, .fallback].contains(proxyGroup.type)

		self.proxyItems = proxyGroup.all?.compactMap { name in
			proxyInfo.proxiesMap[name]
		}.map(ProxyItemData.init) ?? []
	}
	
	
    var body: some View {
		Section {
			proxyListView
				.background {
					Rectangle()
						.frame(width: 2, height: listHeight(columnCount))
						.foregroundColor(.clear)
				}
				.show(isVisible: !isListExpanded)
			
		} header: {
			proxyInfoView
		}
    }
	
	var proxyInfoView: some View {
		HStack() {
			Text(proxyGroup.name)
				.font(.title)
				.fontWeight(.medium)
			Text(proxyGroup.type.rawValue)
			Text("\(proxyGroup.all?.count ?? 0)")
			Button() {
				isListExpanded = !isListExpanded
			} label: {
				Image(systemName: isListExpanded ? "chevron.up" : "chevron.down")
			}
			
			Button() {
				startBenchmark()
			} label: {
				Image(systemName: "bolt.fill")
			}
			.disabled(isTesting)
		}
	}
	
	var proxyListView: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
								 count: columnCount)) {
			ForEach($proxyItems, id: \.id) { item in
				ProxyItemView(
					proxy: item,
					selectable: selectable
				)
				.background(currentProxy == item.wrappedValue.name ? Color.teal : Color.white)
				.cornerRadius(8)
				.onTapGesture {
					let item = item.wrappedValue
					updateSelect(item.name)
				}
				.show(isVisible: {
					if searchString.string.isEmpty {
						return true
					} else {
						return item.wrappedValue.name.lowercased().contains(searchString.string.lowercased())
					}
				}())
			}
		}
	}
	
	func listHeight(_ columnCount: Int) -> Double {
		let lineCount = ceil(Double(proxyItems.count) / Double(columnCount))
		return lineCount * 60 + (lineCount - 1) * 8
	}
	

	func startBenchmark() {
		isTesting = true
		ApiRequest.getGroupDelay(groupName: proxyGroup.name) { delays in
			proxyGroup.all?.forEach { proxyName in
				var delay = 0
				if let d = delays[proxyName], d != 0 {
					delay = d
				}
				
				proxyItems.first {
					$0.name == proxyName
				}?.delay = delay
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
			currentProxy = name
		}
	}
	
}

//struct ProxyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProxyGroupView()
//    }
//}
//
