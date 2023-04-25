//
//  ArrayExtensions.swift
//  ClashX Dashboard
//
//

import Foundation


extension Array where Element: NSObject {
	func sorted(descriptors: [NSSortDescriptor]) -> [Element] {
		return (self as NSArray).sortedArray(using: descriptors) as! [Element]
	}
	
	func filtered(_ str: String, for keys: [String]) -> [Element] {
		
		guard str != "", keys.count > 0 else { return self }

		let format = keys.map {
			$0 + " CONTAINS[c] %@"
		}.joined(separator: " OR ")
		
		let arg = str as CVarArg
		
		let args: [CVarArg] = {
			let args = NSMutableArray()
			for _ in 0..<keys.count {
				args.add(arg)
			}
			return args as! [CVarArg]
		}()
		
		let predicate = NSPredicate(format: format, args)
		let re = NSMutableArray(array: self)
			
		re.filter(using: predicate)
		return re as! [Element]
	}
}
