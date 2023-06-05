//
//  APIServerItem.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct APIServerItem: View {
	@State var server: String
	
	var action: () -> Void
	var onDelete: () -> Void
	
	@State private var mouseOver = false
	
    var body: some View {
		HStack {
			Button("X") {
				onDelete()
			}
			.buttonStyle(.bordered)
			
			Button() {
				action()
			} label: {
				Text(server)
					.font(.title2)
			}
			.buttonStyle(.borderless)
			
			Spacer()
		}
		.frame(height: 21)
		.padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
		.overlay(
			RoundedRectangle(cornerRadius: 6)
				.stroke(.secondary, lineWidth: 1)
				.padding(1)
		)
    }
}

//struct APIServerItem_Previews: PreviewProvider {
//    static var previews: some View {
//        APIServerItem()
//    }
//}
