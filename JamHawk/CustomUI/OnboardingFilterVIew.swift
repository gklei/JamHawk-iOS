//
//  OnboardingFilterVIew.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum OnboardingFilterType: String {
	case Discoveries
	case Mainstream
	case Rising
	case Blues
	case HipHop = "Hip Hop"
	case AlternativeRock = "Alternative Rock"
	case RnB = "R&B"
	case Pop
	case Rock
}

extension OnboardingFilterType {
	var category: PlayerAPIFilterCategory {
		switch self {
		case .Discoveries, .Mainstream, .Rising: return "region"
		case .HipHop, .Pop, .Rock: return "genre"
		default: return "sub_genre"
		}
	}
	
	var filterID: PlayerAPIFilterID {
		switch self {
		case .Discoveries: return "9"
		case .Mainstream: return "3"
		case .Rising: return "2"
		case .Blues: return "15"
		case .HipHop: return "1"
		case .AlternativeRock: return "18"
		case .RnB: return "19"
		case .Pop: return "8"
		case .Rock: return "5"
		}
	}
}

protocol OnboardingFilterViewDelegate: class {
	func filterViewSelected(view: OnboardingFilterView)
	func filterViewDeselected(view: OnboardingFilterView)
}

class OnboardingFilterView: UIButton {
	
	var type: OnboardingFilterType = .Discoveries {
		didSet {
			_label.text = type.rawValue
		}
	}
	
	private var _bgColor = UIColor(white: 0, alpha: 0.5)
	private let _label = UILabel()
	
	weak var delegate: OnboardingFilterViewDelegate?
	
	override var highlighted: Bool {
		didSet {
			var alpha: CGFloat = highlighted ? 0.3 : 0.5
			if selected {
				alpha = highlighted ? 0.8 : 1
			}
			_bgColor = _bgColor.colorWithAlphaComponent(alpha)
			_label.alpha = highlighted ? 0.5	: 1
			
			setNeedsDisplay()
		}
	}
	
	override var selected: Bool {
		didSet {
			_bgColor = selected ? UIColor.jmhTurquoiseColor() : UIColor(white: 0, alpha: 0.5)
			setNeedsDisplay()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let size = adjustedFontSizeForCurrentDevice(15)
		_label.font = UIFont(name: "OpenSans", size: size)
		_label.textColor = UIColor.whiteColor()
		_label.textAlignment = .Center
		_label.numberOfLines = 2
		
		addSubview(_label)
		
		let scaleUpEvents: UIControlEvents = [.TouchDown, .TouchDragEnter]
		let scaleDownEvents: UIControlEvents = [.TouchDragExit, .TouchUpInside]
		
		addTarget(self, action: #selector(scaleUp), forControlEvents: scaleUpEvents)
		addTarget(self, action: #selector(scaleDown), forControlEvents: scaleDownEvents)
		addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
		
		selected = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		_label.frame = bounds.insetBy(dx: 16, dy: 0)
	}
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		
		_bgColor.setFill()
		CGContextFillEllipseInRect(contextRef, rect)
	}
	
	func scaleUp() {
		UIView.animateWithDuration(0.2, animations: {
			self.transform = CGAffineTransformMakeScale(1.15, 1.15)
		})
	}
	
	func scaleDown() {
		UIView.animateWithDuration(0.2, animations: {
			self.transform = CGAffineTransformIdentity
		})
	}
	
	func buttonAction() {
		selected = !selected
		if selected {
			delegate?.filterViewSelected(self)
		} else {
			delegate?.filterViewDeselected(self)
		}
	}
}
