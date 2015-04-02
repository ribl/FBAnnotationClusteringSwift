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
    
    override init(){
        super.init()
    }
    
    init(boundingBox box:FBBoundingBox){
        super.init()
        boundingBox = box
    }
    
    // MARK: - Bounding box functions
    
    class func FBBoundingBoxMake(x0:CGFloat, y0:CGFloat, xf:CGFloat, yf:CGFloat) -> FBBoundingBox{

        let box = FBBoundingBox(x0: x0, y0: y0, xf: xf, yf: yf)
        return box;
    }
    
    class func FBBoundingBoxContainsCoordinate(box:FBBoundingBox, coordinate:CLLocationCoordinate2D) -> Bool {
        let containsX:Bool = (box.x0 <= CGFloat(coordinate.latitude)) && (CGFloat(coordinate.latitude) <= box.xf)
        let containsY:Bool = (box.y0 <= CGFloat(coordinate.longitude)) && (CGFloat(coordinate.longitude) <= box.yf)
        return (containsX && containsY)
    }
    
    class func FBBoundingBoxForMapRect(mapRect: MKMapRect) -> FBBoundingBox {
        let topLeft: CLLocationCoordinate2D = MKCoordinateForMapPoint(mapRect.origin)
        let botRight: CLLocationCoordinate2D = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)))
        
        let minLat: CLLocationDegrees = botRight.latitude
        let maxLat: CLLocationDegrees = topLeft.latitude
        
        let minLon: CLLocationDegrees = topLeft.longitude
        let maxLon: CLLocationDegrees = botRight.longitude
        
        return FBQuadTreeNode.FBBoundingBoxMake(CGFloat(minLat), y0: CGFloat(minLon), xf: CGFloat(maxLat), yf: CGFloat(maxLon))
    }
    
    func isLeaf() -> Bool {
        return (northEast == nil) ? true : false
    }
    
    func subdivide(){
        
        northEast = FBQuadTreeNode()
        northWest = FBQuadTreeNode()
        southEast = FBQuadTreeNode()
        southWest = FBQuadTreeNode()
        
        let box = boundingBox!

        let xMid:CGFloat = (box.xf + box.x0) / 2.0
        let yMid:CGFloat = (box.yf + box.y0) / 2.0

        
        northEast!.boundingBox = FBQuadTreeNode.FBBoundingBoxMake(xMid, y0:box.y0, xf:box.xf, yf:yMid)
        northWest!.boundingBox = FBQuadTreeNode.FBBoundingBoxMake(box.x0, y0:box.y0, xf:xMid, yf:yMid)
        southEast!.boundingBox = FBQuadTreeNode.FBBoundingBoxMake(xMid, y0:yMid, xf:box.xf, yf:box.yf)
        southWest!.boundingBox = FBQuadTreeNode.FBBoundingBoxMake(box.x0, y0:yMid, xf:xMid, yf:box.yf)
    }
    
}