//
//  FBQuadTree.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBQuadTree : NSObject {
    
    var rootNode:FBQuadTreeNode? = nil
    
    let nodeCapacity = 8
    
    override init (){
        super.init()

        //rootNode = FBQuadTreeNode(initWithBoundingBox:FBBoundingBoxForMapRect(MKMapRectWorld))
        
    }
    
    func insertAnnotation(annotation:MKAnnotation) -> Bool {
        return insertAnnotation(annotation, toNode:rootNode!)
    }
    
    func insertAnnotation(annotation:MKAnnotation, toNode node:FBQuadTreeNode) -> Bool {
        
        //if !FBBoundingBoxContainsCoordinate(node.boundingBox, annotation.coordinate) {
          //  return false
        //}
        
        if node.count < nodeCapacity {
            node.annotations[node.count++] = annotation;
            return true
        }
        
        if node.isLeaf() {
            node.subdivide()
        }
        
        if insertAnnotation(annotation, toNode:node.northEast!) {
            return true
        }
        
        if insertAnnotation(annotation, toNode:node.northWest!) {
            return true
        }
        
        if insertAnnotation(annotation, toNode:node.southEast!) {
            return true
        }
        
        if insertAnnotation(annotation, toNode:node.southWest!) {
            return true
        }
        
        
        return false
        
    }

    
}