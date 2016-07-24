//
//  UserProfileButtonView.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class UserProfileButtonView: UIButton {
	private let _imageView = UIImageView(image: UIImage(named: "headphones"))
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_setupImageView()
		backgroundColor = .clearColor()
	}
	
	convenience init(target: AnyObject?, selector: Selector) {
		self.init(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
		
		let button = UIButton()
		button.addTarget(target, action: selector, forControlEvents: .TouchDown)
		
		addAndFill(subview: button)
	}
	
	private func _setupImageView() {
		addSubview(_imageView)
		_imageView.translatesAutoresizingMaskIntoConstraints = false
		_imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
		_imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
		_imageView.tintColor = .jmhTurquoiseColor()
	}
	
	override func drawRect(rect: CGRect) {
		UIColor.whiteColor().setFill()
		let context = UIGraphicsGetCurrentContext()
		
		UIColor.whiteColor().setStroke()
		CGContextSetLineWidth(context, 2)
		CGContextStrokeEllipseInRect(context, rect.insetBy(dx: 1, dy: 1))
	}
}