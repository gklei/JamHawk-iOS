//
//  SettingsProfileViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum SettingProfileOptionType: String {
   case Share = "Share Jamhawk"
   case TermsAndConditions = "Terms and Conditions"
}

enum SettingProfileSectionType {
   case Social
   case Legal
   
   var options: [SettingProfileOptionType] {
      switch self {
      case .Social:
         return [SettingProfileOptionType.Share]
      case .Legal:
         return [SettingProfileOptionType.TermsAndConditions]
      }
   }
}

class SettingsProfileViewController: UIViewController {
	
   let _settingProfileSections: [SettingProfileSectionType] = [.Social, .Legal]
   
   @IBOutlet weak var _settingsProfileCollectionView: UICollectionView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
		
		_setupCollectionViewLayout()
      _settingsProfileCollectionView.delegate = self
      _settingsProfileCollectionView.dataSource = self
   }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let sel = #selector(SettingsProfileViewController.goBack)
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

extension SettingsProfileViewController: UICollectionViewDelegate {
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
   
}

extension SettingsProfileViewController: UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let settingsSection = _settingProfileSections[section]
      return settingsSection.options.count
   }
   
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return _settingProfileSections.count
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SettingsOptionCell", forIndexPath: indexPath) as! SettingsOptionCell
      
      let section = _settingProfileSections[indexPath.section]
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
	
	func configure(withOption option: SettingProfileOptionType) {
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