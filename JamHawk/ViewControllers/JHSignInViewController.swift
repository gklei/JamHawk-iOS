//
//  JHSignInViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/19/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class JHSignInViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      emailTextField.layer.borderColor = UIColor.jmhLightGrayColor().CGColor
      emailTextField.layer.borderWidth = 1.5
      
      passwordTextField.layer.borderColor = UIColor.jmhLightGrayColor().CGColor
      passwordTextField.layer.borderWidth = 1.5
      
      signInLabel.text = "Sign In"
      signInLabel.kerning = 7.0
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - IBOutlets
   @IBOutlet weak var signInLabel: UILabel!
   
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   
   @IBOutlet weak var forgotPasswordButton: UIButton!
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
