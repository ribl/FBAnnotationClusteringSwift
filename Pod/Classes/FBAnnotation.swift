//
//  FBAnnotation.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

open class FBAnnotation: NSObject {
    
    open var coordinate = CLLocationCoordinate2D()
    open var title: String?
}

extension FBAnnotation : MKAnnotation { }
