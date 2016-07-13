//
//  PlayheadView.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/13/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PlayheadView: UIView {
   
   override func awakeFromNib() {
      super.awakeFromNib()
      backgroundColor = UIColor.clearColor()
      
      let path = UIBezierPath()
      let rightMostPoint = CGPoint(x: bounds.maxX, y: 0)
      let middlePoint = CGPoint(x: bounds.midX, y: bounds.maxY)
      
      path.moveToPoint(CGPoint.zero)
      path.addLineToPoint(rightMostPoint)
      path.addLineToPoint(middlePoint)
      path.closePath()

      let triangleLayer = CAShapeLayer()
      triangleLayer.path = path.CGPath
      triangleLayer.fillColor = UIColor.whiteColor().CGColor
      triangleLayer.actions = ["bounds" : NSNull(), "position" : NSNull(), "frame" : NSNull()]
      layer.addSublayer(triangleLayer) 
   }
}
