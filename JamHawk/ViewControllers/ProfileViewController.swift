//
//  ProfileViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum ProfileOptionType {
   case EditProfile
   case Settings
   
   var title: String {
      switch self {
      case .EditProfile:
         return "Edit Profile"
      case .Settings:
         return "Settings"
      }
   }
}

class ProfileViewController: UIViewController {
	
   @IBOutlet weak var _profileOptionsCollectionView: UICollectionView!
   private var _profileOptionTypes = [ProfileOptionType.EditProfile, ProfileOptionType.Settings]
   
   
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: _profileOptionsCollectionView.bounds.width, height: 50)
      layout.minimumLineSpacing = 1.0
      layout.scrollDirection = .Vertical
      layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 80)
      
      _profileOptionsCollectionView.dataSource = self
      _profileOptionsCollectionView.delegate = self
      
      _profileOptionsCollectionView.collectionViewLayout = layout
	}
	
   
   
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
	}
}

extension ProfileViewController: UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return _profileOptionTypes.count
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileOptionCell", forIndexPath: indexPath) as! ProfileOptionCell
      cell.titleLabel.text = _profileOptionTypes[indexPath.row].title
      return cell
   }
   
   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ProfileHeaderView", forIndexPath: indexPath)
      return header
   }
}

extension ProfileViewController: UICollectionViewDelegate {
}

class ProfileOptionCell: UICollectionViewCell {
   
   @IBOutlet var titleLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = .whiteColor()
   }
}