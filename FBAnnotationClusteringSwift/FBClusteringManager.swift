//
//  FBClusteringManager.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

protocol FBClusteringManagerDelegate {
    
}

class FBClusteringManager {
    
    var delegate:FBClusteringManagerDelegate? = nil
    
    var tree:FBQuadTree? = nil
    
    func setAnnotations(annotations:[MKAnnotation]){
        tree = nil
        addAnnotations(annotations)
    }
    
    func addAnnotations(annotations:[MKAnnotation]){
        if tree == nil {
            tree = FBQuadTree()
        }
        for annotation in annotations {
            tree!.insertAnnotation(annotation)
        }
    }
    
    class func FBZoomScaleToZoomLevel(scale:MKZoomScale) -> Int{
        let totalTilesAtMaxZoom:Double = MKMapSizeWorld.width / 256.0

        let zoomLevelAtMaxZoom:Int = Int(log2(totalTilesAtMaxZoom))
        
        let floorLog2ScaleFloat = floor(log2f(Float(scale))) + 0.5
        
        let zoomLevel:Int = zoomLevelAtMaxZoom + Int(floorLog2ScaleFloat)
        
        return zoomLevel;

    }
    
}