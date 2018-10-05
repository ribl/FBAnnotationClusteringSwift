# FBAnnotationClusteringSwift

This is a Swift translation of [FBAnnotationClustering](https://github.com/infinum/FBAnnotationClustering).  Aggregates map pins into a single numbered cluster.

Map clustering is a common enough map feature in modern apps.  When I couldn't find a Swift library, I ended up translating one from Objective-C.  The library of choice was FBAnnotationClustering (FB stands for Filip Bec, not Facebook).  I wanted something that was fast (QuadTree), with a light code base in case I had to figure out and troubleshoot an edge case down the road.

![Simulator Image](https://github.com/ribl/FBAnnotationClusteringSwift/blob/master/GitHubImages/simulatorShot.png)

(left: sample project with a lot of pins in the DC area.  right: ribl screenshot using clusters)

## Installation

#### CocoaPods
```console
pod 'FBAnnotationClusteringSwift'
```
and in class where do you need add this

```console
import FBAnnotationClusteringSwift
```



#### Manually

Copy the following Swift files to your project:

* FBClusteringManager.swift
* FBAnnotation.swift
* FBAnnotationCluster.swift
* FBAnnotationClusterTemplate.swift
* FBAnnotationClusterView.swift
* FBAnnotationClusterViewConfiguration.swift
* FBAnnotation.swift
* FBQuadTree.swift
* FBQuadTreeNode.swift
* FBBoundingBox.swift
* FBBoundingBox+MapKit.swift

## Usage

Use FBViewController.swift as a guide.  For demonstration purposes, it drops 1000 random pins near Ghana.  

Follow instructions below for a barely-working implementation.

### Step 1:  Get a handle to the clustering manager

```swift
let clusteringManager = FBClusteringManager()
```

### Step 2:  Feed pins into the clustering manager

```swift
var array:[FBAnnotation] = []

// drop two arbitrary pins somewhere near Louisville, Kentucky
let pinOne = FBAnnotation()
pinOne.coordinate = CLLocationCoordinate2D(latitude: 38.188805, longitude: -85.6767705)

let pinTwo = FBAnnotation()
pinTwo.coordinate = CLLocationCoordinate2D(latitude: 38.188806, longitude: -85.6767707)

array.append(pinOne)
array.append(pinTwo)

clusteringManager.add(annotations: array)
```

### Step 3:  Wire up your map

Add this to the top of your ViewController:

```swift
import MapKit
```

Add a MapKit View in the Storyboard, and set the delegate.  

### Step 4:  Return either a cluster or a pin in the MKMapViewDelegate

Drop in these MKMapViewDelegate methods:

```swift
extension ViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		DispatchQueue.global(qos: .userInitiated).async {
			let mapBoundsWidth = Double(self.mapView.bounds.size.width)
			let mapRectWidth = self.mapView.visibleMapRect.size.width
			let scale = mapBoundsWidth / mapRectWidth
			
			let annotationArray = self.clusteringManager.clusteredAnnotations(withinMapRect: self.mapView.visibleMapRect, zoomScale:scale)
			
			DispatchQueue.main.async {
				self.clusteringManager.display(annotations: annotationArray, onMapView:self.mapView)
			}
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		var reuseId = ""
		if annotation is FBAnnotationCluster {
			reuseId = "Cluster"
			var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
			if clusterView == nil {
				clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, configuration: FBAnnotationClusterViewConfiguration.default())
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
```

## Run Example
If you want run example, before to open Xcode the first time,  open Terminal in Example folder and run the command:

```console
pod  install
``` 

After than open the .xworkspace file generated.

### Customizing cluster appearance
Cluster's range and appearance are fully customizable via the FBAnnotationClusterViewConfiguration class. Each range have his own template (FBAnnotationClusterTemplate) allowing each segment to look different. You can create as many templates you like as long the ranges don't overlap each others. Each template can be either displayed as a circle with a solid color and a stroke or as an image.

#### Custom Solid Color Template
Just take a look at FBAnnotationClusterViewConfiguration.default() function.

#### Custom Image Template
TODO

### Migration from 1.0
TODO
