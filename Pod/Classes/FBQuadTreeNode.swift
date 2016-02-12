//
//  FBQuadTreeNode.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

public class FBQuadTreeNode : NSObject {
    
    var boundingBox:FBBoundingBox? = nil
    
    var northEast:FBQuadTreeNode? = nil
    var northWest:FBQuadTreeNode? = nil
    var southEast:FBQuadTreeNode? = nil
    var southWest:FBQuadTreeNode? = nil
    
    var count = 0
    
    var annotations:[MKAnnotation] = []
    
    // MARK: - Initializers
    
    override init(){
        super.init()
    }
    
    init(boundingBox box:FBBoundingBox){
        super.init()
        boundingBox = box
    }
    
    // MARK: - Instance functions
    
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
    
    // MARK: - Class functions
    
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
    
    class func FBBoundingBoxIntersectsBoundingBox(box1:FBBoundingBox, box2:FBBoundingBox) -> Bool {
        return (box1.x0 <= box2.xf && box1.xf >= box2.x0 && box1.y0 <= box2.yf && box1.yf >= box2.y0);
    }
    
    class func FBMapRectForBoundingBox(boundingBox:FBBoundingBox) -> MKMapRect {
        let topLeft:MKMapPoint  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(CLLocationDegrees(boundingBox.x0), CLLocationDegrees(boundingBox.y0)));
        let botRight:MKMapPoint  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(CLLocationDegrees(boundingBox.xf), CLLocationDegrees(boundingBox.yf)));
        
        return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
    }
    
}