//
//  TermsOfUseViewController.swift
//  SILSTimeTable
//
//  Created by 新垣清奈 on 2021/09/10.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import  UIKit

class TermsOfUseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
        
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        // ボタンのインスタンス生成
        let button = UIButton()
        button.frame = CGRect(x:10, y:0,
                              width:60, height:60)
        button.setTitle("", for:UIControl.State.normal)
        button.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self,
                         action: #selector(crossButtonFunc),
                         for: .touchUpInside)
        self.view.bringSubviewToFront(button)
        self.view.addSubview(button)

        // Do any additional setup after loading the view.
    }
    
    @objc func crossButtonFunc(){
        self.dismiss(animated: true, completion: nil)
    }
}
