//
//  EditProfileViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum EditProfileOptionType {
   case Email
   case Password
   
   var title: String {
      switch self {
      case .Email:
         return "Email"
      case .Password:
         return "Change Password"
      }
   }
   
   var placeholderText: String {
      switch self {
      case .Email:
			return JamhawkStorage.lastUsedCredentials?.email ?? ""
      case .Password:
			return JamhawkStorage.lastUsedCredentials?.password ?? ""
      }
   }
}

protocol EditProfileViewControllerDelegate: class {
	func editProfileViewController(controller: EditProfileViewController, optionSelected option: EditProfileOptionType)
}

class EditProfileViewController: UIViewController {
	
	// MARK: - Outlets
   @IBOutlet weak var _editProfileOptionsCollectionView: UICollectionView!
	
	weak var delegate: EditProfileViewControllerDelegate?
	private var _options: [EditProfileOptionType] = [.Email, .Password]
   
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
		
		
		let sel = #selector(EditProfileViewController.goBack)
		updateLeftBarButtonItem(withTitle: "  Back", action: sel)
   }
	
	internal func goBack() {
		navigationController?.popViewControllerAnimated(true)
	}
	
	func reloadUI() {
		_editProfileOptionsCollectionView.reloadData()
	}
}

extension EditProfileViewController: UICollectionViewDelegate {
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.width, height: 50)
   }
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let option = _options[indexPath.row]
		delegate?.editProfileViewController(self, optionSelected: option)
	}
}

extension EditProfileViewController: UICollectionViewDataSource {
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return _options.count
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EditProfileOptionCell", forIndexPath: indexPath) as! EditProfileOptionCell
      cell._optionLabel.text = _options[indexPath.row].title
      cell._optionInputTextField.text = _options[indexPath.row].placeholderText
      cell._optionInputTextField.textColor = UIColor.jmhWarmGreyColor()
      if _options[indexPath.row] == EditProfileOptionType.Password {
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
	
	override var highlighted: Bool {
		didSet {
			let whiteValue: CGFloat = highlighted ? 0.95 : 1
			backgroundColor = UIColor(white: whiteValue, alpha: 1)
		}
	}
}
