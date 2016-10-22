//
//  FBZoomLevel.swift
//  Pods
//
//  Created by Antoine Lamy on 25/9/2016.
//
//

import Foundation
import MapKit

typealias ZoomLevel = Int
extension ZoomLevel {

	init(scale: MKZoomScale) {
		let totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0
		let zoomLevelAtMaxZoom = Int(log2(totalTilesAtMaxZoom))
		let floorLog2ScaleFloat = floor(log2f(Float(scale))) + 0.5

		if !floorLog2ScaleFloat.isInfinite {
			let sum = zoomLevelAtMaxZoom + Int(floorLog2ScaleFloat)
			let zoomLevel = altmax(0, sum)
			self = zoomLevel
		} else {
			self = floorLog2ScaleFloat.sign == .plus ? 0 : 19
		}
	}

	func cellSize() -> CGFloat {
		switch (self) {
		case 13...15:
			return 64
		case 16...18:
			return 32
		case 18 ..< Int.max:
			return 16
		default:
			return 88 // Less than 13
		}
	}
}

// Required due to conflict with Int static variable 'max'
public func altmax<T : Comparable>(_ x: T, _ y: T) -> T {
	return max(x, y)
}
