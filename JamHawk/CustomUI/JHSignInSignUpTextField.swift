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
		let rect = super.textRectForBounds(bounds)
      let insetRect = bounds.insetBy(dx: 20, dy: rect.origin.y)
		let origin = CGPoint(x: insetRect.origin.x, y: rect.origin.y)
		return CGRect(origin: origin, size: insetRect.size)
   }
   override func editingRectForBounds(bounds: CGRect) -> CGRect {
		let rect = super.editingRectForBounds(bounds)
		let insetRect = bounds.insetBy(dx: 20, dy: rect.origin.y)
		let origin = CGPoint(x: insetRect.origin.x, y: rect.origin.y)
		return CGRect(origin: origin, size: insetRect.size)
   }
}
