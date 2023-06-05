//
//  RuleProviderView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct RuleProviderView: View {
	
	@State var provider: DBRuleProvider
	
    var body: some View {
        
		VStack(alignment: .leading) {
			HStack {
				Text(provider.name)
					.font(.title)
					.fontWeight(.medium)
				Text(provider.type)
				Text(provider.behavior)
				Spacer()
			}
			
			HStack {
				Text("\(provider.ruleCount) rules")
				if let date = provider.updatedAt {
					Text("Updated \(RelativeDateTimeFormatter().localizedString(for: date, relativeTo: .now))")
				}
				Spacer()
			}
			.font(.system(size: 12))
			.foregroundColor(.secondary)
		}
    }
}

//struct RuleProviderView_Previews: PreviewProvider {
//    static var previews: some View {
//        RuleProviderView()
//    }
//}
