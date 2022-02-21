//
//  MemoNavViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/07/09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class MemoNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()

        // Do any additional setup after loading the view.
        
        
        let button = UIButton(type: .system)
        button.setTitle("Menu", for: .normal)
        let menuBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = menuBarButtonItem
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    

   
}
