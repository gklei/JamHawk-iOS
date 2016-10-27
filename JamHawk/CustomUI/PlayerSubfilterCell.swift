//
//  SubfilterCell.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/18/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SubfilterCell: UICollectionViewCell {
	
	// MARK: - Outlets
	@IBOutlet private var _nameLabel: UILabel!
	
	// MARK: - Properties
	static let xibName = "SubfilterCell"
	static let reuseID = "SubfilterCell"
	
	private var _circleColor = UIColor.jmhVeryLightGrayColor()
	
	// MARK: - Overridden
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = .clearColor()
		
		let fontSize = adjustedFontSizeForCurrentDevice(12)
		_nameLabel.font = UIFont(name: "OpenSans", size: fontSize)
	}
	
	// MARK: - Public
	func update(name name: String) {
		_nameLabel.text = name
	}
}

extension SubfilterCell {
	override var selected: Bool {
		didSet {
			_nameLabel.textColor = selected ? .whiteColor() : UIColor(white: 0.45, alpha: 1)
			_circleColor = selected ? .jmhTurquoiseColor() : .jmhVeryLightGrayColor()
			setNeedsDisplay()
		}
	}
	
	override var highlighted: Bool {
		didSet {
			_nameLabel.textColor = highlighted ? .whiteColor() : UIColor(white: 0.45, alpha: 1)
			_circleColor = highlighted ? .jmhTurquoiseColor() : .jmhVeryLightGrayColor()
			setNeedsDisplay()
			
			if highlighted {
				UIView.animateWithDuration(0.18, animations: { () -> Void in
					self.transform = CGAffineTransformMakeScale(1.15, 1.15)
				})
			}
			else {
				UIView.animateWithDuration(0.2, animations: { () -> Void in
					self.transform = CGAffineTransformIdentity
				})
			}
		}
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext();
		
		_circleColor.setFill()
		
		// Fill the circle with the fill color
		CGContextFillEllipseInRect(contextRef!, rect);
	}
}
