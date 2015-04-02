//
//  ViewController.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit

class FBViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let numberOfLocations = 1000
    
    let clusteringManager = FBClusteringManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var array:[MKAnnotation] = randomLocationsWithCount(numberOfLocations)
        
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
        for i in 0...count {
            let a:FBAnnotation = FBAnnotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 20, longitude: drand48() * 80 - 40 )
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
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool){
        
        NSOperationQueue().addOperationWithBlock({
        
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            
            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
            
            let scale:Double = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mapView)

        })

    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "AnnotationViewReuseID"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        // This is how you can check if annotation is a cluster
        if annotation.isKindOfClass(FBAnnotationCluster) {
            let cluster = annotation as FBAnnotationCluster
            cluster.title = "\(cluster.annotations.count)"

            annotationView!.image = UIImage(named: "cluster")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.pinColor = .Green
            annotationView!.canShowCallout = false
        }
        
        return annotationView;
        
    }
    
}
