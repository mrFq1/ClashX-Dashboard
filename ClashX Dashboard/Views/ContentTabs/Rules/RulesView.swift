//
//  RulesView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct RulesView: View {
	
	@State var ruleProviders = [ClashRuleProvider]()
	
	@State var ruleItems = [ClashRule]()
	
	@State private var searchString: String = ""
	
	
	var providers: [ClashRuleProvider] {
		if searchString.isEmpty {
			return ruleProviders
		} else {
			return ruleProviders.filtered(searchString, for: ["name", "behavior", "type"])
		}
	}
	
	var rules: [EnumeratedSequence<[ClashRule]>.Element] {
		if searchString.isEmpty {
			return Array(ruleItems.enumerated())
		} else {
			return Array(ruleItems.filtered(searchString, for: ["type", "payload", "proxy"]).enumerated())
		}
	}
	
	
    var body: some View {
		List {
			ForEach(providers, id: \.self) {
				RuleProviderView(ruleProvider: $0)
			}
			
			ForEach(rules, id: \.element.id) {
				RuleItemView(index: $0.offset, rule: $0.element)
			}
		}
		.searchable(text: $searchString)
		.onAppear {
			ruleItems.removeAll()
			ApiRequest.getRules {
				ruleItems = $0
			}
			
			ApiRequest.requestRuleProviderList {
				ruleProviders = $0.allProviders.map {
					$0.value
				}.sorted {
					$0.name < $1.name
				}
			}
		}
    }
}

//struct RulesView_Previews: PreviewProvider {
//    static var previews: some View {
//        RulesView()
//    }
//}
