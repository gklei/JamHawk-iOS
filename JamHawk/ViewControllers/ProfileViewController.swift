//
//  ProfileViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol ProfileViewControllerDelegate: class {
	func profileViewController(controller: ProfileViewController, optionSelected option: ProfileOptionType)
}

enum ProfileOptionType: String {
   case EditProfile = "Edit Profile"
   case Settings = "Settings"
}

class ProfileViewController: UIViewController {
	
	@IBOutlet private var _profileNameLabel: UILabel!
   @IBOutlet weak var _profileOptionsCollectionView: UICollectionView!
	
	weak var delegate: ProfileViewControllerDelegate?
   private var _profileOptions = [ProfileOptionType.EditProfile, ProfileOptionType.Settings]
   
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 1.0
      layout.scrollDirection = .Vertical
      layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 80)
      layout.sectionInset.top = 1
      layout.sectionInset.bottom = 1
      
      _profileOptionsCollectionView.dataSource = self
      _profileOptionsCollectionView.delegate = self
      
      _profileOptionsCollectionView.collectionViewLayout = layout
		
		_profileOptionsCollectionView.registerClass(ProfileHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderViewCell")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let signOutSel = #selector(ProfileViewController.signOut)
		updateRightBarButtonItem(withTitle: "Sign Out   ", action: signOutSel)
		removeLeftBarItem()
		
//		reloadUI()
	}
	
	internal func signOut() {
		post(notification: .signOut)
	}
	
	func reloadUI() {
		_profileOptionsCollectionView.reloadData()
	}
}

extension ProfileViewController: Notifier {
	enum Notification: String {
		case signOut
	}
}

extension ProfileViewController: UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.width, height: 50)
   }
   
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let option = _profileOptions[indexPath.row]
		delegate?.profileViewController(self, optionSelected: option)
   }
}

extension ProfileViewController: UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return _profileOptions.count
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileOptionCell", forIndexPath: indexPath) as! ProfileOptionCell
		let option = _profileOptions[indexPath.row]
      cell.configure(withOption: option)
      return cell
   }
   
   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ProfileHeaderView", forIndexPath: indexPath) as! ProfileHeaderViewCell
		
		if let creds = JamhawkStorage.lastUsedCredentials {
			header.update(name: creds.email)
		}
      return header
   }
}

class ProfileHeaderViewCell: UICollectionReusableView {
	
	@IBOutlet private var _nameLabel: MarqueeLabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		_nameLabel.fadeLength = 10
	}
	
	func update(name name: String) {
		_nameLabel.text = name
	}
}

class ProfileOptionCell: UICollectionViewCell {
   
   @IBOutlet private var _titleLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = .whiteColor()
   }
	
	func configure(withOption option: ProfileOptionType) {
		_titleLabel.text = option.rawValue
	}
	
	override var highlighted: Bool {
		didSet {
			let whiteValue: CGFloat = highlighted ? 0.95 : 1
			backgroundColor = UIColor(white: whiteValue, alpha: 1)
		}
	}
}