//
//  FBQuadTree.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

public class FBQuadTree : NSObject {
    
    var rootNode:FBQuadTreeNode? = nil
    
    let nodeCapacity = 8
    
    override init (){
        super.init()
        
        rootNode = FBQuadTreeNode(boundingBox:FBQuadTreeNode.FBBoundingBoxForMapRect(MKMapRectWorld))
        
    }
    
    func insertAnnotation(annotation:MKAnnotation) -> Bool {
        return insertAnnotation(annotation, toNode:rootNode!)
    }
    
    func insertAnnotation(annotation:MKAnnotation, toNode node:FBQuadTreeNode) -> Bool {
        
        if !FBQuadTreeNode.FBBoundingBoxContainsCoordinate(node.boundingBox!, coordinate: annotation.coordinate) {
            return false
        }
        
        if node.count < nodeCapacity {
            node.annotations.append(annotation)
            node.count += 1
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
    
    func enumerateAnnotationsInBox(box:FBBoundingBox, callback: MKAnnotation -> Void){
        enumerateAnnotationsInBox(box, withNode:rootNode!, callback: callback)
    }
    
    func enumerateAnnotationsUsingBlock(callback: MKAnnotation -> Void){
        enumerateAnnotationsInBox(FBQuadTreeNode.FBBoundingBoxForMapRect(MKMapRectWorld), withNode:rootNode!, callback:callback)
    }
    
    func enumerateAnnotationsInBox(box:FBBoundingBox, withNode node:FBQuadTreeNode, callback: MKAnnotation -> Void){
        if (!FBQuadTreeNode.FBBoundingBoxIntersectsBoundingBox(node.boundingBox!, box2: box)) {
            return;
        }
        
        let tempArray = node.annotations
        
        for annotation in tempArray {
            if (FBQuadTreeNode.FBBoundingBoxContainsCoordinate(box, coordinate: annotation.coordinate)) {
                callback(annotation);
            }
        }
        
        if node.isLeaf() {
            return
        }
        
        enumerateAnnotationsInBox(box, withNode: node.northEast!, callback: callback)
        enumerateAnnotationsInBox(box, withNode: node.northWest!, callback: callback)
        enumerateAnnotationsInBox(box, withNode: node.southEast!, callback: callback)
        enumerateAnnotationsInBox(box, withNode: node.southWest!, callback: callback)
        
    }
    
}