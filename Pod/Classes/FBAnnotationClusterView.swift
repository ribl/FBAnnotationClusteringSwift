//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

public class FBAnnotationClusterView : MKAnnotationView {
    
    var count = 0
    
    var fontSize:CGFloat = 12
    
    var imageName = "clusterSmall"
    var loadExternalImage : Bool = false
    
    var borderWidth:CGFloat = 3
    
    var countLabel:UILabel? = nil
    
    //var option : FBAnnotationClusterViewOptions? = nil
    
    public init(annotation: MKAnnotation?, reuseIdentifier: String?, options: FBAnnotationClusterViewOptions?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let cluster:FBAnnotationCluster = annotation as! FBAnnotationCluster
        count = cluster.annotations.count
        
        // change the size of the cluster image based on number of stories
        switch count {
        case 0...5:
            fontSize = 12
            if (options != nil) {
                loadExternalImage=true;
                imageName = (options?.smallClusterImage)!
            }
            else {
                imageName = "clusterSmall"
            }
            borderWidth = 3
            
        case 6...15:
            fontSize = 13
            if (options != nil) {
                loadExternalImage=true;
                imageName = (options?.mediumClusterImage)!
            }
            else {
                imageName = "clusterMedium"
            }
            borderWidth = 4
            
        default:
            fontSize = 14
            if (options != nil) {
                loadExternalImage=true;
                imageName = (options?.largeClusterImage)!
            }
            else {
                imageName = "clusterLarge"
            }
            borderWidth = 5
            
        }
        
        backgroundColor = UIColor.clearColor()
        setupLabel()
        setTheCount(count)
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel(){
        countLabel = UILabel(frame: bounds)
        
        if let countLabel = countLabel {
            countLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            countLabel.textAlignment = .Center
            countLabel.backgroundColor = UIColor.clearColor()
            countLabel.textColor = UIColor.whiteColor()
            countLabel.adjustsFontSizeToFitWidth = true
            countLabel.minimumScaleFactor = 2
            countLabel.numberOfLines = 1
            countLabel.font = UIFont.boldSystemFontOfSize(fontSize)
            countLabel.baselineAdjustment = .AlignCenters
            addSubview(countLabel)
        }
        
    }
    
    func setTheCount(localCount:Int){
        count = localCount;
        
        countLabel?.text = "\(localCount)"
        setNeedsLayout()
    }
    
    override public func layoutSubviews() {
        
        // Images are faster than using drawRect:
        
        let imageAsset = UIImage(named: imageName, inBundle: (!loadExternalImage) ? NSBundle(forClass: FBAnnotationClusterView.self) : nil, compatibleWithTraitCollection: nil)
        
        //UIImage(named: imageName)!
        
        countLabel?.frame = self.bounds
        image = imageAsset
        centerOffset = CGPointZero
        
        // adds a white border around the green circle
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = self.bounds.size.width / 2
        
    }
    
}

public class FBAnnotationClusterViewOptions : NSObject {
    var smallClusterImage : String
    var mediumClusterImage : String
    var largeClusterImage : String
    
   
    public init (smallClusterImage : String, mediumClusterImage : String, largeClusterImage : String) {
        self.smallClusterImage = smallClusterImage;
        self.mediumClusterImage = mediumClusterImage;
        self.largeClusterImage = largeClusterImage;
    }
    
}