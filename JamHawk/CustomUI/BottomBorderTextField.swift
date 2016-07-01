//
//  BottomBorderTextField.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class BottomBorderTextField: UITextField
{
	var bottomBorderColor = UIColor(white: 1, alpha: 0.5) {
		didSet {
			_bottomBorder.backgroundColor = bottomBorderColor
		}
	}
	
	var bottomBorderHeight: CGFloat = 1.0 {
		didSet {
			_borderHeight = bottomBorderHeight
			setNeedsLayout()
		}
	}
	
	private var _borderHeight: CGFloat = 1.0
	private let _bottomBorder = UIView()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_commonInit()
	}
	
	private func _commonInit()
	{
		_bottomBorder.backgroundColor = bottomBorderColor
		addSubview(_bottomBorder)
	}
	
	override func layoutSubviews()
	{
		super.layoutSubviews()
		_updateBorderFrame()
	}
	
	// MARK: - Private
	private func _updateBorderFrame()
	{
		let borderOrigin = CGPoint(x: 0, y: bounds.height - _borderHeight)
		let borderSize = CGSize(width: bounds.width, height: _borderHeight)
		
		_bottomBorder.frame.origin = borderOrigin
		_bottomBorder.frame.size = borderSize
	}
}