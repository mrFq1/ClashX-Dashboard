//
//  ConfigItemView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ConfigItemView<Content: View>: View {
	
	@State var name: String
	var content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text(name)
					.font(.subheadline)
					.foregroundColor(.secondary)
				Spacer()
			}
			HStack(content: content)
		}
		.padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
		.background(Color(nsColor: .textBackgroundColor))
		.cornerRadius(10)
	}
}

struct ConfigItemView_Previews: PreviewProvider {
    static var previews: some View {
		ConfigItemView(name: "test") {
			Text("label")
		}
    }
}
