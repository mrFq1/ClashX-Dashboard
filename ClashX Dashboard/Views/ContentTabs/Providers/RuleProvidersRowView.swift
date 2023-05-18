//
//  RuleProvidersRowView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct RuleProvidersRowView: View {
	
	@ObservedObject var providerStorage: DBProviderStorage
	
	@State private var isUpdating = false
	
    var body: some View {
		NavigationLink {
			contentView
		} label: {
			Text("Rule")
				.font(.system(size: 15))
				.padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
		}
    }
	
	var contentView: some View {
		ScrollView {
			Section {
				VStack(spacing: 12) {
					ForEach(providerStorage.ruleProviders, id: \.id) {
						RuleProviderView(provider: $0)
					}
				}
			} header: {
				Button {
					updateAll()
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
						Text(isUpdating ? "Updating" : "Update All")
							.frame(width: 80)
					}
					.foregroundColor(isUpdating ? .gray : .blue)
				}
				.disabled(isUpdating)
			}
			.padding()
		}
	}
	
	func updateAll() {
		isUpdating = true
		ApiRequest.updateAllProviders(for: .rule) { _ in
			ApiRequest.requestRuleProviderList { resp in
				providerStorage.ruleProviders = resp.allProviders.values.sorted {
					$0.name < $1.name
				}
				.map(DBRuleProvider.init)
				isUpdating = false
			}
		}
	}
}

//struct ProxyProvidersRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RuleProvidersRowView()
//    }
//}
