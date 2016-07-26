//
//  TrackRatingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol TrackRatingDataSource: class {
	var currentTrackRating: PlayerAPIOutputTrackRating? { get }
	func rateCurrentTrack(rating: PlayerAPIOutputTrackRating)
}

class TrackRatingViewController: UIViewController {
	
	private let _ratings: [PlayerAPIOutputTrackRating] = [.Negative, .Positive]
	@IBOutlet private var _collectionView: UICollectionView!
	
	weak var dataSource: TrackRatingDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .clearColor()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_updateCollectionViewLayout()
	}
	
	private func _updateCollectionViewLayout() {
		let layout = _collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let size = view.bounds.height
		layout.itemSize = CGSize(width: size, height: size)
	}
	
	private func _registerCollectionViewCellClass() {
		_collectionView.registerClass(TrackRatingCell.self, forCellWithReuseIdentifier: TrackRatingCell.reuseID)
	}
}

extension TrackRatingViewController: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _ratings.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrackRatingCell.reuseID, forIndexPath: indexPath) as! TrackRatingCell
		
		let rating = _ratings[indexPath.row]
		cell.update(withRating: rating)
		
		return cell
	}
}

extension TrackRatingViewController: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let rating = _ratings[indexPath.row]
		dataSource?.rateCurrentTrack(rating)
	}
}
