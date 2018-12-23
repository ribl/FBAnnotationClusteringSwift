//
//  ViewController.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClusteringSwift

class FBViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    let numberOfLocations = 1000
    
    let clusteringManager = FBClusteringManager()
	let configuration = FBAnnotationClusterViewConfiguration.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clusteringManager.add(annotations: randomLocationsWithCount(numberOfLocations))
        clusteringManager.delegate = self;

        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
    }

    // MARK: - Utility
    
    func randomLocationsWithCount(_ count:Int) -> [FBAnnotation] {
        var array:[FBAnnotation] = []
        for _ in 0...count - 1 {
            let a:FBAnnotation = FBAnnotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 20, longitude: drand48() * 80 - 40 )
            array.append(a)
        }
        return array
    }

}

extension FBViewController : FBClusteringManagerDelegate {
 
    func cellSizeFactor(forCoordinator coordinator:FBClusteringManager) -> CGFloat {
        return 1.0
    }
}


extension FBViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapBoundsWidth = Double(self.mapView.bounds.size.width)
        let mapVisibleRect = self.mapView.visibleMapRect
        let scale = mapBoundsWidth / mapVisibleRect.size.width
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            let annotationArray = strongSelf.clusteringManager.clusteredAnnotations(withinMapRect: mapVisibleRect, zoomScale:scale)
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.clusteringManager.display(annotations: annotationArray, onMapView:strongSelf.mapView)
            }
		}
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        if annotation is FBAnnotationCluster {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
			if clusterView == nil {
				clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, configuration: self.configuration)
			} else {
				clusterView?.annotation = annotation
			}

            return clusterView
        } else {
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
				pinView?.pinTintColor = UIColor.green
			} else {
				pinView?.annotation = annotation
			}
            
            return pinView
        }
    }
}
