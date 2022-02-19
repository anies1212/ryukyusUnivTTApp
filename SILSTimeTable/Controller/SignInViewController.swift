//
//  SignInViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie

class SignInViewController: UIViewController , UITextFieldDelegate{
    
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loadAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        return animationView
    }()
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var blueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        
        cancelButton.setTitle("", for: .normal)
//        let backImage = UIImage(named: "iconCancel25")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cancelButton.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = .systemBlue
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.7546748519, green: 0.6017797589, blue: 0.8982691765, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
        ]

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        showAnimation()
        
        logInButton.layer.cornerRadius = 10.0
        
        blueView.backgroundColor = UIColor(red: 0.20392157, green: 0.21176471, blue: 0.41176471, alpha: 1.0)
        
    }
//    490
    func showAnimation() {
        let animationView = AnimationView(name: "school")
//        animationView.frame = CGRect(x: 0, y: 490, width: view.bounds.width/1.5, height: view.bounds.height/1.5) view.bounds.height/1.005
        animationView.frame = CGRect(x: view.frame.width/500, y: view.frame.height/1.75, width: view.bounds.width/1.005, height: 300)
//        animationView.frame = view.bounds
//           animationView.center = self.view.center
           animationView.loopMode = .loop
           animationView.contentMode = .scaleAspectFit
           animationView.animationSpeed = 1

           view.addSubview(animationView)

           animationView.play()
       }
    
    // キーボードの完了ボタン押したときに呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボード閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // ログイン処理
    @IBAction func signIn(){
//        HUD.show(.progress)
        startLoading()
        if userIdTextField.text == nil && passwordTextField.text == nil{
            HUD.show(.error)
        } else {
            
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    
                    let alertController = UIAlertController(title: "パスワード、もしくはIDが間違っています。", message: "確認ください。", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        alertController.dismiss(animated: true, completion: nil)
//                        HUD.hide()
                        self.stopLoading()
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    HUD.flash(.success)
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                
                }
                
            }
            
        }
        
    }
    
    // 好きなタイミングでこれを呼ぶとアニメーションが始まる.
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }

    // 好きなタイミングでこれを呼ぶとアニメーションのViewが消える.
    func stopLoading() {
        loadingView.removeFromSuperview()
    }
    
    @IBAction func crossButtonFunc(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
