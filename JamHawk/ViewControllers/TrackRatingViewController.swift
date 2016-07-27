//
//  TrackRatingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol TrackRatingDataSource: class {
	var ratingOptions: [PlayerAPIOutputTrackRating] { get }
	var currentTrackRating: PlayerAPIOutputTrackRating? { get }
	func rateCurrentTrack(rating: PlayerAPIOutputTrackRating)
}

class TrackRatingViewController: UIViewController {
	
	@IBOutlet private var _collectionView: UICollectionView!
	
	weak var dataSource: TrackRatingDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .clearColor()
		_collectionView.dataSource = self
		_collectionView.delegate = self
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
	
	// MARK: - Public
	func syncUI() {
		_collectionView.reloadData()
		
		guard let currentRating = dataSource?.currentTrackRating else { return }
		guard let index = dataSource?.ratingOptions.indexOf(currentRating) else { return }
		
		let ip = NSIndexPath(forRow: index, inSection: 0)
		_collectionView.selectItemAtIndexPath(ip, animated: true, scrollPosition: .None)
	}
}

extension TrackRatingViewController: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource?.ratingOptions.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrackRatingCell.reuseID, forIndexPath: indexPath) as! TrackRatingCell
		
		if let rating = dataSource?.ratingOptions[indexPath.row] {
			cell.update(withRating: rating)
		}
		return cell
	}
}

extension TrackRatingViewController: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let rating = dataSource?.ratingOptions[indexPath.row] else { return }
		if dataSource?.currentTrackRating == rating {
			dataSource?.rateCurrentTrack(.Neutral)
		} else {
			dataSource?.rateCurrentTrack(rating)
		}
	}
}
