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
		VStack(alignment: .leading) {
			HStack {
				Text(name)
					.font(.subheadline)
					.foregroundColor(.secondary)
				Spacer()
			}
			Spacer()
			Text(value)
				.font(.system(size: 16))
		}
		.frame(width: 130, height: 45)
		.padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
		.background(.white)
		.cornerRadius(12)
    }
}

struct OverviewTopItemView_Previews: PreviewProvider {
	@State static var value: String = "Value"
	static var previews: some View {
		OverviewTopItemView(name: "Name", value: $value)
    }
}
