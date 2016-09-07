//
//  CurrentTrackVotingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AsyncImageView
import MarqueeLabel

protocol CurrentTrackDataSource: class {
	var currentTrackViewModel: PlayerAPIOutputMetadataViewModel? { get }
}

class CurrentTrackViewController: UIViewController {
	weak var dataSource: CurrentTrackDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clearColor()
	}
	
	func syncUI() {
	}
}

final class CompactCurrentTrackViewController: CurrentTrackViewController, PlayerStoryboardInstantiable {
	
	@IBOutlet internal var _songTitleLabel: UILabel!
	@IBOutlet internal var _artistNameLabel: UILabel!
	
	private var _trackRatingVC: TrackRatingViewController?
	weak var trackRatingDataSource: TrackRatingDataSource? {
		didSet {
			_trackRatingVC?.dataSource = trackRatingDataSource
		}
	}
	
	var swipeUpClosure: () -> Void = {}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destController = segue.destinationViewController
		switch destController {
		case destController as TrackRatingViewController:
			_trackRatingVC = destController as? TrackRatingViewController
			_trackRatingVC?.dataSource = trackRatingDataSource
		default: break
		}
	}
	
	override func syncUI() {
		_trackRatingVC?.syncUI()
		
		guard let vm = dataSource?.currentTrackViewModel else { return }
		_songTitleLabel.text = vm.songTitle
		_artistNameLabel.text = vm.artistName
	}
	
	func setRatingViewControllerHidden(hidden: Bool) {
		_trackRatingVC?.view.alpha = hidden ? 0 : 1
	}
	
	@IBAction private func _swipeRecognized(recognizer: UIGestureRecognizer) {
		swipeUpClosure()
	}
}

final class LargeCurrentTrackViewController: CurrentTrackViewController, PlayerStoryboardInstantiable {
	
	@IBOutlet internal var _currentTrackLabel: MarqueeLabel!
	@IBOutlet internal var _albumArtImageView: AsyncImageView!
	@IBOutlet internal var _albumArtContainerView: UIView!
	@IBOutlet internal var _albumArtShadowView: UIView!
	@IBOutlet internal var _votingContainerHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet internal var _albumArtWidthConstraint: NSLayoutConstraint!
	@IBOutlet internal var _currentTrackLabelSpacingConstraint: NSLayoutConstraint!
	
	private var _viewTransformer: ViewTransformer!
	
	private var _currentArtworkImage: UIImage?
	private var _currentFilter: CIFilter?
	private var _duration = 0.0
	private var _transitionStartTime = CACurrentMediaTime()
	private var _originalImageExtent: CGRect?
	
	private var _trackRatingVC: TrackRatingViewController?
	weak var trackRatingDataSource: TrackRatingDataSource? {
		didSet {
			_trackRatingVC?.dataSource = trackRatingDataSource
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_albumArtImageView.backgroundColor = .clearColor()
		_albumArtContainerView.backgroundColor = .clearColor()
		
		_albumArtContainerView.layer.cornerRadius = 3.0
		_albumArtContainerView.layer.masksToBounds = true
		
		_albumArtShadowView.layer.shadowRadius = 12
		_albumArtShadowView.layer.shadowOpacity = 0.5
		_albumArtShadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
		_albumArtShadowView.layer.shadowColor = UIColor.blackColor().CGColor
		
		_viewTransformer = ViewTransformer(view: _albumArtShadowView)
		_currentTrackLabel.fadeLength = 10
		
		let fontSize = adjustedFontSizeForCurrentDevice(16)
		_currentTrackLabel.font = UIFont(name: "OpenSans-Semibold", size: fontSize)
		
		_adjustLayoutForCurrentDeviceSize()
	}
	
	private func _adjustLayoutForCurrentDeviceSize() {
		var albumArtWidthOffset: CGFloat = 0
		var votingContainerHeight: CGFloat = 44
		var currentTrackLabelSpacingConstant: CGFloat = 20
		
		switch UIDevice.currentDevice().deviceType {
		case .IPhone4, .IPhone4S:
			currentTrackLabelSpacingConstant = 10
			votingContainerHeight = 34
			albumArtWidthOffset = 40
		case .IPhone5, .IPhone5C, .IPhone5S:
			votingContainerHeight = 34
		default: break
		}
		
		_votingContainerHeightConstraint.constant = votingContainerHeight
		_albumArtWidthConstraint.constant = -albumArtWidthOffset
		_currentTrackLabelSpacingConstraint.constant = currentTrackLabelSpacingConstant
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_albumArtShadowView.layer.shadowPath = UIBezierPath(rect: _albumArtShadowView.bounds).CGPath
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destController = segue.destinationViewController
		switch destController {
		case destController as TrackRatingViewController:
			_trackRatingVC = destController as? TrackRatingViewController
			_trackRatingVC?.dataSource = trackRatingDataSource
		default: break
		}
	}
	
	override func syncUI() {
		_trackRatingVC?.syncUI()
		
		guard let vm = dataSource?.currentTrackViewModel else { return }
		_currentTrackLabel.text = vm.artistAndSongTitle
		_currentTrackLabel.restartLabel()
		
		_currentArtworkImage = nil
		_albumArtImageView.crossfadeDuration = 0.4
		_albumArtImageView.imageURL = vm.albumArtworkURL
	}
	
	func setRatingViewControllerHidden(hidden: Bool) {
		_trackRatingVC?.view.alpha = hidden ? 0 : 1
	}
	
	private func _currentAlbumArtImage() -> UIImage? {
		let rect = _albumArtImageView.bounds
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		
		_albumArtImageView.drawViewHierarchyInRect(rect, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		return image
	}
	
	@IBAction private func _longPressRecognized(recognizer: UIGestureRecognizer) {
		guard recognizer.state == .Began && _duration == 0 else { return }
		if _currentArtworkImage == nil {
			_currentArtworkImage = _currentAlbumArtImage()
			_currentFilter = _filter(forImage: _currentArtworkImage)
		}
		
		_albumArtImageView.crossfadeDuration = 0
		rippleImage(duration: 1.2)
	}
}

extension LargeCurrentTrackViewController {
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		_viewTransformer.touchesBegan(touches)
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		
		guard let point = touches.first?.locationInView(_albumArtShadowView) else { return }
		guard _albumArtShadowView.bounds.contains(point) else {
			_viewTransformer.resetViewWithDuration(0.4)
			return
		}
		
		_viewTransformer.touchesMoved(touches)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		_viewTransformer.resetViewWithDuration(0.4)
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		_viewTransformer.resetViewWithDuration(0.4)
	}
}

extension LargeCurrentTrackViewController {
	
