//
//  MainPlayerViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncImageView
import IncipiaKit

class MainPlayerViewController: UIViewController
{
	// MARK: - Outlets
	@IBOutlet private var _posterImageView: AsyncImageView!
	@IBOutlet private var _songLabel: UILabel!
	@IBOutlet private var _artistLabel: UILabel!
	@IBOutlet private var _albumLabel: UILabel!
	
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	@IBOutlet private var _nextAvailableCollectionView: UICollectionView!
	
	var output: PlayerAPIOutput?
	var player: AVPlayer?
	
	// MARK: - Overridden
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .Default
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: "NextAvailableMediaCell", bundle: nil)
		_nextAvailableCollectionView.registerNib(nib, forCellWithReuseIdentifier: "NextAvailableMediaCell")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		guard let media = output.media else { return }
		guard let url = media.trackURL else { return }
		
		player = AVPlayer(URL: url)
		player?.play()
		
		_posterImageView.showActivityIndicator = true
		_posterImageView.imageURL = media.posterURL
		_backgroundImageView.imageURL = media.posterURL
		
		guard let metadata = output.track else { return }
		_songLabel.text = metadata.title
		_artistLabel.text = metadata.artist
		_albumLabel.text = metadata.album
		
		title = metadata.title
		
		_nextAvailableCollectionView.reloadData()
	}
}

extension MainPlayerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NextAvailableMediaCell", forIndexPath: indexPath) as! NextAvailableMediaCell
		
		if let next = output?.next where next.count > indexPath.row {
			let metadata = next[indexPath.row]
			cell.update(withMetatdata: metadata)
		}
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
	{
		let cellWidth: CGFloat = 80
		let numberOfCells: CGFloat = 4.0
		let cellSpacing: CGFloat = 5
		
		let viewWidth = UIScreen.mainScreen().bounds.width
		let totalContentWidth = numberOfCells * cellWidth + ((numberOfCells - 1) * cellSpacing)
		
		var leftEdgeInset = (viewWidth - totalContentWidth) * 0.5
		leftEdgeInset = max(leftEdgeInset, 0)
		
		return UIEdgeInsets(top: 5, left: leftEdgeInset, bottom: 5, right: leftEdgeInset)
	}
}