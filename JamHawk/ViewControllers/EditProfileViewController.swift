//
//  EditProfileViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum EditProfileFieldType {
   case Email
   case ChangePassword
   
   var title: String {
      switch self {
      case .Email:
         return "Email"
      case .ChangePassword:
         return "Change Password"
      }
   }
   
   var placeholderText: String {
      switch self {
      case .Email:
         return "jdoe@gmail.com"
      case .ChangePassword:
         return "*******"
      }
   }
}

class EditProfileViewController: UIViewController {
   @IBOutlet weak var _editProfileOptionsCollectionView: UICollectionView!
   private var _editProfileOptions = [EditProfileFieldType.Email, EditProfileFieldType.ChangePassword]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 1.0
      layout.scrollDirection = .Vertical
      layout.sectionInset.top = 1
      layout.sectionInset.bottom = 1
      
      _editProfileOptionsCollectionView.dataSource = self
      _editProfileOptionsCollectionView.delegate = self
      _editProfileOptionsCollectionView.collectionViewLayout = layout
      
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(true)
   }
}

extension EditProfileViewController: UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.width, height: 50)
   }
}

extension EditProfileViewController: UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return _editProfileOptions.count
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EditProfileOptionCell", forIndexPath: indexPath) as! EditProfileOptionCell
      cell._optionLabel.text = _editProfileOptions[indexPath.row].title
      cell._optionInputTextField.placeholder = _editProfileOptions[indexPath.row].placeholderText
      cell._optionInputTextField.textColor = UIColor.jmhLightGrayColor()
      if _editProfileOptions[indexPath.row] == EditProfileFieldType.ChangePassword {
         cell._optionInputTextField.secureTextEntry = true
      }
      return cell
   }
}

class EditProfileOptionCell: UICollectionViewCell {
   @IBOutlet weak var _optionLabel: UILabel!
   @IBOutlet weak var _optionInputTextField: UITextField!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = .whiteColor()
   }
}
