//
//  FBAnnotationCluster.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBAnnotationCluster : NSObject {
    
    var coordinate = CLLocationCoordinate2D(latitude: 39.208407, longitude: -76.799555)
    
    var title:String? = "cluster"
    var subtitle:String? = nil
    
    var annotations:[MKAnnotation] = []
    
}

extension FBAnnotationCluster : MKAnnotation {
    
    
    
}