//
//  FBClusteringManager.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

public protocol FBClusteringManagerDelegate {
    func cellSizeFactorForCoordinator(_ coordinator: FBClusteringManager) -> CGFloat
}

public class FBClusteringManager: NSObject {
    
    public var delegate: FBClusteringManagerDelegate? = nil
    
    var tree: FBQuadTree? = nil
    
    var lock: NSRecursiveLock = NSRecursiveLock()
    
    public var maxZoomLevel = 19
    
    public override init() {
        super.init()
    }
    
    public init(annotations: [MKAnnotation]) {
        super.init()
        addAnnotations(annotations)
    }
    
    public func setAnnotations(_ annotations: [MKAnnotation]) {
        tree = nil
        addAnnotations(annotations)
    }
    
    public func addAnnotations(_ annotations: [MKAnnotation]) {
        if tree == nil {
            tree = FBQuadTree()
        }
        
        lock.lock()
        for annotation in annotations {
            tree!.insertAnnotation(annotation)
        }
        lock.unlock()
    }
    
    public func clusteredAnnotationsWithinMapRect(_ rect: MKMapRect, withZoomScale zoomScale: Double) -> [MKAnnotation] {
        guard !zoomScale.isInfinite else { return [] }
        
        let zoomLevel   = FBClusteringManager.FBZoomScaleToZoomLevel(MKZoomScale(zoomScale))
        let cellSize    = FBClusteringManager.FBCellSizeForZoomLevel(zoomLevel)
        
        let scaleFactor: Double = zoomScale / Double(cellSize)
        
        let minX: Int = Int(floor(MKMapRectGetMinX(rect) * scaleFactor))
        let maxX: Int = Int(floor(MKMapRectGetMaxX(rect) * scaleFactor))
        let minY: Int = Int(floor(MKMapRectGetMinY(rect) * scaleFactor))
        let maxY: Int = Int(floor(MKMapRectGetMaxY(rect) * scaleFactor))
        
        var clusteredAnnotations = [MKAnnotation]()
        
        lock.lock()
        
        for i in minX...maxX {
            
            for j in minY...maxY {
                
                let mapPoint = MKMapPoint(x: Double(i)/scaleFactor, y: Double(j)/scaleFactor)
                
                let mapSize = MKMapSize(width: 1.0/scaleFactor, height: 1.0/scaleFactor)
                
                let mapRect = MKMapRect(origin: mapPoint, size: mapSize)
                let mapBox: FBBoundingBox = FBQuadTreeNode.FBBoundingBoxForMapRect(mapRect)
                
                var totalLatitude: Double = 0
                var totalLongitude: Double = 0
                
                var annotations = [MKAnnotation]()
                
                tree?.enumerateAnnotationsInBox(mapBox) { obj in
                    totalLatitude += obj.coordinate.latitude
                    totalLongitude += obj.coordinate.longitude
                    annotations.append(obj)
                }
                
                let count = annotations.count
                
                if count == 1 || zoomLevel >= self.maxZoomLevel {
                    clusteredAnnotations += annotations
                } else if count > 1 {
                    let coordinate = CLLocationCoordinate2D(
                        latitude: CLLocationDegrees(totalLatitude)/CLLocationDegrees(count),
                        longitude: CLLocationDegrees(totalLongitude)/CLLocationDegrees(count)
                    )
                    let cluster = FBAnnotationCluster()
                    cluster.coordinate = coordinate
                    cluster.annotations = annotations
                    clusteredAnnotations.append(cluster)
                }
            }
        }
        
        
        lock.unlock()
        
        return clusteredAnnotations
    }
    
    public func allAnnotations() -> [MKAnnotation] {
        
        var annotations = [MKAnnotation]()
        
        lock.lock()
        tree?.enumerateAnnotationsUsingBlock() { obj in
            annotations.append(obj)
        }
        lock.unlock()
        
        return annotations
    }
    
    public func displayAnnotations(_ annotations: [MKAnnotation], onMapView mapView: MKMapView) {
        
        DispatchQueue.main.async {
            
            let before = NSMutableSet(array: mapView.annotations)
            before.remove(mapView.userLocation)
            let after = NSSet(array: annotations)
            let toKeep = NSMutableSet(set: before)
            toKeep.intersect(after as Set<NSObject>)
            let toAdd = NSMutableSet(set: after)
            toAdd.minus(toKeep as Set<NSObject>)
            var toRemove = NSMutableSet(set: before)
            toRemove.minus(after as Set<NSObject>)
            
            let annotationsOnlyPredicate = NSPredicate(format: "SELF isKindOfClass:%@", argumentArray: [FBAnnotationCluster.self])
            toRemove.filter(using: annotationsOnlyPredicate)
       
            if let toAddAnnotations = toAdd.allObjects as? [MKAnnotation] {
                mapView.addAnnotations(toAddAnnotations)
            }
            
            if let removeAnnotations = toRemove.allObjects as? [MKAnnotation] {
                mapView.removeAnnotations(removeAnnotations)
            }
        }
    }
    
    public class func FBZoomScaleToZoomLevel(_ scale: MKZoomScale) -> Int {
        let totalTilesAtMaxZoom: Double = MKMapSizeWorld.width / 256.0
        let zoomLevelAtMaxZoom: Int = Int(log2(totalTilesAtMaxZoom))
        let floorLog2ScaleFloat = floor(log2f(Float(scale))) + 0.5
        guard !floorLog2ScaleFloat.isInfinite else { return floorLog2ScaleFloat.sign == .plus ? 0 : 19 }
        let sum: Int = zoomLevelAtMaxZoom + Int(floorLog2ScaleFloat)
        let zoomLevel: Int = max(0, sum)
        return zoomLevel
    }
    
    public class func FBCellSizeForZoomLevel(_ zoomLevel: Int) -> CGFloat {
        
        switch zoomLevel {
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
        case 18 ..< Int.max:
            return 16
            
        default:
            // less than 13 zoom level
            return 88
        }
    }
    
    public class func FBCellSizeForZoomScale(_ zoomScale: MKZoomScale) -> CGFloat {
        
        let zoomLevel = FBClusteringManager.FBZoomScaleToZoomLevel(zoomScale)
        return FBClusteringManager.FBCellSizeForZoomLevel(zoomLevel)
    }
}
