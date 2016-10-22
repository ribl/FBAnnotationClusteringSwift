//
//  FBClusteringManager.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

public protocol FBClusteringManagerDelegate: NSObjectProtocol {
    func cellSizeFactor(forCoordinator coordinator: FBClusteringManager) -> CGFloat
}

public class FBClusteringManager {

    public weak var delegate: FBClusteringManagerDelegate? = nil

	private var backingTree: FBQuadTree?
	private var tree: FBQuadTree? {
		set {
			backingTree = newValue
		}
		get {
			if backingTree == nil {
				backingTree = FBQuadTree()
			}
			return backingTree
		}
	}
    private let lock = NSRecursiveLock()

	public init() { }

    public init(annotations: [MKAnnotation]) {
        add(annotations: annotations)
    }

	public func add(annotations:[MKAnnotation]){
        lock.lock()
        for annotation in annotations {
			tree?.insert(annotation: annotation)
        }
        lock.unlock()
    }

	public func removeAll() {
		tree = nil
	}

	public func replace(annotations:[MKAnnotation]){
		removeAll()
		add(annotations: annotations)
	}

	public func allAnnotations() -> [MKAnnotation] {
		var annotations = [MKAnnotation]()
		lock.lock()
		tree?.enumerateAnnotationsUsingBlock(){ obj in
			annotations.append(obj)
		}
		lock.unlock()
		return annotations
	}

    public func clusteredAnnotations(withinMapRect rect:MKMapRect, zoomScale: Double) -> [MKAnnotation] {
        guard !zoomScale.isInfinite else { return [] }
        
        var cellSize = ZoomLevel(MKZoomScale(zoomScale)).cellSize()
        if let delegate = delegate, delegate.responds(to: Selector("cellSizeFactorForCoordinator:")) {
			cellSize *= delegate.cellSizeFactor(forCoordinator: self)
        }

        let scaleFactor = zoomScale / Double(cellSize)
        
        let minX = Int(floor(MKMapRectGetMinX(rect) * scaleFactor))
        let maxX = Int(floor(MKMapRectGetMaxX(rect) * scaleFactor))
        let minY = Int(floor(MKMapRectGetMinY(rect) * scaleFactor))
        let maxY = Int(floor(MKMapRectGetMaxY(rect) * scaleFactor))
        
        var clusteredAnnotations = [MKAnnotation]()
        
        lock.lock()
        
        for i in minX...maxX {
            for j in minY...maxY {

                let mapPoint = MKMapPoint(x: Double(i) / scaleFactor, y: Double(j) / scaleFactor)
                let mapSize = MKMapSize(width: 1.0 / scaleFactor, height: 1.0 / scaleFactor)
                let mapRect = MKMapRect(origin: mapPoint, size: mapSize)
                let mapBox = FBBoundingBox(mapRect: mapRect)
                
                var totalLatitude: Double = 0
                var totalLongitude: Double = 0
                
                var annotations = [MKAnnotation]()
                
				tree?.enumerateAnnotations(inBox: mapBox) { obj in
                    totalLatitude += obj.coordinate.latitude
                    totalLongitude += obj.coordinate.longitude
                    annotations.append(obj)
                }

				let count = annotations.count

				switch count {
				case 0: break
				case 1:
					clusteredAnnotations += annotations
				default:
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
    
    public func display(annotations: [MKAnnotation], onMapView mapView:MKMapView){
		let before = NSMutableSet(array: mapView.annotations)
		before.remove(mapView.userLocation)

		let after = NSSet(array: annotations)

		let toKeep = NSMutableSet(set: before)
		toKeep.intersect(after as Set<NSObject>)

		let toAdd = NSMutableSet(set: after)
		toAdd.minus(toKeep as Set<NSObject>)

		let toRemove = NSMutableSet(set: before)
		toRemove.minus(after as Set<NSObject>)
		
		if let toAddAnnotations = toAdd.allObjects as? [MKAnnotation] {
			mapView.addAnnotations(toAddAnnotations)
		}
		
		if let removeAnnotations = toRemove.allObjects as? [MKAnnotation] {
			mapView.removeAnnotations(removeAnnotations)
		}
    }
}
