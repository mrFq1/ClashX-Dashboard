//
//  ProxyGroupInfoView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProxyGroupRowView: View {
	
	@ObservedObject var proxyGroup: DBProxyGroup

	@EnvironmentObject var hideProxyNames: HideProxyNames
	
    var body: some View {
		NavigationLink {
			ProxyGroupView(proxyGroup: proxyGroup)
		} label: {
			labelView
		}
    }
	
	var labelView: some View {
		VStack(spacing: 2) {
			HStack(alignment: .center) {
				Text(hideProxyNames.hide
					 ? String(proxyGroup.id.prefix(8))
					 : proxyGroup.name)
					.font(.system(size: 15))
				Spacer()
				if let proxy = proxyGroup.currentProxy {
					Text(proxy.delayString)
						.foregroundColor(proxy.delayColor)
						.font(.system(size: 12))
				}
			}
			
			HStack {
				Text(proxyGroup.type.rawValue)
				Spacer()
				if let proxy = proxyGroup.currentProxy {
					Text(hideProxyNames.hide
						 ? String(proxy.id.prefix(8))
						 : proxy.name)
				}
			}
			.font(.system(size: 11))
			.foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
	}
}

