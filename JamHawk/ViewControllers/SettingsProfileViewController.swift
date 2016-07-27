//
//  SettingsProfileViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum SettingProfileOptionType {
   case Share
   case TermsAndConditions
   
   var title: String {
      switch self {
      case .Share:
         return "Share Jamhawk"
      case .TermsAndConditions:
         return "Terms and Conditions"
      }
   }
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
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .Vertical
      layout.sectionInset.top = 1
      layout.sectionInset.bottom = 1
      
      _settingsProfileCollectionView.delegate = self
      _settingsProfileCollectionView.dataSource = self
      
      _settingsProfileCollectionView.collectionViewLayout = layout
   }
}



extension SettingsProfileViewController: UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.width, height: 50)
   }
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
      if section == 0 {
         return CGSize(width: collectionView.bounds.width, height: 25.0)
      }
      else { return CGSize(width: 0, height: 0) }
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
      cell._label.text = option.title
      return cell
   }
}



class SettingsOptionCell: UICollectionViewCell {
   @IBOutlet weak var _label: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = UIColor.whiteColor()
   }
}