	private func _filter(forImage image: UIImage?) -> CIFilter? {
		guard let image = image else { return nil }
		
		let coreImage = CIImage(CGImage: image.CGImage!)
		_originalImageExtent = coreImage.extent
		
		let filter = CIFilter(name: "CIRippleTransition")
		
		let clampedImage = coreImage.imageByClampingToExtent()
		filter?.setValue(clampedImage, forKey: kCIInputImageKey)
		
		//If you want to transition to another image, you would supply a different image value here.
		filter?.setValue(clampedImage, forKey: kCIInputTargetImageKey)
		filter?.setValue(CIImage(), forKey: kCIInputShadingImageKey)
		
		let center = _originalImageExtent!.size.width * 0.5
		let centerPoint = CGPoint(x: center, y: center)
		let inputCenter = CIVector(CGPoint: centerPoint)
		
		filter?.setValue(inputCenter, forKey: kCIInputCenterKey)
		
		let scale = NSNumber(float: 80)
		filter?.setValue(scale, forKey: kCIInputScaleKey)
		
		return filter
	}
	
	func rippleImage(duration duration: Double) {
		//Don't forget to keep track of your duration for calculations later.
		_duration = duration
		
		//Update our start time since we immediately fire off our display link after this line.
		_transitionStartTime = CACurrentMediaTime()
		
		let selector = #selector(LargeCurrentTrackViewController.timerFired(_:))
		let displayLink = CADisplayLink(target: self, selector: selector)
		displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
	}
	
	func timerFired(displayLink: CADisplayLink) {
		guard let filter = _currentFilter, extent = _originalImageExtent else {
			//If the filter is nil, invalidate our display link.
			displayLink.invalidate()
			return
		}
		
		//Grab the difference of the current time and our transitionStartTime and see the percentage of that against our duration. Using min(), we guarantee that our percentage doesn't go over 1.0.
		let progress = min((CACurrentMediaTime() - _transitionStartTime) / _duration, 1.0)
		filter.setValue(progress, forKey: kCIInputTimeKey)
		
		//After we set a value on our filter, the filter applies that value to the image and filters it accordingly so we get a new outputImage immediately after the setValue finishes running.
		let CIImage = filter.outputImage!.imageByCroppingToRect(extent)
		let scale = UIScreen.mainScreen().scale
		
		let context = CIContext(options: nil) //You can also create a context from an OpenGL context bee-tee-dubs.
		let cgImage = context.createCGImage(CIImage, fromRect: extent)
		_albumArtImageView.image = UIImage(CGImage: cgImage, scale: scale, orientation: .Up)
		
		if progress >= 1.0 {
			_duration = 0
			_albumArtImageView.image = _currentArtworkImage
			displayLink.invalidate()
		}
	}
}