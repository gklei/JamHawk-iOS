//
//  JHSignInSignUpTextField.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class JHSignInSignUpTextField: UITextField {
   override func textRectForBounds(bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 20, dy: 0)
   }
   override func editingRectForBounds(bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 20, dy: 0)
   }
}
