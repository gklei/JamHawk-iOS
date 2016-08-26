//
//  WhiteRoundedJamhawkButton.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class WhiteRoundedJamhawkButton: UIButton {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_commonInit()
	}
	
	private func _commonInit() {
		layer.cornerRadius = 2.0
		layer.borderWidth = 2.0
		layer.borderColor = UIColor.whiteColor().CGColor
	}
	
	func update(title title: String) {
		let attrs: [String : AnyObject] = [
			NSFontAttributeName : UIFont(name: "OpenSans-Semibold", size: 14)!,
			NSForegroundColorAttributeName : UIColor.whiteColor()
		]
		
		let highlightedAttrs: [String : AnyObject] = [
			NSFontAttributeName : UIFont(name: "OpenSans-Semibold", size: 14)!,
			NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)
		]
		
		let normalAttrTitle = NSAttributedString(string: title, attributes: attrs)
		let highlightedAttrTitle = NSAttributedString(string: title, attributes: highlightedAttrs)
		
		setAttributedTitle(normalAttrTitle, forState: .Normal)
		setAttributedTitle(highlightedAttrTitle, forState: .Highlighted)
		setBackgroundImage(UIImage.imageWithColor(UIColor(white: 1, alpha: 0.2)), forState: .Highlighted)
	}
}
