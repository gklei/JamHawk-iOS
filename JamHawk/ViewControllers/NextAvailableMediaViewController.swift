//
//  NextAvailableMediaViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol NextAvailableMediaSelectionDataSource: class {
	var selectedMediaIndex: Int? { get }
	var nextAvailableMediaViewModels: [PlayerAPIOutputMetadataViewModel] { get }
	
	func viewModel(atIndex index: Int) -> PlayerAPIOutputMetadataViewModel?
	func selectMedia(atIndex index: Int)
}

protocol NextAvailableMediaViewControllerDelegate: class {
	func nextAvailableMediaLongPressDidStart(viewModel: PlayerAPIOutputMetadataViewModel,
	                                         targetRect: CGRect,
	                                         controller: NextAvailableMediaViewController)
	
	func nextAvailableMediaLongPressDidEnd(viewModel: PlayerAPIOutputMetadataViewModel,
	                                       controller: NextAvailableMediaViewController)
}

final class NextAvailableMediaViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet private var _collectionView: UICollectionView!
	@IBOutlet private var _nextSongInfoLabel: MarqueeLabel!
	
	private var _setCollectionViewHeight = false
	
	// MARK: - Properties
	weak var dataSource: NextAvailableMediaSelectionDataSource?
	weak var delegate: NextAvailableMediaViewControllerDelegate?
	
	private var _lastLongPressedTrack: PlayerAPIOutputMetadataViewModel?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_registerCollectionViewCells()
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
		
		_nextSongInfoLabel.fadeLength = 10
		
		let topBorder = view.addBorder(withSize: 1, toEdge: .Top)
		topBorder?.backgroundColor = UIColor(white: 1, alpha: 0.4)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_setCollectionViewHeightIfNecessary()
	}
	
	private func _setCollectionViewHeightIfNecessary() {
		if !_setCollectionViewHeight {
			_collectionViewHeightConstraint.constant = view.frame.height * 0.4
			_setupCollectionViewLayout()
			_setCollectionViewHeight = true
		}
	}
	
	// MARK: - Setup
	private func _setupCollectionViewLayout() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 28.0
		layout.scrollDirection = .Horizontal
		
		_collectionView.collectionViewLayout = layout
	}
	
	private func _registerCollectionViewCells() {
		let nib = UINib(nibName: NextAvailableMediaCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: NextAvailableMediaCell.reuseID)
	}
	
	// MARK: - Public
	func syncData() {
		_collectionView.reloadSections(NSIndexSet(index: 0))
	}
	
	func syncUI() {
		_updateInfoLabel()
		if let selectedIndex = self.dataSource?.selectedMediaIndex {
			let ip = NSIndexPath(forRow: selectedIndex, inSection: 0)
			_collectionView.selectItemAtIndexPath(ip, animated: true, scrollPosition: .CenteredHorizontally)
		}
	}
	
	private func _updateInfoLabel() {
		guard let index = dataSource?.selectedMediaIndex else { return }
		guard let viewModel = dataSource?.nextAvailableMediaViewModels[index] else { return }
		guard let artistAndSongTitle = viewModel.artistAndSongTitle else { return }
		
		let fontSize: CGFloat = adjustedFontSizeForCurrentDevice(14)
		let nextSongText = "Next Song: "
		
		let regularAttrs: [String : AnyObject] = [
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "OpenSans", size: fontSize)!
		]
		let boldAttrs: [String : AnyObject] = [
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "OpenSans-SemiBold", size: fontSize)!
		]
		
		let nextSongAttributedString = NSAttributedString(string: nextSongText, attributes: regularAttrs)
		let artistAndSongAttributedString = NSAttributedString(string: artistAndSongTitle, attributes: boldAttrs)
		
		let attributedString = NSMutableAttributedString()
		attributedString.appendAttributedString(nextSongAttributedString)
		attributedString.appendAttributedString(artistAndSongAttributedString)
		
		_nextSongInfoLabel.attributedText = attributedString
		_nextSongInfoLabel.kerning = 1.2
		_nextSongInfoLabel.restartLabel()
	}
	
	@IBAction private func _longPressedRecognized(recognizer: UIGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			let p = recognizer.locationInView(_collectionView)
			guard let indexPath = _collectionView.indexPathForItemAtPoint(p) else { return }
			guard let cellFrame = _collectionView.cellForItemAtIndexPath(indexPath)?.frame else { return }
			let targetFrame = _collectionView.convertRect(cellFrame, toView: view)
			guard let vm = dataSource?.viewModel(atIndex: indexPath.row) else { return }
			_lastLongPressedTrack = vm
			delegate?.nextAvailableMediaLongPressDidStart(vm, targetRect: targetFrame, controller: self)
		case .Ended:
			guard let vm = _lastLongPressedTrack else { return }
			_lastLongPressedTrack = nil
			delegate?.nextAvailableMediaLongPressDidEnd(vm, controller: self)
		default: break
		}
	}
}

extension NextAvailableMediaViewController: UICollectionViewDataSource {
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource?.nextAvailableMediaViewModels.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cellID = NextAvailableMediaCell.reuseID
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! NextAvailableMediaCell
		
		if let viewModels = dataSource?.nextAvailableMediaViewModels {
			let vm = viewModels[indexPath.row]
			cell.update(withViewModel: vm)
		}
		
		return cell
	}
}

extension NextAvailableMediaViewController: UICollectionViewDelegate {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let size = _collectionView.bounds.height - 1
		return CGSize(width: size, height: size)
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		dataSource?.selectMedia(atIndex: indexPath.row)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
	{
		let cellWidth = collectionView.bounds.height
		let numberOfCells: CGFloat = CGFloat(dataSource?.nextAvailableMediaViewModels.count ?? 0)
		let cellSpacing: CGFloat = 28.0
		
		let viewWidth = UIScreen.mainScreen().bounds.width
		let totalContentWidth = numberOfCells * cellWidth + ((numberOfCells - 1) * cellSpacing)
		
		var leftEdgeInset = (viewWidth - totalContentWidth) * 0.5
		leftEdgeInset = max(leftEdgeInset, 0)
		
		return UIEdgeInsets(top: 0, left: leftEdgeInset, bottom: 0, right: leftEdgeInset)
	}
}