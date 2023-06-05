//
//  RulesView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct RulesView: View {
	
	@State var ruleItems = [ClashRule]()
	
	@State private var searchString: String = ""
	
	
	var rules: [EnumeratedSequence<[ClashRule]>.Element] {
		if searchString.isEmpty {
			return Array(ruleItems.enumerated())
		} else {
			return Array(ruleItems.filtered(searchString, for: ["type", "payload", "proxy"]).enumerated())
		}
	}
	
	
    var body: some View {
		List {
			ForEach(rules, id: \.element.id) {
				RuleItemView(index: $0.offset, rule: $0.element)
			}
		}
		.searchable(text: $searchString)
		.onReceive(NotificationCenter.default.publisher(for: .toolbarSearchString)) {
			guard let string = $0.userInfo?["String"] as? String else { return }
			searchString = string
		}
		.onAppear {
			ruleItems.removeAll()
			ApiRequest.getRules {
				ruleItems = $0
			}
		}
    }
}

//struct RulesView_Previews: PreviewProvider {
//    static var previews: some View {
//        RulesView()
//    }
//}
