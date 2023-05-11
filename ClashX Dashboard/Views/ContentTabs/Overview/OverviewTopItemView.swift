//
//  OverviewTopItemView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct OverviewTopItemView: View {
	
	@State var name: String
	@Binding var value: String
	
    var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text(name)
					.font(.subheadline)
					.foregroundColor(.secondary)
				Spacer()
			}
			Text(value)
				.font(.system(size: 16))
		}
		.frame(width: 125)
		.padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
		.background(.white)
		.cornerRadius(10)
    }
}

struct OverviewTopItemView_Previews: PreviewProvider {
	@State static var value: String = "Value"
	static var previews: some View {
		OverviewTopItemView(name: "Name", value: $value)
    }
}
