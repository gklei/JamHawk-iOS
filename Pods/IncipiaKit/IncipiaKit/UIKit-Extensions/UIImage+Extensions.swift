//
//  UIImage+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UIImage
{
	class public func convertGradientToImage(colors: [UIColor], frame: CGRect) -> UIImage
	{
		// start with a CAGradientLayer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = frame
		
		// add colors as CGCologRef to a new array and calculate the distances
		var colorsRef : [CGColorRef] = []
		var locations : [NSNumber] = []
		
		for i in 0 ... colors.count-1 {
			colorsRef.append(colors[i].CGColor as CGColorRef)
			locations.append(Float(i)/Float(colors.count))
		}
		
		gradientLayer.colors = colorsRef
		gradientLayer.locations = locations
		
		// now build a UIImage from the gradient
		UIGraphicsBeginImageContext(gradientLayer.bounds.size)
		gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
		let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		// return the gradient image
		return gradientImage
	}
	
	class public func imageWithColor(color: UIColor) -> UIImage
	{
		return imageWithColor(color, size: CGSize(width: 1, height: 1))
	}
	
	class public func imageWithColor(color: UIColor, size: CGSize) -> UIImage
	{
		let rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		
		color.setFill()
		UIRectFill(rect)
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
	public func correctlyOrientedImage() -> UIImage
	{
		guard imageOrientation != UIImageOrientation.Up else { return self }
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
		let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return normalizedImage;
	}
}
