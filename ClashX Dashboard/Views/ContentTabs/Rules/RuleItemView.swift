//
//  RuleItemView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct RuleItemView: View {
	@State var index: Int
	@State var rule: ClashRule
	
    var body: some View {
		HStack(alignment: .center, spacing: 12) {
			Text("\(index)")
				.font(.system(size: 16))
				.foregroundColor(.secondary)
				.frame(width: 30)
			
			VStack(alignment: .leading) {
				if let payload = rule.payload,
				   payload != "" {
					Text(rule.payload!)
						.font(.system(size: 14))
				}
				
				HStack() {
					Text(rule.type)
						.foregroundColor(.secondary)
						.frame(width: 120, alignment: .leading)
					
					Text(rule.proxy ?? "")
						.foregroundColor({
							switch rule.proxy {
							case "DIRECT":
								return .orange
							case "REJECT":
								return .red
							default:
								return .blue
							}
						}())
				}
			}
		}
    }
	
	
}

struct RulesRowView_Previews: PreviewProvider {
    static var previews: some View {
		RuleItemView(index: 114, rule: .init(type: "DIRECT", payload: "cn", proxy: "GeoSite"))
    }
}


extension HorizontalAlignment {

	private struct RuleItemOBAlignment: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			context[.leading]
		}
	}

	static let ruleItemOBAlignmentGuide = HorizontalAlignment(
		RuleItemOBAlignment.self
	)
}
