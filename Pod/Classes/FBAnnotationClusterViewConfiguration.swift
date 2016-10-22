//
//  FBAnnotationClusterViewConfiguration.swift
//  FBAnnotationClusteringSwift
//
//  Created by Antoine Lamy on 23/9/2016.
//  Copyright (c) 2016 Antoine Lamy. All rights reserved.
//

import Foundation

public struct FBAnnotationClusterViewConfiguration {

	let templates: [FBAnnotationClusterTemplate]
	let defaultTemplate: FBAnnotationClusterTemplate

	public init (templates: [FBAnnotationClusterTemplate], defaultTemplate: FBAnnotationClusterTemplate) {
		self.templates = templates
		self.defaultTemplate = defaultTemplate
	}

	public static func `default`() -> FBAnnotationClusterViewConfiguration {
		var smallTemplate = FBAnnotationClusterTemplate(range: Range(uncheckedBounds: (lower: 0, upper: 6)), sideLength: 30)
		smallTemplate.borderWidth = 3
		smallTemplate.fontSize = 13

		var mediumTemplate = FBAnnotationClusterTemplate(range: Range(uncheckedBounds: (lower: 6, upper: 15)), sideLength: 40)
		mediumTemplate.borderWidth = 4
		mediumTemplate.fontSize = 14

		var largeTemplate = FBAnnotationClusterTemplate(range: nil, sideLength: 50)
		largeTemplate.borderWidth = 5
		largeTemplate.fontSize = 15

		return FBAnnotationClusterViewConfiguration(templates: [smallTemplate, mediumTemplate], defaultTemplate: largeTemplate)
	}

	public func templateForCount(count: Int) -> FBAnnotationClusterTemplate {
		for template in templates {
			if template.range?.contains(count) ?? false {
				return template
			}
		}
		return self.defaultTemplate
	}
}
