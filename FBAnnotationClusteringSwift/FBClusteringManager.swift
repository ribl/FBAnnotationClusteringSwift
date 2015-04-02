//
//  FBClusteringManager.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation

protocol FBClusteringManagerDelegate {
    
}

class FBClusteringManager {
    
    var delegate:FBClusteringManagerDelegate? = nil
    
    var tree:FBQuadTree? = nil
    
    func setAnnotations(annotations:[FBAnnotation]){
        tree = nil
        addAnnotations(annotations)
    }
    
    func addAnnotations(annotations:[FBAnnotation]){
        if tree == nil {
            tree = FBQuadTree()
        }
        for annotation in annotations {
            tree.insertAnnotation(annotation)
        }
    }
    
    
}