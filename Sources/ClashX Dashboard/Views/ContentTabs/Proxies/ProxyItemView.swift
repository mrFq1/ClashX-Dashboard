//
//  ProxyItemView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProxyItemView: View {
	
	@ObservedObject var proxy: DBProxy
	@State var selectable: Bool
	
	@EnvironmentObject var hideProxyNames: HideProxyNames
	
	init(proxy: DBProxy, selectable: Bool) {
		self.proxy = proxy
		self.selectable = selectable
		
		self.isBuiltInProxy = [.pass, .direct, .reject].contains(proxy.type)
	}
	
	@State private var isBuiltInProxy: Bool
	@State private var mouseOver = false
	
	var body: some View {
		VStack {
			HStack(alignment: .center) {
				Text(hideProxyNames.hide
					 ? String(proxy.id.prefix(8))
					 : proxy.name)
					.truncationMode(.tail)
					.lineLimit(1)
				Spacer(minLength: 6)
				
				Text(proxy.udpString)
					.foregroundColor(.secondary)
					.font(.system(size: 11))
					.show(isVisible: !isBuiltInProxy)
			}
			
			Spacer(minLength: 6)
				.show(isVisible: !isBuiltInProxy)
			HStack(alignment: .center) {
				Text(proxy.type.rawValue)
					.foregroundColor(.secondary)
					.font(.system(size: 12))
				
				Text("[TFO]")
					.font(.system(size: 9))
					.show(isVisible: proxy.tfo)
				Spacer(minLength: 6)
				Text(proxy.delayString)
					.foregroundColor(proxy.delayColor)
					.font(.system(size: 11))
			}
			.show(isVisible: !isBuiltInProxy)
		}
		.onHover {
			guard selectable else { return }
			mouseOver = $0
		}
		.frame(height: 36)
		.padding(12)
		.overlay(
			RoundedRectangle(cornerRadius: 6)
				.stroke(mouseOver ? .secondary : Color.clear, lineWidth: 2)
				.padding(1)
		)
		
	}
}

//struct ProxyItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProxyItemView()
//    }
//}
