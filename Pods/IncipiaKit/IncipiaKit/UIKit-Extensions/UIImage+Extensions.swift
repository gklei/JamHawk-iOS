//
//  UIImage+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Accelerate

public extension UIImage
{
	// MARK: - Utilities
	class public func convertGradientToImage(colors: [UIColor], frame: CGRect) -> UIImage {
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
		return gradientImage!
	}
	
	class public func imageWithColor(color: UIColor) -> UIImage {
		return imageWithColor(color, size: CGSize(width: 1, height: 1))
	}
	
	class public func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
		let rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		
		color.setFill()
		UIRectFill(rect)
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return image
	}
	
	public func correctlyOrientedImage() -> UIImage {
		guard imageOrientation != UIImageOrientation.Up else { return self }
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
		let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
		UIGraphicsEndImageContext();
		
		return normalizedImage;
	}
	
	// MARK: - Effects
	public func applyLightEffect() -> UIImage? {
		return applyBlur(withRadius: 30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
	}
	
	public func applyExtraLightEffect() -> UIImage? {
		return applyBlur(withRadius: 20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
	}
	
	public func applyDarkEffect() -> UIImage? {
		return applyBlur(withRadius: 20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
	}
	
	public func applyTintEffectWithColor(tintColor: UIColor) -> UIImage? {
		let effectColorAlpha: CGFloat = 0.6
		var effectColor = tintColor
		
		let componentCount = CGColorGetNumberOfComponents(tintColor.CGColor)
		
		if componentCount == 2 {
			var b: CGFloat = 0
			if tintColor.getWhite(&b, alpha: nil) {
				effectColor = UIColor(white: b, alpha: effectColorAlpha)
			}
		} else {
			var red: CGFloat = 0
			var green: CGFloat = 0
			var blue: CGFloat = 0
			
			if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
				effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
			}
		}
		
		return applyBlur(withRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
	}
	
	public func applyBlur(withRadius radius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
		// Check pre-conditions.
		if (size.width < 1 || size.height < 1) {
			print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
			return nil
		}
		if self.CGImage == nil {
			print("*** error: image must be backed by a CGImage: \(self)")
			return nil
		}
		if maskImage != nil && maskImage!.CGImage == nil {
			print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
			return nil
		}
		
		let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
		let screenScale = UIScreen.mainScreen().scale
		let imageRect = CGRect(origin: CGPointZero, size: size)
		var effectImage = self
		
		let hasBlur = radius > __FLT_EPSILON__
		let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
		
		if hasBlur || hasSaturationChange {
			func createEffectBuffer(context: CGContext?) -> vImage_Buffer {
				let data = CGBitmapContextGetData(context!)
				let width = vImagePixelCount(CGBitmapContextGetWidth(context!))
				let height = vImagePixelCount(CGBitmapContextGetHeight(context!))
				let rowBytes = CGBitmapContextGetBytesPerRow(context!)
				
				return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
			}
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectInContext = UIGraphicsGetCurrentContext()
			
			CGContextScaleCTM(effectInContext!, 1.0, -1.0)
			CGContextTranslateCTM(effectInContext!, 0, -size.height)
			CGContextDrawImage(effectInContext!, imageRect, self.CGImage!)
			
			var effectInBuffer = createEffectBuffer(effectInContext)
			
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectOutContext = UIGraphicsGetCurrentContext()
			
			var effectOutBuffer = createEffectBuffer(effectOutContext)
			
			
			if hasBlur {
				// A description of how to compute the box kernel width from the Gaussian
				// radius (aka standard deviation) appears in the SVG spec:
				// http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
				//
				// For larger values of 's' (s >= 2.0), an approximation can be used: Three
				// successive box-blurs build a piece-wise quadratic convolution kernel, which
				// approximates the Gaussian kernel to within roughly 3%.
				//
				// let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
				//
				// ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
				//
				
				let inputRadius = radius * screenScale
				var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
				if radius % 2 != 1 {
					radius += 1 // force radius to be odd so that the three box-blur methodology works.
				}
				
				let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
				
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
			}
			
			var effectImageBuffersAreSwapped = false
			
			if hasSaturationChange {
				let s: CGFloat = saturationDeltaFactor
				let floatingPointSaturationMatrix: [CGFloat] = [
					0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
					0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
					0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
					0,                    0,                    0,  1
				]
				
				let divisor: CGFloat = 256
				let matrixSize = floatingPointSaturationMatrix.count
				var saturationMatrix = [Int16](count: matrixSize, repeatedValue: 0)
				
				for i: Int in 0 ..< matrixSize {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
				}
				
				if hasBlur {
					vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
					effectImageBuffersAreSwapped = true
				} else {
					vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
				}
			}
			
			if !effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()!
			}
			
			UIGraphicsEndImageContext()
			
			if effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()!
			}
			
			UIGraphicsEndImageContext()
		}
		
		// Set up output context.
		UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
		let outputContext = UIGraphicsGetCurrentContext()
		CGContextScaleCTM(outputContext!, 1.0, -1.0)
		CGContextTranslateCTM(outputContext!, 0, -size.height)
		
		// Draw base image.
		CGContextDrawImage(outputContext!, imageRect, self.CGImage!)
		
		// Draw effect image.
		if hasBlur {
			CGContextSaveGState(outputContext!)
			if let image = maskImage {
				CGContextClipToMask(outputContext!, imageRect, image.CGImage!);
			}
			CGContextDrawImage(outputContext!, imageRect, effectImage.CGImage!)
			CGContextRestoreGState(outputContext!)
		}
		
		// Add in color tint.
		if let color = tintColor {
			CGContextSaveGState(outputContext!)
			CGContextSetFillColorWithColor(outputContext!, color.CGColor)
			CGContextFillRect(outputContext!, imageRect)
			CGContextRestoreGState(outputContext!)
		}
		
		// Output image is ready.
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return outputImage
	}
}
