//
//  OverviewView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import DSFSparkline

struct OverviewView: View {
	
	@EnvironmentObject var data: ClashOverviewData
	
	@State private var columnCount: Int = 4
	
    var body: some View {
		VStack(spacing: 25) {
			
			
			
			LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnCount)) {
				
				OverviewTopItemView(name: "Upload", value: $data.uploadString)
				OverviewTopItemView(name: "Download", value: $data.downloadString)
				OverviewTopItemView(name: "Upload Total", value: $data.uploadTotal)
				OverviewTopItemView(name: "Download Total", value: $data.downloadTotal)
				
				OverviewTopItemView(name: "Active Connections", value: $data.activeConns)
				OverviewTopItemView(name: "Memory Usage", value: $data.memory)
			}
			
			.background {
				GeometryReader { geometry in
					Rectangle()
						.fill(.clear)
						.frame(height: 1)
						.onChange(of: geometry.size.width) { newValue in
							updateColumnCount(newValue)
						}
						.onAppear {
							updateColumnCount(geometry.size.width)
						}
				}.padding()
			}


			
			HStack {
				RoundedRectangle(cornerRadius: 2)
					.fill(Color(nsColor: .systemBlue))
					.frame(width: 20, height: 13)
				Text("Down")
				
				RoundedRectangle(cornerRadius: 2)
					.fill(Color(nsColor: .systemGreen))
					.frame(width: 20, height: 13)
				Text("Up")
			}
			
			
			TrafficGraphView(values: $data.downloadHistories,
							 graphColor: .systemBlue)

			TrafficGraphView(values: $data.uploadHistories,
							 graphColor: .systemGreen)

		}.padding()
    }
	
	func updateColumnCount(_ width: Double) {
		let v = Int(Int(width) / 155)
		let new = v == 0 ? 1 : v
		
		if new != columnCount {
			columnCount = new
		}
	}
	
}

//struct OverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverviewView()
//    }
//}
