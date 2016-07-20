//
//  UILabel+Extensions.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/19/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UILabel {
   var kerning: Float {
      get {
         var range = NSMakeRange(0, (text ?? "").characters.count)
         guard let kern = attributedText?.attribute(NSKernAttributeName, atIndex: 0, effectiveRange: &range),
            value = kern as? NSNumber
            else {
               return 0
         }
         return value.floatValue
      }
      set {
         var attText:NSMutableAttributedString
         
         if let attributedText = attributedText {
            attText = NSMutableAttributedString(attributedString: attributedText)
         } else if let text = text {
            attText = NSMutableAttributedString(string: text)
         } else {
            attText = NSMutableAttributedString(string: "")
         }
         
         let range = NSMakeRange(0, attText.length)
         attText.addAttribute(NSKernAttributeName, value: NSNumber(float: newValue), range: range)
         self.attributedText = attText
      }
   }
}
