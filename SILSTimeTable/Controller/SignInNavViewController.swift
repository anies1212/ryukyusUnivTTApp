//
//  SignInNavViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/07/09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class SignInNavViewController: UINavigationController {

        override func viewDidLoad() {
            super.viewDidLoad()

            
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7311812043, green: 0.4956023693, blue: 0.9030517936, alpha: 1)
            // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
            self.overrideUserInterfaceStyle = .light

        }
        
}
