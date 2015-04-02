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
    
    class func FBCellSizeForZoomScale(zoomScale:MKZoomScale) -> CGFloat {
        
        let zoomLevel:Int = FBClusteringManager.FBZoomScaleToZoomLevel(zoomScale)
        
        switch (zoomLevel) {
        case 13:
            return 64
        case 14:
            return 64
        case 15:
            return 64
        case 16:
            return 32
        case 17:
            return 32
        case 18:
            return 32
        case 19:
            return 16
            
        default:
            return 88
        }
        
    }
    
}