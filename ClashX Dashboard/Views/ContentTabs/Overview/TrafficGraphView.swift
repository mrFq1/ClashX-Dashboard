//
//  TrafficGraphView.swift
//  ClashX Dashboard
//
//

import SwiftUI
import DSFSparkline

fileprivate let labelsCount = 4

struct TrafficGraphView: View {
	@Binding var values: [CGFloat]
	
	@State var graphColor: DSFColor
	
	init(values: Binding<[CGFloat]>,
		 graphColor: DSFColor) {
		self._values = values
		self.graphColor = graphColor
		
		updateChart(values.wrappedValue)
	}
	
	
	@State private var labels = [String]()
	@State private var dataSource = DSFSparkline.DataSource()
	
	
    var body: some View {
		HStack {
			VStack {
				ForEach(Array(labels.enumerated()), id: \.offset) {
					Text($0.element)
						.font(.system(size: 11, weight: .light))
					Spacer()
				}
			}
			graphView
		}
		.onChange(of: values) { newValue in
			updateChart(newValue)
		}
		
    }
	
	var graphView: some View {
		ZStack {
			DSFSparklineLineGraphView.SwiftUI(
				dataSource: dataSource,
				graphColor: graphColor,
				interpolated: false,
				showZeroLine: false
			)
			
			DSFSparklineSurface.SwiftUI([
				gridOverlay
			])
		}
	}
	
	let gridOverlay: DSFSparklineOverlay = {
		let grid = DSFSparklineOverlay.GridLines()
		grid.dataSource = .init(values: [1], range: 0...1)
		
		
		var floatValues = [CGFloat]()
		for i in 0...labelsCount {
			floatValues.append(CGFloat(i) / CGFloat(labelsCount))
		}
		let _ = floatValues.removeFirst()
		
		grid.floatValues = floatValues.reversed()
		
		grid.strokeColor = DSFColor.systemGray.withAlphaComponent(0.3).cgColor
		grid.strokeWidth = 0.5
		grid.dashStyle = [2, 2]

		return grid
	}()
	
	
	func updateChart(_ values: [CGFloat]) {
		let max = values.max() ?? CGFloat(labelsCount) * 1000
		
		let byte = Int64(max)
		let kb = byte / 1000
		
		var v1: Double = 0
		var v2 = ""
		var v3: Double = 1
		
		switch kb {
		case 0..<Int64(labelsCount):
			v1 = Double(labelsCount)
			v2 = "KB/s"
		case Int64(labelsCount)..<100:
			// 0 - 99 KB/s
			v1 = Double(kb)
			v2 = "KB/s"
		case 100..<100_000:
			// 0.1 - 99MB/s
			v1 = Double(kb) / 1_000
			v2 = "MB/s"
			v3 = 1_000
		default:
			// case 10_000..<100_000:
			// 0.1 - 10GB/s
			v1 = Double(kb) / 1_000_000
			v2 = "GB/s"
			v3 = 1_000_000
		}
		
		v1 = (v1 * 10).rounded() / 10
		
		let vv = v1.truncatingRemainder(dividingBy: 1) == 0 ? Double(labelsCount) : Double(labelsCount) / 10
		
		if v1.truncatingRemainder(dividingBy: vv) != 0 {
			v1 = ((v1 / vv).rounded() + 1) * vv
		}
		
		
		var re = [String]()
		
		for i in 0...labelsCount {
			let s = String(format: "%.1f%@", v1 * Double(i) / Double(labelsCount), v2)
			re.append(s)
		}
		re = re.reversed()
		let _ = re.removeLast()
		
		
		self.dataSource.set(values: values)
		
		let upperBound = CGFloat(v1*v3)
		if upperBound != 0,
		   let old = self.dataSource.range?.upperBound,
		   old != upperBound {
			self.dataSource.setRange(lowerBound: 0, upperBound: upperBound)
			self.dataSource.resetRange()
		}
		
		self.labels = re
	}
}

//struct TrafficGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrafficGraphView()
//    }
//}
