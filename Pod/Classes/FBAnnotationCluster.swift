//
//  FBAnnotationCluster.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

open class FBAnnotationCluster: NSObject {
    
    open var coordinate = CLLocationCoordinate2D(latitude: 39.208407, longitude: -76.799555)
    
    open var title: String? = "cluster"
    open var subtitle: String? = nil
    
    open var annotations: [MKAnnotation] = []
    
}

extension FBAnnotationCluster : MKAnnotation {
    
}
