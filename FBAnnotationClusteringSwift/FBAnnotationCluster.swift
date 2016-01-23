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
    
    override func isEqual(object: AnyObject?) -> Bool {
        guard let otherCluster = object as? FBAnnotationCluster else { return false }
        if otherCluster == self {
            return true
        }
        return false
    }

}

func ==(lhs: FBAnnotationCluster, rhs: FBAnnotationCluster) -> Bool {
    // If the coordinate "hash" and the annotation counts are the same, 
    // it's probably the same cluster. 
    let sameHash = (lhs.hashValue == rhs.hashValue)
    let sameAnnotationCount = (lhs.annotations.count == rhs.annotations.count)
    return (sameHash && sameAnnotationCount)
}

extension FBAnnotationCluster {
    override var hashValue: Int {
        get {
            // Combines longitude and latitude into a semi-unique Integer hash value.
            // Attempts this by adding the two, and capturing at least 6 significant digits.
            let latitude = coordinate.latitude // -13.2998248494599
            let longitude = coordinate.longitude // 38.1007627783306
            let combined = latitude + longitude // 24.8009379288707
            let extendSignificantDigits = combined * 1_000_000 // 24800937.9288707
            let intHash = Int(extendSignificantDigits) // 24800937
            return intHash
        }
    }
}