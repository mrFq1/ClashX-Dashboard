//
//  OverviewView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import DSFSparkline

struct OverviewView: View {
	
	@EnvironmentObject var data: ClashOverviewData
	
	
	
    var body: some View {
		VStack(spacing: 25) {
			HStack() {
				OverviewTopItemView(name: "Upload", value: $data.uploadString)
				OverviewTopItemView(name: "Download", value: $data.downloadString)
				OverviewTopItemView(name: "Upload Total", value: $data.uploadTotal)
				OverviewTopItemView(name: "Download Total", value: $data.downloadTotal)
				OverviewTopItemView(name: "Active Connections", value: $data.activeConns)
			}
			
	
			
			TrafficGraphView(values: $data.downloadHistories,
							 graphColor: .systemBlue)

			TrafficGraphView(values: $data.uploadHistories,
							 graphColor: .systemGreen)

			
		}.padding()
    }
	
}

//struct OverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverviewView()
//    }
//}
