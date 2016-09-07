//
//  CoachingTipsViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum CoachingTipsState {
	case Welcome, NextSong, Filters
}

protocol CoachingTipsViewControllerDelegate: class {
	func focusRect(forState state: CoachingTipsState) -> CGRect
	
	func mainTitleText(forState state: CoachingTipsState) -> String
	func subtitleText(forState state: CoachingTipsState) -> String
	func buttonTitleText(forState state: CoachingTipsState) -> String
	func icon(forState state: CoachingTipsState) -> UIImage?
	
	func nextButtonPressed(forCurrentState state: CoachingTipsState)
	func skipAllButtonPressed(forCurrentState state: CoachingTipsState)
}

class CoachingTipsViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _iconImageView: UIImageView!
	@IBOutlet private var _mainTitleLabel: UILabel!
	@IBOutlet private var _subtitleLabel: UILabel!
	@IBOutlet private var _nextButton: WhiteRoundedJamhawkButton!
	@IBOutlet private var _skipAllTipsButton: UIButton!
	@IBOutlet private var _subtitleYPositionLayoutConstraint: NSLayoutConstraint!
	
	private let maskLayer = CAShapeLayer()
	private let underlayView = UIView(frame: CGRect.zero)
	
	var delegate: CoachingTipsViewControllerDelegate?
	var currentState: CoachingTipsState = .Welcome {
		didSet {
			_updateUI()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clearColor()
		underlayView.backgroundColor = .blackColor()
		underlayView.alpha = 0.9
		
		_nextButton.update(title: "First Tip")
		
		underlayView.clipsToBounds = true
		underlayView.layer.mask = maskLayer
		
		var mainTitleSize: CGFloat = 30
		switch UIDevice.currentDevice().deviceType {
//		case .Simulator: mainTitleSize = 20
		case .IPhone4, .IPhone4S: mainTitleSize = 20
		case .IPhone5, .IPhone5C, .IPhone5S: mainTitleSize = 24
		default: break
		}
		_mainTitleLabel.font = UIFont(name: "OpenSans-Light", size: mainTitleSize)
		
		let subtitleSize: CGFloat = adjustedFontSizeForCurrentDevice(13)
		_subtitleLabel.font = UIFont(name: "OpenSans", size: subtitleSize)
		
		_setupSkipAllTipsButton()
		
		view.insertSubview(underlayView, atIndex: 0)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		underlayView.frame = view.bounds
		
		let pathRef = CGPathCreateMutable()
		CGPathAddRect(pathRef, nil, underlayView.bounds)
		
		let focusRect = delegate?.focusRect(forState: currentState) ?? CGRect.zero
		CGPathAddRect(pathRef, nil, focusRect)
		
		maskLayer.fillRule = kCAFillRuleEvenOdd
		maskLayer.path = pathRef
		
		let jamhawkIconIntersection = _iconImageView.frame.intersect(focusRect).height
		if jamhawkIconIntersection > 0 {
			_subtitleYPositionLayoutConstraint.constant = jamhawkIconIntersection + 10
		}
		
		let skipAllButtonIntersection = _skipAllTipsButton.frame.intersect(focusRect).height
		if skipAllButtonIntersection > 0 {
			_subtitleYPositionLayoutConstraint.constant = -(skipAllButtonIntersection + 10)
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	private func _setupSkipAllTipsButton() {
		let skipAllSize = adjustedFontSizeForCurrentDevice(13)
		let skipAllTitle = "Skip All Help Tips"
		
		let attrs: [String : AnyObject] = [
			NSFontAttributeName : UIFont(name: "OpenSans", size: skipAllSize)!,
			NSForegroundColorAttributeName : UIColor.whiteColor()
		]
		
		let highlightedAttrs: [String : AnyObject] = [
			NSFontAttributeName : UIFont(name: "OpenSans", size: skipAllSize)!,
			NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)
		]
		
		let normalAttrTitle = NSAttributedString(string: skipAllTitle, attributes: attrs)
		let highlightedAttrTitle = NSAttributedString(string: skipAllTitle, attributes: highlightedAttrs)
		
		_skipAllTipsButton.setAttributedTitle(normalAttrTitle, forState: .Normal)
		_skipAllTipsButton.setAttributedTitle(highlightedAttrTitle, forState: .Highlighted)
	}
	
	@IBAction private func _buttonPressed() {
		delegate?.nextButtonPressed(forCurrentState: currentState)
	}
	
	@IBAction private func _skipAllTipsButtonPressed() {
		delegate?.skipAllButtonPressed(forCurrentState: currentState)
	}
	
	private func _updateUI() {
		_mainTitleLabel.text = delegate?.mainTitleText(forState: currentState)
		_subtitleLabel.text = delegate?.subtitleText(forState: currentState)
		_iconImageView.image = delegate?.icon(forState: currentState)
		
		if let buttonTitle = delegate?.buttonTitleText(forState: currentState) {
			_nextButton.update(title: buttonTitle)
		}

		// viewDidLayoutSubviews contains logic for updating the focus rect
		view.layoutIfNeeded()
	}
}
