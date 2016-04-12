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


 /// Try to put annotations fit in current map rect.  Map should zoom out to span annotations


class FBViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let numberOfLocations = 1000
    
    let clusteringManager = FBClusteringManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let array:[MKAnnotation] = randomLocationsWithCount(numberOfLocations)
        
        clusteringManager.addAnnotations(array)
        clusteringManager.delegate = self;

        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Utility
    
    func randomLocationsWithCount(count:Int) -> [FBAnnotation] {
        var array:[FBAnnotation] = []
        for _ in 0...count {
            let a:FBAnnotation = FBAnnotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 2, longitude: drand48() * 80 - 4 )
            array.append(a)
        }
        return array
    }

}

extension FBViewController : FBClusteringManagerDelegate {
 
    func cellSizeFactorForCoordinator(coordinator:FBClusteringManager) -> CGFloat{
        return 1.0
    }
    
}


extension FBViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
    
        

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        
        if annotation.isKindOfClass(FBAnnotationCluster) {
            
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)

            return clusterView
            
        } else {
        
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            
            pinView!.pinTintColor = UIColor.greenColor()
            
            return pinView
        }
        
    }
    
}
