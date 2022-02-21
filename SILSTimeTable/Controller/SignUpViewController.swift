//
//  SignUpViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie
import SwiftyPickerPopover

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loadAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        return animationView
    }()
    
    @IBOutlet var userIdTextField:UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField:UITextField!
    @IBOutlet var confirmTextField:UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var departmentSelectButton: UIButton!
    @IBOutlet var depExpertSelectedLabel: UILabel!
    @IBOutlet var gradeSelectButton: UIButton!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        signUpButton.layer.cornerRadius = 10.0
        departmentSelectButton.layer.cornerRadius = 10.0
        gradeSelectButton.layer.cornerRadius = 10
        self.depExpertSelectedLabel.adjustsFontSizeToFitWidth = true
        gradeLabel.adjustsFontSizeToFitWidth = true
        cancelButton.setTitle("", for: .normal)
//        let backImage = UIImage(named: "iconCancel25")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cancelButton.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = .systemBlue


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 新規登録処理
    @IBAction func signUp(){
        
//        HUD.show(.progress)
        startLoading()
        
        let user = NCMBUser()
        if userIdTextField.text!.count <= 3{
            print("luck letters")
            
            let alert = UIAlertController(title: "パスワード、もしくはIDが利用不可能です。", message: "IDとパスワードは４文字以上でなければなりません。 また、パスワードは一致していなければいけません。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.stopLoading()
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.stopLoading()
            return
        }
        let address:String = emailTextField.text!
        if (address.hasSuffix("u-ryukyu.ac.jp")) { //trueのとき
           print("u-ryukyu.ac.jpで終わる文字列")
            user.mailAddress = emailTextField.text!
        }else{
           print("u-ryukyu.ac.jpで終わらない文字列")
            print ("Wrong mailadress!")
            let alert = UIAlertController(title: "メールアドレスが間違っています。", message: "琉大のメールアドレスでなければいけません。"
        , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.stopLoading()
            return
            
        }
        
        user.userName = userIdTextField.text!
        

        if passwordTextField.text == confirmTextField.text{
            user.password = passwordTextField.text!
        } else {
            print ("Wrong Password!")
            let alert = UIAlertController(title: "パスワード、もしくはIDが間違っています。", message: "IDとパスワードは４文字以上でなければなりません。 また、パスワードは一致していなければいけません。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            self.stopLoading()
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if depExpertSelectedLabel.text != "Department / Expert"{
            user.add(depExpertSelectedLabel.text, forKey: "depExpert")
            
            DispatchQueue.main.asyncAfter(deadline:.now()+1.0){
                let object = NCMBObject(className: "DepartmentExpert")
                object?.setObject(self.depExpertSelectedLabel.text, forKey: "departmentExpert")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.saveInBackground({ (error) in
                    if error != nil{
                        HUD.show(.error)
                    } else {
                        print("success")
                    }
                })
            }
            
        } else {
            let alert = UIAlertController(title: "学部学科の登録をしてください。", message: "学部学科ボタンから登録可能です。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            self.stopLoading()
            return
        }
        
        if gradeLabel.text != "Grade"{
            user.add(gradeLabel.text, forKey: "grade")
            DispatchQueue.main.asyncAfter(deadline:.now()+1.0){
                let object = NCMBObject(className: "Grade")
                object?.setObject(self.gradeLabel.text, forKey: "grade")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.saveInBackground({ (error) in
                    if error != nil{
                        HUD.show(.error)
                    } else {
                        print("success")
                    }
                })
            }
        } else {
            let alert = UIAlertController(title: "学年の登録をしてください。", message: "学年ボタンから登録可能です。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            self.stopLoading()
            return
        }
        
        user.signUpInBackground { (error) in
            if error != nil {
                print (error)
                let alert = UIAlertController(title: "すでに存在するユーザー名、パスワードです。もしくはメールアドレスが間違えています。", message: "別のユーザー名、パスワードでの作成。もしくはメールアドレスの確認をお願いします。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                self.stopLoading()
                
            } else {
                self.stopLoading()
                HUD.show(.success)
                //画面の切り替え
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootVC")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                HUD.flash(.success)
                
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
        }
    }
    
//    xxxx@eve.u-ryukyu.ac.jp

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
    
    @IBAction func departmentSelectButtonFunc(){
        let displayStringFor:((String?)->String?)? = { string in
           if let s = string {
              switch(s){
              case "国際地域創造学部 - 専攻プログラムなし":
                  return "国際地域創造学部 - 専攻プログラムなし"
              case "国際地域創造学部 - 地域文化プログラム":
                  return "国際地域創造学部 - 地域文化プログラム"
              case "国際地域創造学部 - 観光地域デザインプログラム":
                  return "国際地域創造学部 - 観光地域デザインプログラム"
              case "国際地域創造学部 - 経営プログラム":
                  return "国際地域創造学部 - 経営プログラム"
              case "国際地域創造学部 - 経済学プログラム":
                 return "国際地域創造学部 - 経済学プログラム"
              case "国際地域創造学部 - 国際言語文化プログラム":
                  return "国際地域創造学部 - 国際言語文化プログラム"
              case "人文社会学部 - 専攻プログラムなし":
                  return "人文社会学部 - 専攻プログラムなし"
              case "人文社会学部 - 国際法政学科":
                  return "人文社会学部 - 国際法政学科"
              case "人文社会学部 - 人間社会学科":
                  return "人文社会学部 - 人間社会学科"
              case "人文社会学部 - 国琉球アジア文化学科":
                  return "人文社会学部 - 国琉球アジア文化学科"
              case "教育学部 - 小学校教育コース":
                  return "教育学部 - 小学校教育コース"
              case "教育学部 - 中学校教育コース":
                  return "教育学部 - 中学校教育コース"
              case "教育学部 - 特別支援教育コース":
                  return "教育学部 - 特別支援教育コース"
              case "理学部 - 数理科学科":
                  return "理学部 - 数理科学科"
              case "理学部 - 物質地球科学科 - 物理系":
                  return "理学部 - 物質地球科学科 - 物理系"
              case "理学部 - 物質地球科学科 - 地学系":
                  return "理学部 - 物質地球科学科 - 地学系"
              case "理学部 - 海洋自然科学科 - 化学系":
                  return "理学部 - 海洋自然科学科 - 化学系"
              case "理学部 - 海洋自然科学科 - 生物系":
                  return "理学部 - 海洋自然科学科 - 生物系"
              case "医学部 - 医学科":
                  return "医学部 - 医学科"
              case "医学部 - 保健学科":
                  return "医学部 - 保健学科"
              case "工学部 - 機械工学コース":
                  return "工学部 - 機械工学コース"
              case "工学部 - エネルギー環境工学コース":
                  return "工学部 - エネルギー環境工学コース"
              case "工学部 - 電気システム工学コース":
                  return "工学部 - 電気システム工学コース"
              case "工学部 - 電子情報通信コース":
                  return "工学部 - 電子情報通信コース"
              case "工学部 - 社会基盤デザインコース":
                  return "工学部 - 社会基盤デザインコース"
              case "工学部 - 建築学コース":
                  return "工学部 - 建築学コース"
              case "工学部 - 知能情報コース":
                  return "工学部 - 知能情報コース"
              case "農学部 - 亜熱帯地域農学科":
                  return "農学部 - 亜熱帯地域農学科"
              case "農学部 - 亜熱帯農林環境科学科":
                  return "農学部 - 亜熱帯農林環境科学科"
              case "農学部 - 地域農業工学科":
                  return "農学部 - 地域農業工学科"
              case "農学部 - 亜熱帯生物資源科学科":
                  return "農学部 - 亜熱帯生物資源科学科"
             
              default:
                 return s
              }
            }
            
          return nil
          }
                
        let p = StringPickerPopover(title: "StringPicker", choices: ["国際地域創造学部 - 専攻プログラムなし","国際地域創造学部 - 地域文化プログラム", "国際地域創造学部 - 観光地域デザインプログラム","国際地域創造学部 - 経営プログラム","国際地域創造学部 - 経済学プログラム", "国際地域創造学部 - 国際言語文化プログラム", "人文社会学部 - 専攻プログラムなし", "人文社会学部 - 国際法政学科", "人文社会学部 - 人間社会学科", "人文社会学部 - 国琉球アジア文化学科", "教育学部 - 小学校教育コース", "教育学部 - 中学校教育コース", "教育学部 - 特別支援教育コース", "理学部 - 数理科学科", "理学部 - 物質地球科学科 - 物理系", "理学部 - 物質地球科学科 - 地学系", "理学部 - 海洋自然科学科 - 化学系", "理学部 - 海洋自然科学科 - 生物系", "医学部 - 医学科", "医学部 - 保健学科", "工学部 - 機械工学コース", "工学部 - エネルギー環境工学コース", "工学部 - 電気システム工学コース", "工学部 - 電子情報通信コース", "工学部 - 社会基盤デザインコース", "工学部 - 建築学コース", "工学部 - 知能情報コース", "農学部 - 亜熱帯地域農学科", "農学部 - 亜熱帯農林環境科学科", "農学部 - 地域農業工学科", "農学部 - 亜熱帯生物資源科学科"])
                    .setDisplayStringFor(displayStringFor)
                    .setDoneButton(action: {
                        popover, selectedRow, selectedString in
                        print("done row \(selectedRow) \(selectedString)")
                        self.depExpertSelectedLabel.text = selectedString
                        
                    })
                    .setCancelButton(action: { _, _, _ in
                        print("cancel")
                    })
                p.appear(originView: departmentSelectButton, baseViewController: self)
//                p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
        
        
    }
    
    @IBAction func gradeSelectButtonFunc(){
        let displayStringFor:((String?)->String?)? = { string in
           if let s = string {
              switch(s){
              case "1年生":
                  return "1年生"
              case "2年生":
                  return "2年生"
              case "3年生":
                  return "3年生"
              case "4年生":
                  return "4年生"
              case "5年生":
                 return "5年生"
              case "その他":
                  return "その他"
              
              default:
                 return s
              }
            }
            
          return nil
          }
                
        let p = StringPickerPopover(title: "StringPicker", choices: ["1年生","2年生", "3年生","4年生","5年生", "その他"])
                    .setDisplayStringFor(displayStringFor)
                    .setDoneButton(action: {
                        popover, selectedRow, selectedString in
//                        print("done row \(selectedRow) \(selectedString)")
                        self.gradeLabel.text = selectedString
                    })
                    .setCancelButton(action: { _, _, _ in
                        print("cancel")
                    })
                p.appear(originView: gradeSelectButton, baseViewController: self)
    }
    


}
