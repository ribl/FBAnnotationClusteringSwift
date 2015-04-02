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
    
    var countLabel:UILabel? = nil
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        setupLabel()
        setCount(100)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel(){
        countLabel = UILabel(frame: bounds)
        
        if let countLabel = countLabel {
            countLabel.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            countLabel.textAlignment = .Center
            countLabel.backgroundColor = UIColor.clearColor()
            countLabel.textColor = UIColor.whiteColor()
            countLabel.adjustsFontSizeToFitWidth = true
            countLabel.minimumScaleFactor = 2
            countLabel.numberOfLines = 1
            countLabel.font = UIFont.boldSystemFontOfSize(13)
            countLabel.baselineAdjustment = .AlignCenters
            addSubview(countLabel)
        }
        
    }
    
    func setCount(localCount:Int){
        count = localCount;
        
        countLabel?.text = "\(localCount)"
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        
        // Images are faster than using drawRect:
        var imageAsset = UIImage(named: "clusterMedium")!
        
        countLabel?.frame = self.bounds
        image = imageAsset
        centerOffset = CGPointZero
        
    }
    
}