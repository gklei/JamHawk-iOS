//
//  VolumeAdjustmentViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/4/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol VolumeAdjustmentDelegate: class {
	func volumeAdjustmentViewControllerDidUpdateVolume(volume: Float)
}

final class VolumeAdjustmentViewController: UIViewController, PlayerStoryboardInstantiable {
	
	@IBOutlet private var _container: UIView!
	@IBOutlet private var _sliderContainer: UIView!
	
	private let _volumeSlider = VolumeSlider()
	weak var delegate: VolumeAdjustmentDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_setupContainerShadow()
		_setupVolumeSlider()
		
		let selector = #selector(VolumeAdjustmentViewController.sliderValueChanged(_:))
		_volumeSlider.addTarget(self, action: selector, forControlEvents: .ValueChanged)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_volumeSlider.center = CGPoint(x: _sliderContainer.bounds.midX, y: _sliderContainer.bounds.midY)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	private func _setupContainerShadow() {
		_container.layer.cornerRadius = 2.0
		_container.layer.shadowOffset = CGSize(width: 0, height: 0)
		_container.layer.shadowColor = UIColor.blackColor().CGColor
		_container.layer.shadowOpacity = 0.3
		_container.layer.shadowPath = UIBezierPath(rect: _container.bounds).CGPath
	}
	
	private func _setupVolumeSlider() {
		let containerBounds = _sliderContainer.bounds
		_volumeSlider.frame = CGRect(x: 0, y: 0, width: containerBounds.height, height: containerBounds.width)
		_volumeSlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
		_volumeSlider.translatesAutoresizingMaskIntoConstraints = true
		_sliderContainer.addSubview(_volumeSlider)
	}
	
	@IBAction private func dismissView(sender: AnyObject) {
		if let recognizer = sender as? UIGestureRecognizer {
			let location = recognizer.locationInView(nil)
			guard !_container.frame.contains(location) else { return }
			dismissViewControllerAnimated(true, completion: nil)
		} else {
			dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	internal func sliderValueChanged(slider: UISlider) {
		delegate?.volumeAdjustmentViewControllerDidUpdateVolume(slider.value)
	}
	
	func update(volume volume: Float) {
		_volumeSlider.setValue(volume, animated: false)
	}
}
