//
//  ViewTransformer.swift
//  DYR
//
//  Created by Klein, Greg on 8/14/15.
//  Copyright (c) 2015 Sparkhouse. All rights reserved.
//

import UIKit

extension CATransform3D
{
   static var perspectiveTransform: CATransform3D {
      var transform = CATransform3DIdentity
      transform.m34 = 1 / -900.0
      return transform
   }
}

protocol ViewTransformerProtocol
{
   func touchesBegan(touches: Set<NSObject>)
   func touchesMoved(touches: Set<NSObject>)
   func resetViewWithDuration(duraiton: NSTimeInterval)
}

class ViewTransformer: ViewTransformerProtocol
{
   var view: UIView
   private var initialViewCenter = CGPoint.zero
   private var firstTouchLocation = CGPoint.zero
   
   var maxY: CGFloat?
   
   var takeItEasy = false
   
   init(view: UIView)
   {
      self.view = view
   }
   
   func touchesBegan(touches: Set<NSObject>)
   {
      if let touch = touches.first as? UITouch where self.firstTouchLocation == CGPoint.zero
      {
         self.initialViewCenter = self.view.center
         self.firstTouchLocation = touch.locationInView(nil)
      }
   }
   
   func touchesMoved(touches: Set<NSObject>)
   {
      if let touch = touches.first as? UITouch where firstTouchLocation != .zero
      {
         var currentTouchLocation = touch.locationInView(nil)
         let dx = self.firstTouchLocation.x - currentTouchLocation.x
         
         let currentTouchY = currentTouchLocation.y
         if let maxY = maxY {
            currentTouchLocation.y = min(maxY, currentTouchY)
         }
         
         let dy = self.firstTouchLocation.y - currentTouchLocation.y
         
         let deltaVector = CGVector(dx: dx, dy: dy)
         
         var updatedTransform = CATransform3D.perspectiveTransform
         rotateTransform(&updatedTransform, withDeltaVector: deltaVector)
         scaleTransform(&updatedTransform, withDeltaVector: deltaVector)
         
         self.view.layer.transform = updatedTransform
         
         let newCenterX = self.initialViewCenter.x - deltaVector.dx / 5
         let newCenterY = self.initialViewCenter.y - deltaVector.dy / 5
         self.view.center = CGPoint(x: newCenterX, y: newCenterY)
      }
   }
   
   func resetViewWithDuration(duration: NSTimeInterval)
   {
      UIView.animateWithDuration(duration / 1.5, animations: { () -> Void in
         self.view.center = self.initialViewCenter
      })
      
      UIView.animateWithDuration(duration / 1.5, delay: duration / 3, options: [], animations: { () -> Void in
         self.view.layer.transform = CATransform3DIdentity
         }, completion: nil)
      
      self.firstTouchLocation = CGPoint.zero
   }
   
   // MARK: - Private
   private func rotateTransform(inout transform: CATransform3D, withDeltaVector deltaVector: CGVector)
   {
      let scale: CGFloat = takeItEasy ? 750 : 500
      transform = CATransform3DRotate(transform, -deltaVector.dx / scale, 0, 1, 0)
      transform = CATransform3DRotate(transform, deltaVector.dy / scale, 1, 0, 0)
   }
   
   private func scaleTransform(inout transform: CATransform3D, withDeltaVector deltaVector: CGVector)
   {
      let xScale = scaleForDeltaValue(deltaVector.dy)
      let yScale = scaleForDeltaValue(deltaVector.dx)
      let zScale = (xScale * yScale) / 2
      
      transform = CATransform3DScale(transform, xScale, yScale, zScale)
   }
   
   private func scaleForDeltaValue(value: CGFloat) -> CGFloat
   {
      return max(log(abs(value * 0.012) + 1) * 0.8, 1.0)
   }
}