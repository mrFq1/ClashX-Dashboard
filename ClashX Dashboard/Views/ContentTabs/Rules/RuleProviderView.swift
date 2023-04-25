//
//  RuleProviderView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct RuleProviderView: View {
	
	@State var ruleProvider: ClashRuleProvider
	
    var body: some View {
        
		VStack(alignment: .leading) {
			HStack {
				Text(ruleProvider.name)
					.font(.title)
					.fontWeight(.medium)
				Text(ruleProvider.type)
				Text(ruleProvider.behavior)
			}
			
			HStack {
				Text("\(ruleProvider.ruleCount) rules")
				if let date = ruleProvider.updatedAt {
					Text("Updated \(RelativeDateTimeFormatter().localizedString(for: date, relativeTo: .now))")
				}
			}
		}
    }
}

//struct RuleProviderView_Previews: PreviewProvider {
//    static var previews: some View {
//        RuleProviderView()
//    }
//}
