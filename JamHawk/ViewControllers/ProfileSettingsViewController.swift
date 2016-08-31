//
//  ProfileSettingsViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum ProfileSettingsOptionType: String {
   case Share = "Share Jamhawk"
   case TermsAndConditions = "Terms and Conditions"
}

enum ProfileSettingsSectionType {
   case Social
   case Legal
   
   var options: [ProfileSettingsOptionType] {
      switch self {
      case .Social:
         return [ProfileSettingsOptionType.Share]
      case .Legal:
         return [ProfileSettingsOptionType.TermsAndConditions]
      }
   }
}

protocol ProfileSettingsViewControllerDelegate: class {
	func profileSettingsViewController(controller: ProfileSettingsViewController, optionSelected option: ProfileSettingsOptionType)
}

class ProfileSettingsViewController: UIViewController {
	
	@IBOutlet private var _settingsProfileCollectionView: UICollectionView!
	
   private let _sections: [ProfileSettingsSectionType] = [.Social, .Legal]
	weak var delegate: ProfileSettingsViewControllerDelegate?
   
   override func viewDidLoad() {
      super.viewDidLoad()
		
		_setupCollectionViewLayout()
      _settingsProfileCollectionView.delegate = self
      _settingsProfileCollectionView.dataSource = self
   }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let sel = #selector(ProfileSettingsViewController.goBack)
		updateLeftBarButtonItem(withTitle: "  Back", action: sel)
	}
	
	private func _setupCollectionViewLayout() {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .Vertical
		layout.sectionInset.top = 1
		layout.sectionInset.bottom = 1
		_settingsProfileCollectionView.collectionViewLayout = layout
	}
	
	internal func goBack() {
		navigationController?.popViewControllerAnimated(true)
	}
}

extension ProfileSettingsViewController: UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.width, height: 50)
   }
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
      if section == 0 {
         return CGSize(width: 0, height: 25.0)
      }
      else {
			return CGSize(width: 0, height: 0)
		}
   }
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let section = _sections[indexPath.section]
		let option = section.options[indexPath.row]
		delegate?.profileSettingsViewController(self, optionSelected: option)
	}
}

extension ProfileSettingsViewController: UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let settingsSection = _sections[section]
      return settingsSection.options.count
   }
   
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return _sections.count
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SettingsOptionCell", forIndexPath: indexPath) as! SettingsOptionCell
      
      let section = _sections[indexPath.section]
      let option = section.options[indexPath.row]
		cell.configure(withOption: option)
      return cell
   }
}

class SettingsOptionCell: UICollectionViewCell {
   @IBOutlet private var _label: UILabel!
	
	private var _topBorder: UIView?
	private var _bottomBorder: UIView?
	
	var showTopBorder: Bool = false {
		didSet {
			_topBorder?.backgroundColor = showTopBorder ? UIColor.jmhLightGrayColor() : .clearColor()
		}
	}
	
	var showBottomBorder: Bool = false {
		didSet {
			_bottomBorder?.backgroundColor = showBottomBorder ? UIColor.jmhLightGrayColor() : .clearColor()
		}
	}
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = UIColor.whiteColor()
		
		_topBorder = addBorder(withSize: 1, toEdge: .Top)
		_bottomBorder = addBorder(withSize: 1, toEdge: .Bottom)
   }
	
	func configure(withOption option: ProfileSettingsOptionType) {
		_label.text = option.rawValue
		
		switch option {
		case .Share:
			showTopBorder = false
			showBottomBorder = true
		case .TermsAndConditions:
			showTopBorder = true
			showBottomBorder = true
		}
	}
	
	override var highlighted: Bool {
		didSet {
			let whiteValue: CGFloat = highlighted ? 0.95 : 1
			backgroundColor = UIColor(white: whiteValue, alpha: 1)
		}
	}
}