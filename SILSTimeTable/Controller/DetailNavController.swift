//
//  DetailNavController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/07/09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class DetailNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7311812043, green: 0.4956023693, blue: 0.9030517936, alpha: 1)
//
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = #colorLiteral(red: 0.7311812043, green: 0.4956023693, blue: 0.9030517936, alpha: 1)
//        appearance.titleTextAttributes = [
//            .foregroundColor: UIColor.black,
////            .font: UIFont.init(name: APP_FONT_LIGHT, size: 12.0) as Any
//        ]

//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
//
        navigationController?.navigationBar.tintColor = UIColor.blue
        
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light


        // Do any additional setup after loading the view.
    }
    

   
}
