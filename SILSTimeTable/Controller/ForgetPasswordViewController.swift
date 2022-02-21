//
//  ForgetPasswordViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NCMB

class ForgetPasswordViewController: UIViewController {

    @IBOutlet var emailTF: SkyFloatingLabelTextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.setTitle("", for: .normal)
        cancelButton.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = .systemBlue

        sendButton.layer.cornerRadius = 8
        
        
    }
    
    
    @IBAction func crossButtonFunc(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func passwordResetFunc(){
        
        if emailTF.text != ""{
            
            NCMBUser.requestPasswordReset(forEmail: emailTF.text, error: nil)
            let alertController = UIAlertController(title: "受信ボックスをご確認ください。", message: "入力したメールアドレスにパスワード設定用のリンクが送信されました。そちらから再設定を行ってください。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("no text")
        }
    }
}
