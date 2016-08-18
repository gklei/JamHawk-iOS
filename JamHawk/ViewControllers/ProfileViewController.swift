//
//  ProfileViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum ProfileOptionType: String {
   case EditProfile = "Edit Profile"
   case Settings = "Settings"
   
   var destinationVC: UIViewController? {
      switch self {
         case .EditProfile: return EditProfileViewController.instantiate(fromStoryboard: "Profile")
         case .Settings: return SettingsProfileViewController.instantiate(fromStoryboard: "Profile")
      }
   }
}

class ProfileViewController: UIViewController {
	
   @IBOutlet weak var _profileOptionsCollectionView: UICollectionView!
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
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
	}
}

extension ProfileViewController: UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.width, height: 50)
   }
   
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      guard let vc = _profileOptions[indexPath.row].destinationVC else { return }
      navigationController?.pushViewController(vc, animated: true)
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
      let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ProfileHeaderView", forIndexPath: indexPath)
      return header
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