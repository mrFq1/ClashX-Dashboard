//
//  ProviderRowView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ProviderRowView: View {
	
	@ObservedObject var proxyProvider: DBProxyProvider
	@EnvironmentObject var hideProxyNames: HideProxyNames
	
	var body: some View {
		NavigationLink {
			ProviderProxiesView(provider: proxyProvider)
		} label: {
			labelView
		}
	}
	
    var labelView: some View {
		VStack(spacing: 2) {
			HStack(alignment: .center) {
				Text(hideProxyNames.hide
					 ? String(proxyProvider.id.prefix(8))
					 : proxyProvider.name)
					.font(.system(size: 15))
				Spacer()
				Text(proxyProvider.trafficPercentage)
					.font(.system(size: 12))
					.foregroundColor(.secondary)
			}

			HStack {
				Text(proxyProvider.vehicleType.rawValue)
				Spacer()
				Text(proxyProvider.updatedAt)
			}
			.font(.system(size: 11))
			.foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 1, leading: 4, bottom: 1, trailing: 4))
	}
}

//struct ProviderRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderRowView()
//    }
//}
