//
//  JHSignUpViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class JHSignUpViewController: UIViewController {

   
   @IBOutlet private var _containerView: UIView!
   @IBOutlet private var _centerYConstraint: NSLayoutConstraint!
   
   var session: JamHawkSession?
   
   override func viewDidLoad() {
        super.viewDidLoad()
    }
}
