//
//  FBQuadTreeNode.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBQuadTreeNode : NSObject {
    
    var boundingBox:FBBoundingBox? = nil
    
    var northEast:FBQuadTreeNode? = nil
    var northWest:FBQuadTreeNode? = nil
    var southEast:FBQuadTreeNode? = nil
    var southWest:FBQuadTreeNode? = nil
    
    var count = 0
    
    var annotations:[MKAnnotation] = []
    
    init(boundingBox box:FBBoundingBox){
        super.init()
        boundingBox = box
    }
    
    // MARK: - Bounding box functions
    
    class func FBBoundingBoxMake(x0:CGFloat, y0:CGFloat, xf:CGFloat, yf:CGFloat) -> FBBoundingBox{

        let box = FBBoundingBox(x0: x0, y0: y0, xf: xf, yf: yf)
        return box;
    }
    
    class func FBBoundingBoxForMapRect(mapRect: MKMapRect) -> FBBoundingBox {
        let topLeft: CLLocationCoordinate2D = MKCoordinateForMapPoint(mapRect.origin)
        let botRight: CLLocationCoordinate2D = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)))
        
        let minLat: CLLocationDegrees = botRight.latitude
        let maxLat: CLLocationDegrees = topLeft.latitude
        
        let minLon: CLLocationDegrees = topLeft.longitude
        let maxLon: CLLocationDegrees = botRight.longitude
        
        return FBBoundingBoxMake(CGFloat(minLat), y0: CGFloat(minLon), xf: CGFloat(maxLat), yf: CGFloat(maxLon))
    }
    
    func isLeaf() -> Bool {
        return (northEast == nil) ? true : false
    }
    
}