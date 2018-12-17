//
//  FBBoundingBox+MapKit.swift
//  Pods
//
//  Created by Antoine Lamy on 23/9/2016.
//
//

import Foundation
import MapKit

extension FBBoundingBox {

	init(mapRect: MKMapRect) {
		let topLeft = mapRect.origin.coordinate
        let bottomRight = MKMapPoint(x: mapRect.maxX, y: mapRect.maxY).coordinate

		let minLat = bottomRight.latitude
		let maxLat = topLeft.latitude

		let minLon = topLeft.longitude
		let maxLon = bottomRight.longitude

		self.init(x0: CGFloat(minLat), y0: CGFloat(minLon), xf: CGFloat(maxLat), yf: CGFloat(maxLon))
	}

	func contains(coordinate: CLLocationCoordinate2D) -> Bool {
		let containsX = (x0 <= CGFloat(coordinate.latitude)) && (CGFloat(coordinate.latitude) <= xf)
		let containsY = (y0 <= CGFloat(coordinate.longitude)) && (CGFloat(coordinate.longitude) <= yf)
		return (containsX && containsY)
	}

	func mapRect() -> MKMapRect {
        let topLeft  = MKMapPoint(CLLocationCoordinate2DMake(CLLocationDegrees(x0), CLLocationDegrees(y0)))
        let botRight  = MKMapPoint(CLLocationCoordinate2DMake(CLLocationDegrees(xf), CLLocationDegrees(yf)))
        return MKMapRect(x: topLeft.x, y: botRight.y, width: fabs(botRight.x - topLeft.x), height: fabs(botRight.y - topLeft.y))
	}
}
