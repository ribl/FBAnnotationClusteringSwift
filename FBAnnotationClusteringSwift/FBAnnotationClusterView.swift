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
    
    enum Size {
        case Small
        case Medium
        case Large
    }
    
    var countLabel:UILabel? = nil
    
    var size:Size = .Small
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let cluster:FBAnnotationCluster = annotation as FBAnnotationCluster
        count = cluster.annotations.count
        
        switch count {
        case 0...5:
            size = .Small
        case 6...15:
            size = .Medium
        default:
            size = .Large
        }
        
        backgroundColor = UIColor.clearColor()
        setupLabel()
        setCount(count)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel(){
        countLabel = UILabel(frame: bounds)
        
        var fontSize:CGFloat = 12
        
        switch size {
        case .Small:
            fontSize = 12
        case .Medium:
            fontSize = 13
        default:
            fontSize = 14
        }
        
        if let countLabel = countLabel {
            countLabel.autoresizingMask = .FlexibleWidth | .FlexibleHeight
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
    
    func setCount(localCount:Int){
        count = localCount;
        
        countLabel?.text = "\(localCount)"
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        
        var imageName = "cluster"
        
        switch size {
        case .Small:
            imageName += "Small"
        case .Medium:
            imageName += "Medium"
        default:
            imageName += "Large"
        }
        
        // Images are faster than using drawRect:
        var imageAsset = UIImage(named: imageName)!
        
        countLabel?.frame = self.bounds
        image = imageAsset
        centerOffset = CGPointZero
        
    }
    
}