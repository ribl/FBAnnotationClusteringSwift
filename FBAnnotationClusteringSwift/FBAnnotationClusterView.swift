//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBAnnotationClusterView : MKAnnotationView {
    
    var count = 0
    
    var fontSize:CGFloat = 12
    
    var imageName = "clusterSmall"
    
    var borderWidth:CGFloat = 3
    
    var countLabel:UILabel? = nil
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let cluster:FBAnnotationCluster = annotation as! FBAnnotationCluster
        count = cluster.annotations.count
        
        // change the size of the cluster image based on number of stories
        switch count {
        case 0...5:
            fontSize = 12
            imageName = "clusterSmall"
            borderWidth = 3
            
        case 6...15:
            fontSize = 13
            imageName = "clusterMedium"
            borderWidth = 4
            
        default:
            fontSize = 14
            imageName = "clusterLarge"
            borderWidth = 5
            
        }
        
        backgroundColor = UIColor.clearColor()
        setupLabel()
        setTheCount(count)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    override func layoutSubviews() {
        
        // Images are faster than using drawRect:
        let imageAsset = UIImage(named: imageName)!
        
        countLabel?.frame = self.bounds
        image = imageAsset
        centerOffset = CGPointZero
        
        // adds a white border around the green circle
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = self.bounds.size.width / 2
        
    }
    
}