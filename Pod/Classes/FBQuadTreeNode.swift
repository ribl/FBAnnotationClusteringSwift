//
//  FBQuadTreeNode.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

open class FBQuadTreeNode {

	static let NodeCapacity = 8
    
    let boundingBox: FBBoundingBox
	private(set) var annotations: [MKAnnotation] = []

    private(set) var northEast: FBQuadTreeNode?
    private(set) var northWest: FBQuadTreeNode?
    private(set) var southEast: FBQuadTreeNode?
    private(set) var southWest: FBQuadTreeNode?
    
    // MARK: - Initializers

    init(boundingBox box: FBBoundingBox) {
		boundingBox = box
    }
    
    // MARK: - Instance functions

	func canAppendAnnotation() -> Bool {
		return annotations.count < FBQuadTreeNode.NodeCapacity
	}

	func append(annotation: MKAnnotation) -> Bool {
		if canAppendAnnotation() {
			annotations.append(annotation)
			return true
		}
		return false
	}
    
    func isLeaf() -> Bool {
        return (northEast == nil) ? true : false
    }

	func siblings() -> (northEast: FBQuadTreeNode, northWest: FBQuadTreeNode, southEast: FBQuadTreeNode, southWest: FBQuadTreeNode)? {
		if let northEast = northEast,
		let northWest = northWest,
		let southEast = southEast,
		let southWest = southWest {
			return (northEast, northWest, southEast, southWest)
		} else {
			return nil
		}
	}
    
    func createSiblings() -> (northEast: FBQuadTreeNode, northWest: FBQuadTreeNode, southEast: FBQuadTreeNode, southWest: FBQuadTreeNode) {
		let box = boundingBox
		northEast = FBQuadTreeNode(boundingBox: FBBoundingBox(x0: box.xMid, y0: box.y0, xf: box.xf, yf: box.yMid))
        northWest = FBQuadTreeNode(boundingBox: FBBoundingBox(x0: box.x0, y0: box.y0, xf: box.xMid, yf: box.yMid))
        southEast = FBQuadTreeNode(boundingBox: FBBoundingBox(x0: box.xMid, y0: box.yMid, xf: box.xf, yf: box.yf))
        southWest = FBQuadTreeNode(boundingBox: FBBoundingBox(x0: box.x0, y0: box.yMid, xf: box.xMid, yf: box.yf))

		return (northEast!, northWest!, southEast!, southWest!)
    }
    
}
