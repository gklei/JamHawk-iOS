//
//  CurrentTrackVotingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AsyncImageView

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
	
	@IBOutlet internal var _currentTrackLabel: UILabel!
	@IBOutlet internal var _albumArtImageView: AsyncImageView!
	@IBOutlet internal var _albumArtContainerView: UIView!
	
	private var _viewTransformer: ViewTransformer!
	
	private var _trackRatingVC: TrackRatingViewController?
	weak var trackRatingDataSource: TrackRatingDataSource? {
		didSet {
			_trackRatingVC?.dataSource = trackRatingDataSource
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_albumArtImageView.backgroundColor = .clearColor()
		_albumArtImageView.layer.cornerRadius = 3.0
		_albumArtImageView.layer.masksToBounds = true
		
		_albumArtContainerView.backgroundColor = .clearColor()
		
		_albumArtContainerView.layer.shadowRadius = 12
		_albumArtContainerView.layer.shadowOpacity = 0.5
		_albumArtContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		_albumArtContainerView.layer.shadowColor = UIColor.blackColor().CGColor
		
		_viewTransformer = ViewTransformer(view: _albumArtContainerView)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_albumArtContainerView.layer.shadowPath = UIBezierPath(rect: _albumArtContainerView.bounds).CGPath
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
		_albumArtImageView.imageURL = vm.albumArtworkURL
	}
	
	func setRatingViewControllerHidden(hidden: Bool) {
		_trackRatingVC?.view.alpha = hidden ? 0 : 1
	}
}

extension LargeCurrentTrackViewController {
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		_viewTransformer.touchesBegan(touches)
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		
		guard let point = touches.first?.locationInView(_albumArtContainerView) else { return }
		guard _albumArtContainerView.bounds.contains(point) else {
			_viewTransformer.resetViewWithDuration(0.5)
			return
		}
		
		_viewTransformer.touchesMoved(touches)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		_viewTransformer.resetViewWithDuration(0.5)
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		_viewTransformer.resetViewWithDuration(0.5)
	}
}