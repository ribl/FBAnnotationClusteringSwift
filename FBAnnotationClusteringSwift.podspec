#
# Be sure to run `pod lib lint FBAnnotationClusteringSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FBAnnotationClusteringSwift"
  s.version          = "2.0"
  s.summary          = "This is a Swift translation of FBAnnotationClustering. Aggregates map pins into a single numbered cluster."

  s.description      = <<-DESC
Swift translation of FB Annotation Clustering, which clusters pins on the map for iOS. http://ribl.co/blog/2015/05/28/map-clustering-with-swift-how-we-implemented-it-into-the-ribl-ios-app/
                       DESC

  s.homepage         = "https://github.com/freemiumdev/FBAnnotationClusteringSwift"
  s.license          = 'MIT'
  s.author           = { "Giuseppe Russo" => "freemiumdev@outlook.it" }
  s.source           = { :git => "https://github.com/freemiumdev/FBAnnotationClusteringSwift.git", :tag => s.version}

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.swift_version = '4.2'

  s.source_files = 'Pod/Classes/**/*'
	s.framework = 'MapKit'
  s.ios.framework = 'UIKit'
end
