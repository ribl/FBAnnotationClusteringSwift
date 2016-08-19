# FBAnnotationClusteringSwift

This is a Swift translation of [FBAnnotationClustering](https://github.com/infinum/FBAnnotationClustering).  Aggregates map pins into a single numbered cluster.

Map clustering is a common enough map feature in modern apps.  When I couldn't find a Swift library, I ended up translating one from Objective-C.  The library of choice was FBAnnotationClustering (FB stands for Filip Bec, not Facebook).  I wanted something that was fast (QuadTree), with a light code base in case I had to figure out and troubleshoot an edge case down the road.

![Simulator Image](https://github.com/ribl/FBAnnotationClusteringSwift/blob/master/GitHubImages/simulatorShot.png)

(left: sample project with a lot of pins in the DC area.  right: ribl screenshot using clusters)

## Installation

####CocoaPods
```
pod 'FBAnnotationClusteringSwift'
```
and in class where do you need add this

```
import FBAnnotationClusteringSwift
```



####Manually

Copy the following Swift files to your project:

* FBClusteringManager.swift
* FBAnnotationCluster.swift
* FBAnnotationClusterView.swift
* FBAnnotation.swift
* FBQuadTree.swift
* FBQuadTreeNode.swift
* FBBoundingBox.swift

## Usage

Use FBViewController.swift as a guide.  For demonstration purposes, it drops 1000 random pins near Ghana.  

Follow instructions below for a barely-working implementation.

### Step 1:  Get a handle to the clustering manager

```
let clusteringManager = FBClusteringManager()
```

### Step 2:  Feed pins into the clustering manager

```
var array:[FBAnnotation] = []

// drop two arbitrary pins somewhere near Louisville, Kentucky
let pinOne = FBAnnotation()
pinOne.coordinate = CLLocationCoordinate2D(latitude: 38.188805, longitude: -85.6767705)

let pinTwo = FBAnnotation()
pinTwo.coordinate = CLLocationCoordinate2D(latitude: 38.188806, longitude: -85.6767707)

array.append(pinOne)
array.append(pinTwo)

clusteringManager.addAnnotations(array)
```

### Step 3:  Wire up your map

Add this to the top of your ViewController:

```
import MapKit
```

Add a MapKit View in the Storyboard, and set the delegate.  

### Step 4:  Return either a cluster or a pin in the MKMapViewDelegate

Drop in these MKMapViewDelegate methods:

```
extension ViewController: MKMapViewDelegate {

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
            pinView!.pinColor = .Green
            return pinView
        }
    }
    
}
```

For image's cluster
You can use those provided by me, or you can pass the name of the image you have in your project. Remember you will need 3 different images depending on the cluster size

## Run Example
If you want run example, before to open Xcode the first time,  open Terminal in Example folder and run the command:

```
pod  install
``` 

After than open the .xworkspace file generated.