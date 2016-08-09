//
//  ProfileViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	
   @IBOutlet weak var _profileOptionsCollectionView: UICollectionView!
   
   
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: _profileOptionsCollectionView.bounds.width, height: 50)
      layout.minimumLineSpacing = 1.0
      layout.scrollDirection = .Vertical
      
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
      return 2
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileOptionCell", forIndexPath: indexPath) as! ProfileOptionCell
      cell.titleLabel.text = "Fuck"
      return cell
   }
}

extension ProfileViewController: UICollectionViewDelegate {
}

class ProfileOptionCell: UICollectionViewCell {
   
   @IBOutlet var titleLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = .redColor()
   }
}